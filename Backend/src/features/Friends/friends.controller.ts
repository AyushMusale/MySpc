import type { Response } from "express";

import { prisma } from "../../lib/prisma.js";
import { FriendStatus, Prisma } from "../../generated/prisma/client.js";
import type { AuthenticatedRequest } from "../Auth/auth.middleware.js";
import {
  friendSearchSchema,
  sendFriendRequestSchema,
} from "./friends.validator.js";
import { levenshteinDistance } from "../../utils/levenstein.js";
import { friendService } from "../../services/friends.service.js";

const RESULT_LIMIT = 15;
// How many trigram-matched candidates to pull from Postgres before
// re-ranking by Levenshtein distance in JS.
const CANDIDATE_POOL = 50;

interface UsernameCandidate {
  username: string;
  userId: number;
  sim: number;
}

export const searchFriendsController = async (
  req: AuthenticatedRequest,
  res: Response,
) => {
  try {
    // req.user is guaranteed by authMiddleware running before this controller
    if (!req.user) {
      return res.status(401).json({ success: false, message: "invalid user" });
    }

    // 1. Validate query param
    const parsed = friendSearchSchema.safeParse({
      username: req.query.username,
    });

    if (!parsed.success) {
      return res.status(400).json({
        success: false,
        message: parsed.error.issues[0]?.message || "Invalid input",
      });
    }

    const { username: query } = parsed.data;

    // 2. Fuzzy search in Postgres via pg_trgm.
    // `%` is the trigram similarity operator (uses the GIN index, respects
    // pg_trgm.similarity_threshold — default 0.3). We also OR in a plain
    // ILIKE substring check so short/edge-case queries where trigram
    // similarity alone under-matches still surface exact substrings.
    const candidates = await prisma.$queryRaw<UsernameCandidate[]>(Prisma.sql`
      SELECT
        username,
        "userId",
        similarity(username, ${query}) AS sim
      FROM "Profile"
      WHERE
        (username % ${query} OR username ILIKE ${`%${query}%`})
        AND "userId" != ${req.user.userId}
      ORDER BY sim DESC
      LIMIT ${CANDIDATE_POOL}
    `);

    if (candidates.length === 0) {
      return res.status(200).json({ success: true, users: [] });
    }

    // 3. Re-rank the trigram-matched candidates by Levenshtein distance —
    // gives a cleaner "closest spelling first" ordering than raw trigram
    // similarity alone, which can be noisy for short strings.
    const ranked = candidates
      .map((c) => ({
        username: c.username,
        userId: c.userId,
        distance: levenshteinDistance(query, c.username.toLowerCase()),
      }))
      .sort((a, b) => a.distance - b.distance)
      .slice(0, RESULT_LIMIT)
      .map(({ username, userId }) => ({ username, userId }));

    return res.status(200).json({
      success: true,
      users: ranked,
    });
  } catch (err) {
    console.error("searchFriendsController error:", err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong while searching for users",
    });
  }
};

export const sendFriendRequestController = async (
  req: AuthenticatedRequest,
  res: Response,
) => {
  const parsed = sendFriendRequestSchema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({
      success: false,
      msg: "invalid request body",
      errors: parsed.error.flatten(),
    });
  }

  const { receiverId } = parsed.data;
  const senderUserId = req.user!.userId; // set by auth middleware

  if (senderUserId === receiverId) {
    return res
      .status(400)
      .json({ success: false, msg: "cannot send friend request to yourself" });
  }

  try {
    const [senderHasProfile, receiverHasProfile] = await Promise.all([
      friendService.profileExists(senderUserId),
      friendService.profileExists(receiverId),
    ]);

    if (!senderHasProfile) {
      return res
        .status(404)
        .json({ success: false, msg: "sender profile not found" });
    }

    if (!receiverHasProfile) {
      return res
        .status(404)
        .json({ success: false, msg: "receiver does not exist" });
    }

    const existing = await friendService.findFriendship(
      senderUserId,
      receiverId,
    );

    if (existing) {
      if (existing.status === FriendStatus.accepted) {
        return res.status(409).json({ success: false, msg: "already friends" });
      }
      if (existing.status === FriendStatus.pending) {
        return res
          .status(409)
          .json({ success: false, msg: "friend request already pending" });
      }
      // blocked
      return res
        .status(403)
        .json({ success: false, msg: "cannot send friend request" });
    }

    const friendRequest = await friendService.createFriendRequest(
      senderUserId,
      receiverId,
    );

    return res.status(201).json({ success: true, data: friendRequest });
  } catch (err) {
    console.error("sendFriendRequestController error:", err);
    return res
      .status(500)
      .json({ success: false, msg: "internal server error" });
  }
};

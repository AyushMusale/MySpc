import type { Response } from "express";

import { FriendStatus } from "../../generated/prisma/client.js";
import type { AuthenticatedRequest } from "../Auth/auth.middleware.js";
import { friendService } from "../../services/friends.service.js";
import { spaceService } from "../../services/spaces.service.js";
import { createDmSpaceSchema } from "./spaces.validator.js";
import { profileService } from "../../services/profile.service.js";

export const createDmSpaceController = async (
  req: AuthenticatedRequest,
  res: Response,
) => {
  const parsed = createDmSpaceSchema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({
      success: false,
      message: parsed.error.issues[0]?.message || "Invalid input",
    });
  }

  const requesterId = req.user!.userId;
  const { memberId } = parsed.data;
  const isSelfDm = requesterId === memberId;

  try {
    const member = await profileService.getProfile(memberId);

    if (!member) {
      return res.status(404).json({
        success: false,
        message: "member does not exist",
      });
    }

    if (!member.user.isVerified) {
      return res.status(403).json({
        success: false,
        message: "member is not active",
      });
    }

    if (!isSelfDm) {
      const friendship = await friendService.findFriendship(
        requesterId,
        memberId,
      );

      if (!friendship || friendship.status !== FriendStatus.accepted) {
        return res.status(403).json({
          success: false,
          message: "you can only create a DM with an accepted friend",
        });
      }
    }

    const existingSpace = await spaceService.findExistingDmSpace(
      requesterId,
      memberId,
    );

    if (existingSpace) {
      return res.status(200).json({
        success: true,
        message: "space already exists",
        spaceId: existingSpace.id,
      });
    }

    const space = await spaceService.createDmSpace(requesterId, memberId);

    return res.status(201).json({
      success: true,
      spaceId: space.id,
      message: "DM space created",
    });
  } catch (err) {
    console.error("createDmSpaceController error:", err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong while creating DM space",
    });
  }
};

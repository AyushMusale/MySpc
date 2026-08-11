import { prisma } from "../lib/prisma.js";
import { FriendStatus } from "../generated/prisma/client.js";

export const friendService = {
  async profileExists(userId: number) {
    const profile = await prisma.profile.findUnique({ where: { userId } });
    return profile !== null;
  },

  async findFriendship(userIdA: number, userIdB: number) {
    return prisma.friend.findFirst({
      where: {
        OR: [
          { profile1Id: userIdA, profile2Id: userIdB },
          { profile1Id: userIdB, profile2Id: userIdA },
        ],
      },
    });
  },

  async createFriendRequest(senderUserId: number, receiverUserId: number) {
    return prisma.friend.create({
      data: {
        profile1Id: senderUserId,
        profile2Id: receiverUserId,
        status: FriendStatus.pending,
      },
    });
  },

  async getPendingFriendRequests(userId: number) {
    try {
      const requests = await prisma.friend.findMany({
        where: {
          profile2Id: userId,
          status: "pending",
        },
        include: {
          profile1: {
            select: {
              userId: true,
              username: true,
            },
          },
        },
      });

      return requests.map((req) => ({
        userId: req.profile1.userId,
        username: req.profile1.username,
      }));
    } catch (err) {
      console.error("Error fetching pending friend requests:", err);
      throw err;
    }
  },

  async getFriendshipByIds(profile1Id: number, profile2Id: number) {
    return prisma.friend.findUnique({
      where: {
        profile1Id_profile2Id: {
          profile1Id,
          profile2Id,
        },
      },
    });
  },

  async updateFriendshipStatus(
    profile1Id: number,
    profile2Id: number,
    status: FriendStatus,
  ) {
    return prisma.friend.update({
      where: {
        profile1Id_profile2Id: {
          profile1Id,
          profile2Id,
        },
      },
      data: { status },
    });
  },
};

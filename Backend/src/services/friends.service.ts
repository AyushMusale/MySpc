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
};

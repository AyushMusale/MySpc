import { prisma } from "../lib/prisma.js";

export const profileService = {
  async getProfile(userId: number) {
    return prisma.profile.findUnique({
      where: { userId },
      include: { user: { select: { isVerified: true } } },
    });
  },
};

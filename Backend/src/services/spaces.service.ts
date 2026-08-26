import { prisma } from "../lib/prisma.js";
import { SpaceRole, SpaceType } from "../generated/prisma/client.js";

export const spaceService = {
  async findExistingDmSpace(userIdA: number, userIdB: number) {
    if (userIdA === userIdB) {
      return prisma.space.findFirst({
        where: {
          type: SpaceType.dm,
          members: {
            some: { profileId: userIdA },
            every: { profileId: userIdA },
          },
        },
        select: { id: true },
      });
    }

    return prisma.space.findFirst({
      where: {
        type: SpaceType.dm,
        AND: [
          { members: { some: { profileId: userIdA } } },
          { members: { some: { profileId: userIdB } } },
        ],
      },
      select: { id: true },
    });
  },

  async createDmSpace(createdById: number, memberId: number) {
    const members =
      createdById === memberId
        ? [{ profileId: createdById, role: SpaceRole.member }]
        : [
            { profileId: createdById, role: SpaceRole.member },
            { profileId: memberId, role: SpaceRole.member },
          ];

    return prisma.space.create({
      data: {
        type: SpaceType.dm,
        createdById,
        members: { create: members },
      },
      select: { id: true },
    });
  },
};

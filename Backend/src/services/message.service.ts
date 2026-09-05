import { prisma } from "../lib/prisma.js";
import { MessageType } from "../generated/prisma/client.js";

export const messageService = {

  async getSpaceMembers(spaceId: number): Promise<number[]> {
    const members = await prisma.spaceMember.findMany({
      where: { spaceId },
      select: { profileId: true },
    });
    return members.map((m) => m.profileId);
  },

  async saveMessage(data: {
    spaceId: number;
    senderId: number;
    type: MessageType;
    content: string | undefined;
    mediaUrl: string | undefined;
    thumbnailUrl: string | undefined;
  }) {
    const [message] = await prisma.$transaction([
      prisma.message.create({
        data: {
          spaceId: data.spaceId,
          senderId: data.senderId,
          type: data.type,
          content: data.content ?? "no-content",
          mediaUrl: data.mediaUrl ?? "no-media-url",
          thumbnailUrl: data.thumbnailUrl ?? "no-thumbnail-url",
        },
        select: {
          id: true,
          spaceId: true,
          senderId: true,
          type: true,
          content: true,
          mediaUrl: true,
          createdAt: true,
        },
      }),
      prisma.space.update({
        where: { id: data.spaceId },
        data: { lastMessageAt: new Date() },
      }),
    ]);

    return message;
  },
};

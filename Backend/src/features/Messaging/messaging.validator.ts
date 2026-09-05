import { z } from "zod";
import { MessageType } from "../../generated/prisma/client.js";


export const sendMessageSchema = z.object({
  spaceId: z.number({ error: "spaceId is required" }).int().positive(),
  msg: z.string().optional(),
  mediaUrl: z.string().optional(),
  thumbnailUrl: z.string().optional(),
  msg_type: z.enum(MessageType, {
    error: "msg_type is required",
    message: "invalid msg_type",
  }),
  time: z.string({ error: "time is required" }),
  deviceId: z.string({ error: "deviceId is required" }),
});

export type SendMessagePayload = z.infer<typeof sendMessageSchema>;

import { z } from "zod";

export const friendSearchSchema = z.object({
  username: z
    .string({ error: "Username is required" })
    .trim()
    .toLowerCase()
    .min(1, "Username query cannot be empty")
    .max(20, "Username query too long"),
});

export const sendFriendRequestSchema = z.object({
  receiverId: z.number().int().positive(),
});

export type SendFriendRequestInput = z.infer<typeof sendFriendRequestSchema>;

export type FriendSearchInput = z.infer<typeof friendSearchSchema>;

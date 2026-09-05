import type { Server, Socket } from "socket.io";
import { messageService } from "../../services/message.service.js";
import { sendMessageSchema } from "./messaging.validator.js";


export function registerMessagingHandler(io: Server, socket: Socket) {
  socket.on("send_message", async (raw: unknown) => {
    const { userId } = socket.data.user;

    // ── 1. Validate payload ──────────────────────────────────────────────────
    const parsed = sendMessageSchema.safeParse(raw);
    if (!parsed.success) {
      socket.emit("error", {
        event: "send_message",
        message: parsed.error.issues[0]?.message ?? "Invalid payload",
      });
      return;
    }

    const { spaceId, msg, mediaUrl, thumbnailUrl, msg_type, time, deviceId } = parsed.data;

    // ── 2. Verify sender membership ──────────────────────────────────────────
    const members = await messageService.getSpaceMembers(spaceId);
    const isMember = members.includes(userId);

    if (!isMember) {
      socket.emit("error", {
        event: "send_message",
        message: "You are not a member of this space",
      });
      return;
    }

    // ── 3. Persist message ───────────────────────────────────────────────────
    const saved = await messageService.saveMessage({
      spaceId,
      senderId: userId,
      type: msg_type,
      content: msg,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
    });

    // ── 4 & 5. Fan-out to every member except the sender ────────────────────
    const outboundPayload = {
      spaceId: saved.spaceId,
      msg: saved.content,
      msg_type: saved.type,
      time,
      by: userId,
      deviceId,
      id: saved.id,
      createdAt: saved.createdAt,
    };

    for (const memberId of members) {
      if (memberId === userId) continue; // skip sender
      io.to(String(memberId)).emit("new_message", outboundPayload);
    }
  });
}

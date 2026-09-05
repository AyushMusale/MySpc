import type { Server as HttpServer } from "http";
import { Server } from "socket.io";
import {
  socketAuthMiddleware,
  type SocketUser,
} from "./socketAuth.middleware.js";
import { registerMessagingHandler } from "../features/Messaging/messaging.handler.js";

declare module "socket.io" {
  interface SocketData {
    user: SocketUser;
  }
}

export function attachSocketIo(httpServer: HttpServer) {
  const io = new Server(httpServer, {
    cors: {
      origin: process.env.FRONTEND_URL,
      credentials: true,
    },
  });

  io.use(socketAuthMiddleware);

  io.on("connection", (socket) => {
    const { userId } = socket.data.user;
    const room = String(userId);

    socket.join(room);

    socket.emit("connected", {
      message: "hello from MySpc",
      userId,
      room,
    });

    // ── Feature handlers ───────────────────────────────────────────────────
    registerMessagingHandler(io, socket);

    socket.on("disconnect", () => { });
  });

  return io;
}

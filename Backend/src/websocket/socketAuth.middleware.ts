import type { Socket } from "socket.io";
import { verifyAccessToken } from "../services/tokens.service.js";

export interface SocketUser {
  userId: number;
  email: string;
}

function getAccessToken(socket: Socket): string | undefined {
  const authToken = socket.handshake.auth.token;
  if (typeof authToken === "string" && authToken.length > 0) {
    return authToken;
  }

  const header = socket.handshake.headers.authorization;
  if (typeof header === "string" && header.startsWith("Bearer ")) {
    return header.slice("Bearer ".length);
  }

  const cookieHeader = socket.handshake.headers.cookie;
  if (!cookieHeader) return undefined;

  const accessCookie = cookieHeader
    .split(";")
    .map((part) => part.trim())
    .find((part) => part.startsWith("accessToken="));

  if (!accessCookie) return undefined;

  return decodeURIComponent(accessCookie.slice("accessToken=".length));
}

export function socketAuthMiddleware(
  socket: Socket,
  next: (err?: Error) => void,
) {
  try {
    const token = getAccessToken(socket);
    if (!token) {
      return next(new Error("invalid user"));
    }

    const payload = verifyAccessToken(token);
    socket.data.user = {
      userId: payload.userId,
      email: payload.email,
    };
    next();
  } catch {
    next(new Error("invalid user"));
  }
}

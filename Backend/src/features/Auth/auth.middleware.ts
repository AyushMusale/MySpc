import type { Request, Response, NextFunction } from "express";
import {
  verifyAccessToken,
  verifyRefreshToken,
  generateTokens,
} from "../../services/tokens.service.js";

export interface AuthenticatedRequest extends Request {
  user?: {
    userId: number;
    email: string;
  };
}

/**
 * Flow (per diagram):
 * 1. Verify access token.
 *    - valid  -> attach { userId, email } to req, call next()
 * 2. If access token invalid -> verify refresh token.
 *    - invalid -> 401 { success: false, msg: "invalid user" }
 *    - valid   -> issue new access + refresh tokens, return them to the
 *                 client so it can retry the original request
 *                 (this middleware does NOT call next() in this branch —
 *                 the client is expected to retry with the new tokens).
 */
export const authMiddleware = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction,
) => {
  try {
    const accessToken =
      req.cookies?.accessToken || req.headers.authorization?.split(" ")[1];
    const refreshToken =
      req.cookies?.refreshToken ||
      (req.headers["x-refresh-token"] as string | undefined) ||
      req.body?.refreshToken;

    if (!accessToken) {
      return res.status(401).json({ success: false, msg: "invalid user" });
    }

    const accessPayload = verifyAccessToken(accessToken);

    if (accessPayload) {
      req.user = {
        userId: accessPayload.userId,
        email: accessPayload.email,
      };
      return next();
    }

    // Access token invalid/expired -> fall back to refresh token
    if (!refreshToken) {
      return res.status(401).json({ success: false, msg: "invalid user" });
    }

    const refreshPayload = verifyRefreshToken(refreshToken);

    if (!refreshPayload) {
      return res.status(401).json({ success: false, msg: "invalid user" });
    }

    // Refresh token valid -> issue new pair, let client retry
    const { accessToken: newAccessToken, refreshToken: newRefreshToken } =
      generateTokens({
        userId: refreshPayload.userId,
        email: refreshPayload.email,
      });

    // Cookies are only meaningful for web clients (browsers maintain a
    // cookie jar automatically). Native mobile clients (React Native)
    // don't consume Set-Cookie by default, so setting it there is inert —
    // harmless, but pointless. We skip it and rely on the JSON body
    // instead, which every client type can read and persist itself.
    const clientType = req.headers["x-client-type"];

    if (clientType === "web") {
      res.cookie("accessToken", newAccessToken, {
        httpOnly: true,
        secure: true,
        sameSite: "strict",
      });
      res.cookie("refreshToken", newRefreshToken, {
        httpOnly: true,
        secure: true,
        sameSite: "strict",
      });
    }

    return res.status(200).json({
      success: true,
      msg: "tokens refreshed, please retry",
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    });
  } catch (err) {
    console.error("Auth middleware error:", err);
    return res.status(401).json({ success: false, msg: "invalid user" });
  }
};

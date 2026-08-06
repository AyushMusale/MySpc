import type { Request, Response } from "express";

import { prisma } from "../../../lib/prisma.js";
import { generateTokens } from "../../../services/tokens.service.js";
import { generateUniqueCode } from "../../../utils/generateUUID.js";
import { signupSchema } from "../auth.validator.js";

export const signupController = async (req: Request, res: Response) => {
  try {
    // 1. Validate the data
    const parsed = signupSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({
        success: false,
        message: parsed.error.issues[0]?.message || "Invalid input",
      });
    }

    const { email, displayName, username, avatarUrl } = parsed.data;

    // 2. Check if user already exists using email
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(409).json({ success: false, message: "user already exists" });
    }

    // 3. Check if same username exists
    const usernameTaken = await prisma.profile.findUnique({ where: { username } });
    if (usernameTaken) {
      return res.status(409).json({ success: false, message: "username already taken" });
    }

    // 4. Generate an 8-digit unique id for the user
    const userId = await generateUniqueCode();

    // 5. Create user with email and create user profile — simultaneously
    const { user, profile } = await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: { userId, email, isVerified: true },
      });

      const profile = await tx.profile.create({
        data: {
          userId: user.userId,
          username,
          displayName,
          avatarUrl: avatarUrl ?? null,
        },
      });

      return { user, profile };
    });

    // 6. Generate tokens
    const { accessToken, refreshToken } = generateTokens({ userId: user.userId, email: user.email });

    // 7. Respond
    return res.status(201).json({
      success: true,
      profile,
      accessToken,
      refreshToken,
    });
  } catch (err) {
    console.error("signupController error:", err);
    return res.status(500).json({ success: false, message: "Something went wrong while creating your account" });
  }
};
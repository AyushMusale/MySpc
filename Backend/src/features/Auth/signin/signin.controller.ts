import type { Request, Response } from "express";

import { sendOtpSchema, verifyOtpSchema } from "../auth.validator.js";
import { generateOtp } from "../../../utils/generateOTP.js";
import {
  deleteOtp,
  saveOtp,
  verifyOtp,
} from "../../../services/redis.service.js";
import { sendOtpEmail } from "../../../services/resend.service.js";
import { generateTokens } from "../../../services/tokens.service.js";
import { prisma } from "../../../lib/prisma.js";

export const sendOtpController = async (req: Request, res: Response) => {
  try {
    // 1. Validate the incoming string is a valid email
    const parsed = sendOtpSchema.safeParse(req.body);

    if (!parsed.success) {
      return res.status(400).json({
        success: false,
        message: parsed.error.issues[0]?.message || "Invalid input",
      });
    }

    const { email } = parsed.data;

    // // 2. Check if user exists — this is signin, so no account means nothing to send OTP for
    // const existingUser = await prisma.user.findUnique({ where: { email } });

    // if (!existingUser) {
    //   return res.status(404).json({
    //     success: false,
    //     msg: "user does not exists",
    //   });
    // }

    // 3. Generate OTP
    const otp = generateOtp(6);

    // 4. Save hashed-OTP in Redis (do this before/independent of email in case send fails, then retry)
    await saveOtp(email, otp);

    // 5. Send OTP via Resend
    await sendOtpEmail("aayushmusale05@gmail.com", otp);

    // 6. Respond
    return res.status(200).json({
      success: true,
      email,
    });
  } catch (err) {
    console.error("sendOtpController error:", err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong while sending OTP",
    });
  }
};

export const verifyOtpController = async (req: Request, res: Response) => {
  try {
    // 1. Validate the incoming { otp, email }
    const parsed = verifyOtpSchema.safeParse(req.body);

    if (!parsed.success) {
      return res.status(400).json({
        success: false,
        message: parsed.error.issues[0]?.message || "Invalid input",
      });
    }

    const { email, otp } = parsed.data;

    // 2 & 3. Hash provided OTP internally and compare against stored hash in Redis
    const isValid = await verifyOtp(email, otp);

    if (!isValid) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired OTP",
      });
    }

    // OTP is correct — remove it so it can't be reused
    await deleteOtp(email);

    // 4. Find user using email to get their userId
    const user = await prisma.user.findUnique({
      where: { email },
      include: { profile: true },
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "No account found, please sign up",
      });
    }

    // 5. Generate tokens using the found userId + email
    const { accessToken, refreshToken } = generateTokens({
      userId: user.userId,
      email: user.email,
    });

    // 6. Respond
    return res.status(200).json({
      success: true,
      profile: user.profile,
      accessToken,
      refreshToken,
    });
  } catch (err) {
    console.error("verifyOtpController error:", err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong while verifying OTP",
    });
  }
};
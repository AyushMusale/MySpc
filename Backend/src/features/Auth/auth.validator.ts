import { z } from "zod";

export const sendOtpSchema = z.object({
  email: z
    .string({ "error": "Email is required" })
    .trim()
    .toLowerCase()
    .email("Please provide a valid email address"),
});

export const verifyOtpSchema = z.object({
  email: z
    .string({ "error": "Email is required" })
    .trim()
    .toLowerCase()
    .email("Please provide a valid email address"),
  otp: z
    .string({ "error": "OTP is required" })
    .trim()
    .length(6, "OTP must be 6 digits")
    .regex(/^\d+$/, "OTP must contain only digits"),
});


export const signupSchema = z.object({
  email: z
    .string({ "error": "Email is required" })
    .trim()
    .toLowerCase()
    .email("Please provide a valid email address"),

  displayName: z
    .string({ "error": "Display name is required" })
    .trim()
    .min(2, "Display name must be at least 2 characters")
    .max(32, "Display name must be under 32 characters"),

  username: z
    .string({ "error": "Username is required" })
    .trim()
    .toLowerCase()
    .min(3, "Username must be at least 3 characters")
    .max(20, "Username must be under 20 characters")
    .regex(/^[a-z0-9_]+$/, "Username can only contain lowercase letters, numbers, and underscores"),

  avatarUrl: z.string().trim().url("Invalid avatar URL").optional(),
});



export type SignupInput = z.infer<typeof signupSchema>;
export type SendOtpInput = z.infer<typeof sendOtpSchema>;
export type VerifyOtpInput = z.infer<typeof verifyOtpSchema>;
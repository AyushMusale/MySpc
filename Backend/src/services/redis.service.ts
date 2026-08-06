import { Redis } from "@upstash/redis";
import { createHash } from "crypto";

export const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL as string,
  token: process.env.UPSTASH_REDIS_REST_TOKEN as string,
});

const OTP_PREFIX = "otp:";
const OTP_TTL_SECONDS = 5 * 60; // 5 minutes

// Hash the OTP before storing/comparing
const hashOtp = (otp: string): string => {
  const secret = process.env.OTP_HASH_SECRET || "";
  return createHash("sha256")
    .update(otp + secret)
    .digest("hex");
};

export const saveOtp = async (email: string, otp: string) => {
  const hashed = hashOtp(otp);
  await redis.set(`${OTP_PREFIX}${email}`, hashed, { ex: OTP_TTL_SECONDS });
};

// Compares a plaintext OTP against the stored hash. Returns true if it matches.
export const verifyOtp = async (email: string, otp: string): Promise<boolean> => {
  const storedHash = await redis.get<string>(`${OTP_PREFIX}${email}`);
  if (!storedHash) return false;

  const incomingHash = hashOtp(otp);
  return storedHash === incomingHash;
};

export const deleteOtp = async (email: string) => {
  await redis.del(`${OTP_PREFIX}${email}`);
};
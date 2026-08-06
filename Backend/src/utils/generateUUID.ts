import { prisma } from "../lib/prisma.js";

const generateEightDigitCode = (): number => {
  return Math.floor(10000000 + Math.random() * 90000000);
};

export const generateUniqueCode = async (): Promise<number> => {
  const MAX_ATTEMPTS = 10;

  for (let i = 0; i < MAX_ATTEMPTS; i++) {
    const code = generateEightDigitCode();
    const existing = await prisma.user.findUniqueOrThrow({
      where:{
        userId: code
      }
    });
    if (!existing) return code;
  }

  throw new Error("Could not generate a unique code, please try again");
};
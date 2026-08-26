import { z } from "zod";

export const createDmSpaceSchema = z.object({
  memberId: z.number().int().positive(),
});

export type CreateDmSpaceInput = z.infer<typeof createDmSpaceSchema>;

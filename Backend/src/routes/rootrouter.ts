import express from "express"
import authRouter from "./authrouter.js"
import { authMiddleware } from "../features/Auth/auth.middleware.js";

export const rootRouter = express.Router()


rootRouter.use('/auth', authRouter);
rootRouter.use('/auth/test', authMiddleware);
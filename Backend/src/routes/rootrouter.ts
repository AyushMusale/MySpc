import express from "express"
import authRouter from "./authrouter.js"

export const rootRouter = express.Router()


rootRouter.use('/auth', authRouter)
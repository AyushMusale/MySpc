import { Router } from "express";
import {
  sendOtpController,
  verifyOtpController,
} from "../features/Auth/signin/signin.controller.js";
import { signupController } from "../features/Auth/signup/signup.controller.js";

const authRouter = Router();

authRouter.post("/send-otp", sendOtpController);
authRouter.post("/verify-otp", verifyOtpController);

authRouter.post("signup", signupController);

export default authRouter;

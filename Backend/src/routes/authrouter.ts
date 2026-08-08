import e, {
  Router,
  type NextFunction,
  type Request,
  type Response,
} from "express";
import {
  sendOtpController,
  verifyOtpController,
} from "../features/Auth/signin/signin.controller.js";
import { signupController } from "../features/Auth/signup/signup.controller.js";
import { verifyOtp } from "../services/redis.service.js";
import { email } from "zod";
import {
  signupValidator,
  type SignupRequest,
} from "../features/Auth/auth.validator.js";

const authRouter = Router();

authRouter.post("/send-otp", sendOtpController);
authRouter.post("/verify-otp", verifyOtpController);

authRouter.post(
  "/signup",
  signupValidator,
  (req: SignupRequest, res: Response, next: NextFunction) => {
    verifyOtp(req.parsedData!.email, req.parsedData!.otp);
    next();
  },
  signupController,
);

export default authRouter;

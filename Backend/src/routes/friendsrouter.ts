import { Router } from "express";
import {
  searchFriendsController,
  sendFriendRequestController,
} from "../features/Friends/friends.controller.js";
import { authMiddleware } from "../features/Auth/auth.middleware.js";

const friendsRouter = Router();

// Auth runs before the search so user identifiers are never exposed to guests.
friendsRouter.get("/search", authMiddleware, searchFriendsController);
friendsRouter.post("/request", authMiddleware, sendFriendRequestController);

export default friendsRouter;

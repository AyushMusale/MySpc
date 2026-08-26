import { Router } from "express";
import { createDmSpaceController } from "../features/DmSpaces/spaces.controller.js";

const spacesRouter = Router();

spacesRouter.post("/dm", createDmSpaceController);

export default spacesRouter;

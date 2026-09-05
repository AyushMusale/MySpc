import "dotenv/config";
import express from "express";
import cors from "cors";
import { createServer } from "http";
import { rootRouter } from "./src/routes/rootrouter.js";
import { attachSocketIo } from "./src/websocket/index.js";

const app = express();
const PORT = process.env.PORT;
const httpServer = createServer(app);

app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true,
}));
app.use(express.json());

app.use("/api/myspc", rootRouter);

attachSocketIo(httpServer);

httpServer.listen(PORT, () => {
  console.log(`Server is running on ${PORT} ...`);
});

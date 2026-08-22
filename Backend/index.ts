import "dotenv/config";
import express from "express";
import cors from "cors";
import { rootRouter } from "./src/routes/rootrouter.js";

const app = express();
const PORT = process.env.PORT;

app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true,
}));
app.use(express.json());

app.use("/api/myspc", rootRouter);

app.listen(PORT, () => {
  console.log(`Server is running on ${PORT} ...`);
});

import "dotenv/config";
import express from "express";
import { rootRouter } from "./src/routes/rootrouter.js";

const app = express();
const PORT = process.env.PORT;

app.use(express.json());

app.use("/api/myspc", rootRouter);

app.listen(PORT, () => {
  console.log(`Server is running on ${PORT} ...`);
});

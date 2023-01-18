import express, { Express, Request, Response } from "express";
import dotenv from "dotenv-safe";

dotenv.config();

const app: Express = express();
const port = process.env.PORT;

console.log(`Current ENV: ${process.env.ENV}`);

app.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server");
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

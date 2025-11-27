import dotenv from "dotenv";
import path from "path";
import fs from "fs";
import logger from "./logger.js";

const envPath = path.resolve(process.cwd(), "../.env");

if (!fs.existsSync(envPath)) {
  console.error(".env file not found at:", envPath);
  process.exit(1);
}

dotenv.config({ path: envPath });

const requiredVars = [
  "NODE_ENV",
  "FRONTEND_URL",
  "DATABASE_URL",
  "JWT_SECRET",
  "JWT_REFRESH_SECRET",
];

const missingVars = requiredVars.filter((v) => !process.env[v]);

if (missingVars.length > 0) {
  console.error(
    `Missing required environment variables: ${missingVars.join(", ")}`
  );
  process.exit(1);
}

logger.info("Environment variables loaded successfully.");

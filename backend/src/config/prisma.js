import { PrismaClient } from "../../generated/prisma/index.js";
import logger from "./logger.js";

const prisma = new PrismaClient({
  log: [
    { emit: "event", level: "query" },
    { emit: "event", level: "error" },
    { emit: "event", level: "warn" },
  ],
  errorFormat: "minimal",
});

async function connectPrisma() {
  try {
    prisma.$on("query", (event) => {
      if (process.env.NODE_ENV !== "production") {
        logger.info(`DB Query: ${event.query}`);
      }
    });

    prisma.$on("warn", (event) => {
      logger.warn(`DB Warning: ${event.message}`);
    });

    prisma.$on("error", (event) => {
      logger.error(`DB Error: ${event.message}`);
    });

    await prisma.$connect();
    logger.info("Connected to MySQL database successfully.");
  } catch (error) {
    logger.error(`Database connection failed: ${error.message}`);
    process.exit(1);
  }

  process.on("SIGINT", async () => {
    await prisma.$disconnect();
    logger.info("Prisma client disconnected gracefully (SIGINT).");
    process.exit(0);
  });

  process.on("SIGTERM", async () => {
    await prisma.$disconnect();
    logger.info("Prisma client disconnected gracefully (SIGTERM).");
    process.exit(0);
  });
}

connectPrisma();

export default prisma;

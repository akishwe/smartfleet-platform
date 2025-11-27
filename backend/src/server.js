import http from "http";
import app from "./app.js";
import "./config/envLoader.js";
import prisma from "./config/prisma.js";
import logger from "./config/logger.js";
import env from "./config/envValidator.js";

const PORT = env.PORT || 5000;
const server = http.createServer(app);

const startServer = async () => {
  try {
    await prisma.$connect();
    server.listen(PORT, () => {
      logger.info(
        `SmartFleet server running on port ${PORT} in ${env.NODE_ENV} mode`
      );
    });
  } catch (error) {
    logger.error("Failed to start server: " + error.message);
    process.exit(1);
  }
};

startServer();

process.on("uncaughtException", (error) => {
  logger.error("Uncaught Exception: " + error.message);
  process.exit(1);
});

process.on("unhandledRejection", (reason) => {
  logger.error("Unhandled Promise Rejection: " + reason);
  process.exit(1);
});

process.on("SIGINT", async () => {
  await prisma.$disconnect();
  logger.info("SmartFleet server stopped (SIGINT)");
  process.exit(0);
});

process.on("SIGTERM", async () => {
  await prisma.$disconnect();
  logger.info("SmartFleet server stopped (SIGTERM)");
  process.exit(0);
});

import express from "express";
import helmet from "helmet";
import cors from "./config/corsConfig.js";
import logger from "./config/logger.js";
import { globalLimiter, authLimiter } from "./middlewares/rateLimiter.js";
import errorHandler from "./middlewares/errorHandlers.js";
import { sanitizeLogs } from "./utils/sanitizeLogs.js";
import userRoutes from "./modules/user/user.routes.js";
import xss from "xss";

const app = express();

app.use(helmet());
app.use(cors);
app.use(express.json({ limit: "10kb" }));
app.use(express.urlencoded({ extended: true, limit: "10kb" }));

app.use(globalLimiter);
app.use("/api/auth", authLimiter);

app.use((req, res, next) => {
  const sanitizeObject = (obj) => {
    if (!obj) return;
    for (let key in obj) {
      if (typeof obj[key] === "string") {
        obj[key] = xss(obj[key]);
      }
    }
  };

  sanitizeObject(req.body);
  sanitizeObject(req.query);
  sanitizeObject(req.params);
  next();
});

app.use("/api/user", userRoutes);

app.use((req, res, next) => {
  logger.warn(sanitizeLogs(`404 Not Found: ${req.originalUrl}`));
  res.status(404).json({ success: false, message: "Route not found" });
});

app.use(errorHandler);

export default app;

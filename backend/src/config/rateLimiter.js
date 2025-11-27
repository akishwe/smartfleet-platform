import rateLimit from "express-rate-limit";
import logger from "./logger.js";

export function createRateLimiter(options = {}) {
  return rateLimit({
    windowMs: options.windowMs || 15 * 60 * 1000,
    max: options.max || 100,
    message: {
      status: 429,
      error: "Too many requests. Please try again later.",
    },
    standardHeaders: true,
    legacyHeaders: false,
    handler: (req, res, next, options) => {
      logger.warn(`Rate limit exceeded: IP=${req.ip}, URL=${req.originalUrl}`);
      res.status(options.statusCode).json(options.message);
    },
    skipSuccessfulRequests: options.skipSuccessfulRequests || false,
  });
}

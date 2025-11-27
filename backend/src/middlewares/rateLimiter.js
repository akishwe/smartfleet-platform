import { createRateLimiter } from "../config/rateLimiter.js";
import logger from "../config/logger.js";

export const globalLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000,
  max: 100,
  handler: (req, res, next, options) => {
    logger.warn(`Global rate limit exceeded for IP: ${req.ip}`);
    res.status(options.statusCode).json(options.message);
  },
});

export const authLimiter = createRateLimiter({
  windowMs: 10 * 60 * 1000,
  max: 5,
  handler: (req, res, next, options) => {
    logger.warn(`Auth rate limit exceeded for IP: ${req.ip}`);
    res.status(options.statusCode).json(options.message);
  },
});

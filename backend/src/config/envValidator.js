import Joi from "joi";
import dotenv from "dotenv";
import logger from "./logger.js";

dotenv.config();

const envSchema = Joi.object({
  NODE_ENV: Joi.string().valid("development", "production", "test").required(),
  PORT: Joi.number().default(5000),
  FRONTEND_URL: Joi.string().uri().required(),

  DATABASE_URL: Joi.string().uri().required(),

  JWT_SECRET: Joi.string().min(32).required(),
  JWT_REFRESH_SECRET: Joi.string().min(32).required(),
  JWT_ACCESS_EXPIRY: Joi.string().default("15m"),
  JWT_REFRESH_EXPIRY: Joi.string().default("7d"),

  LOG_LEVEL: Joi.string()
    .valid("error", "warn", "info", "debug")
    .default("info"),
  LOG_DIR: Joi.string().default("logs"),

  RATE_LIMIT_WINDOW_MINUTES: Joi.number().default(15),
  RATE_LIMIT_MAX_REQUESTS: Joi.number().default(100),

  ENABLE_HELMET: Joi.boolean().default(true),
  PAYLOAD_LIMIT: Joi.string().default("10kb"),
}).unknown(true);

const { value: envVars, error } = envSchema.validate(process.env, {
  abortEarly: false,
});

if (error) {
  logger.error(`Environment validation failed: ${error.message}`);
  throw new Error(
    "Invalid environment configuration. Please check your .env file."
  );
}

export default envVars;

import logger from "../config/logger.js";

const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;

  const isProduction = process.env.NODE_ENV === "production";
  const message = isProduction
    ? "An unexpected error occurred. Please try again later."
    : err.message;

  logger.error(
    `Error: ${err.message} | URL: ${req.originalUrl} | Method: ${req.method} | IP: ${req.ip}`
  );

  if (err.stack && !isProduction) {
    logger.debug(err.stack);
  }

  if (err.code && err.code.startsWith("P")) {
    logger.error(`Prisma Error Code: ${err.code}`);
  }

  res.status(statusCode).json({
    success: false,
    error: message,
    ...(isProduction ? {} : { stack: err.stack, code: err.code }),
  });
};

export default errorHandler;

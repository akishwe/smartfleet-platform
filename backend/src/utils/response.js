import logger from "../config/logger.js";

export const successResponse = (res, message, data = {}, statusCode = 200) => {
  logger.info(`Success: ${message}`);
  return res.status(statusCode).json({
    success: true,
    message,
    data,
  });
};

export const errorResponse = (res, message, statusCode = 500, error = null) => {
  if (error)
    logger.error(`Error: ${message} | Details: ${error.message || error}`);
  else logger.warn(`Error: ${message}`);

  return res.status(statusCode).json({
    success: false,
    message,
  });
};

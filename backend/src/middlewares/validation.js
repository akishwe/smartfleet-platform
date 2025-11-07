import logger from "../config/logger.js";

const validate = (schema) => {
  return (req, res, next) => {
    const options = {
      abortEarly: false,
      allowUnknown: false,
      stripUnknown: true,
    };

    const { error, value } = schema.validate(req.body, options);

    if (error) {
      const details = error.details.map((detail) =>
        detail.message.replace(/["]/g, "")
      );
      logger.warn(`Validation failed: ${details.join(", ")} | IP: ${req.ip}`);
      return res.status(400).json({
        success: false,
        error: "Validation error.",
        details,
      });
    }

    req.body = value;
    next();
  };
};

export default validate;

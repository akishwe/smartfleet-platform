import logger from "../config/logger.js";

const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user || !req.user.role) {
      logger.warn(`Access denied: Missing user role. IP: ${req.ip}`);
      return res
        .status(403)
        .json({ error: "Access denied. User role missing." });
    }

    if (!allowedRoles.includes(req.user.role)) {
      logger.warn(
        `Unauthorized role access attempt by ${req.user.email} (Role: ${req.user.role}) from IP: ${req.ip}`
      );
      return res
        .status(403)
        .json({ error: "Access denied. Insufficient permissions." });
    }

    next();
  };
};

export default authorize;

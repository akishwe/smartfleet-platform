import winston from "winston";
import "winston-daily-rotate-file";
import path from "path";
import fs from "fs";

const logsDir = "logs";
if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);

const rotateFile = new winston.transports.DailyRotateFile({
  filename: path.join(logsDir, "app-%DATE%.log"),
  datePattern: "YYYY-MM-DD",
  zippedArchive: true,
  maxSize: "20m",
  maxFiles: "14d",
});

function getCallerFile() {
  const err = new Error();
  const stack = err.stack?.split("\n") || [];
  const callerLine = stack[3] || "";
  const match = callerLine.match(/\((.*):\d+:\d+\)/);
  return match ? path.basename(match[1]) : "unknown";
}

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
    winston.format.errors({ stack: true }),
    winston.format.printf((info) => {
      const fileName = getCallerFile();
      const logMessage = `${info.timestamp} [${info.level}] [${fileName}]: ${info.message}`;
      return process.env.LOG_JSON === "true"
        ? JSON.stringify({ ...info, fileName })
        : logMessage;
    })
  ),
  transports: [
    new winston.transports.File({
      filename: path.join(logsDir, "error.log"),
      level: "error",
    }),
    new winston.transports.File({
      filename: path.join(logsDir, "combined.log"),
    }),
    rotateFile,
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.printf((info) => {
          const fileName = getCallerFile();
          return `${info.timestamp} [${info.level}] [${fileName}]: ${info.message}`;
        })
      ),
    }),
  ],
});

export default logger;

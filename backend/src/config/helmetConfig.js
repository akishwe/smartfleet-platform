import helmet from "helmet";

const isProduction = process.env.NODE_ENV === "production";

const helmetConfig = helmet({
  contentSecurityPolicy: {
    useDefaults: true,
    directives: {
      "default-src": ["'self'"],
      "img-src": ["'self'", "data:", "https:"],
      "script-src": ["'self'"],
      "style-src": ["'self'", "'unsafe-inline'"],
      "object-src": ["'none'"],
      "frame-ancestors": ["'none'"],
      ...(isProduction && { "upgrade-insecure-requests": [] }),
    },
  },
  referrerPolicy: { policy: "no-referrer" },
  crossOriginEmbedderPolicy: isProduction,
  crossOriginOpenerPolicy: { policy: "same-origin" },
  crossOriginResourcePolicy: { policy: "same-origin" },
  xssFilter: true,
  hidePoweredBy: true,
  noSniff: true,
  frameguard: { action: "deny" },
});

export default helmetConfig;

import jwt from "jsonwebtoken";
import crypto from "crypto";
import { serialize } from "cookie";

const generateJti = () => crypto.randomUUID();

export function generateAccessToken(user) {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
    },
    process.env.JWT_SECRET,
    {
      algorithm: "HS256",
      expiresIn: process.env.JWT_ACCESS_EXPIRY || "15m",
      audience: "smartfleet_api",
      issuer: "smartfleet_auth",
      jwtid: generateJti(),
    }
  );
}

export function generateRefreshToken(user) {
  return jwt.sign(
    {
      id: user.id,
    },
    process.env.JWT_REFRESH_SECRET,
    {
      algorithm: "HS256",
      expiresIn: process.env.JWT_REFRESH_EXPIRY || "7d",
      audience: "smartfleet_refresh",
      issuer: "smartfleet_auth",
      jwtid: generateJti(),
    }
  );
}

export function verifyAccessToken(token) {
  return jwt.verify(token, process.env.JWT_SECRET, {
    algorithms: ["HS256"],
    audience: "smartfleet_api",
    issuer: "smartfleet_auth",
  });
}

export function verifyRefreshToken(token) {
  return jwt.verify(token, process.env.JWT_REFRESH_SECRET, {
    algorithms: ["HS256"],
    audience: "smartfleet_refresh",
    issuer: "smartfleet_auth",
  });
}

export function createRefreshCookie(token) {
  return serialize("refreshToken", token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "strict",
    path: "/",
    maxAge: 7 * 24 * 60 * 60,
  });
}

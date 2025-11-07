import jwt from "jsonwebtoken";
import crypto from "crypto";
import { serialize } from "cookie";

const ACCESS_TOKEN_EXPIRY = process.env.JWT_ACCESS_EXPIRY || "15m";
const REFRESH_TOKEN_EXPIRY = process.env.JWT_REFRESH_EXPIRY || "7d";
const ACCESS_SECRET = process.env.JWT_SECRET;
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET;

const generateJti = () => crypto.randomUUID();

export function generateAccessToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    ACCESS_SECRET,
    {
      algorithm: "HS256",
      expiresIn: ACCESS_TOKEN_EXPIRY,
      audience: "smartfleet_api",
      issuer: "smartfleet_auth",
      jwtid: generateJti(),
    }
  );
}

export function generateRefreshToken(user) {
  return jwt.sign({ id: user.id }, REFRESH_SECRET, {
    algorithm: "HS256",
    expiresIn: REFRESH_TOKEN_EXPIRY,
    audience: "smartfleet_refresh",
    issuer: "smartfleet_auth",
    jwtid: generateJti(),
  });
}

export function verifyAccessToken(token) {
  return jwt.verify(token, ACCESS_SECRET, {
    algorithms: ["HS256"],
    audience: "smartfleet_api",
    issuer: "smartfleet_auth",
  });
}

export function verifyRefreshToken(token) {
  return jwt.verify(token, REFRESH_SECRET, {
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

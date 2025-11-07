import { hashPassword, comparePassword } from "../../utils/hash.js";
import {
  generateAccessToken,
  generateRefreshToken,
  createRefreshCookie,
} from "../../utils/jwt.js";
import { successResponse, errorResponse } from "../../utils/response.js";
import logger from "../../config/logger.js";
import userService from "./user.service.js";

export const registerUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;
    const existingUser = await userService.findByEmail(email);

    if (existingUser) return errorResponse(res, "User already exists", 409);

    const hashedPassword = await hashPassword(password);
    const user = await userService.createUser({
      name,
      email,
      password: hashedPassword,
      role,
    });

    logger.info(`New user registered: ${email}`);
    return successResponse(res, "User registered successfully", {
      id: user.id,
      email: user.email,
      role: user.role,
    });
  } catch (error) {
    logger.error("User registration failed", error);
    return errorResponse(res, "Failed to register user", 500, error);
  }
};

export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await userService.findByEmail(email);

    if (!user) return errorResponse(res, "Invalid email or password", 401);

    const isPasswordValid = await comparePassword(password, user.password);
    if (!isPasswordValid)
      return errorResponse(res, "Invalid email or password", 401);

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    const cookie = createRefreshCookie(refreshToken);

    res.setHeader("Set-Cookie", cookie);

    logger.info(`User logged in: ${email}`);
    return successResponse(res, "Login successful", { accessToken });
  } catch (error) {
    logger.error("Login failed", error);
    return errorResponse(res, "Login failed", 500, error);
  }
};

export const getProfile = async (req, res) => {
  try {
    const user = await userService.findById(req.user.id);
    if (!user) return errorResponse(res, "User not found", 404);

    logger.info(`Profile fetched for user: ${req.user.email}`);
    return successResponse(res, "Profile fetched successfully", {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    });
  } catch (error) {
    logger.error("Fetching profile failed", error);
    return errorResponse(res, "Failed to fetch user profile", 500, error);
  }
};

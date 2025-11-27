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
    const {
      firstName,
      lastName,
      email,
      password,
      contactNumber,
      timezone,
      gender,
      dob,
      language,
    } = req.body;

    const hashedPassword = await hashPassword(password);

    const userData = {
      firstName,
      lastName,
      email,
      password: hashedPassword,
      contactNumber,
      timezone,
      gender,
      dob,
      language,
    };

    const user = await userService.createUser(userData);

    return successResponse(res, "User registered successfully", user, 201);
  } catch (error) {
    logger.error(error);
    return errorResponse(res, "Something went wrong", 500, error);
  }
};

export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await userService.findByEmail(email);
    if (!user) return errorResponse(res, "Invalid email or password", 401);

    const isValid = await comparePassword(password, user.password);
    if (!isValid) return errorResponse(res, "Invalid email or password", 401);

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    const cookie = createRefreshCookie(refreshToken);

    res.setHeader("Set-Cookie", cookie);

    return successResponse(res, "Login successful", { accessToken }, 200);
  } catch (error) {
    logger.error("Login failed", error);
    return errorResponse(res, "Login failed", 500, error);
  }
};

export const getProfile = async (req, res) => {
  try {
    const user = await userService.findById(req.user.id);
    if (!user) return errorResponse(res, "User not found", 404);

    return successResponse(res, "Profile fetched successfully", user, 200);
  } catch (error) {
    logger.error("Fetching profile failed", error);
    return errorResponse(res, "Failed to fetch profile", 500, error);
  }
};

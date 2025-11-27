import express from "express";
import { registerUser, loginUser, getProfile } from "./user.controller.js";
import validate from "../../middlewares/validation.js";
import { registerSchema, loginSchema } from "./user.validation.js";
import auth from "../../middlewares/auth.js";
import { authLimiter } from "../../middlewares/rateLimiter.js";

const router = express.Router();

router.post("/register", validate(registerSchema), registerUser);
router.post("/login", authLimiter, validate(loginSchema), loginUser);
router.get("/profile", auth, getProfile);

export default router;

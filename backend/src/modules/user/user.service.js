import prisma from "../../config/prisma.js";
import logger from "../../config/logger.js";

const findByEmail = async (email) => {
  try {
    return await prisma.user.findUnique({
      where: { email },
    });
  } catch (error) {
    logger.error(`Database error while finding user by email: ${email}`, error);
    throw new Error("Database query failed");
  }
};

const createUser = async (userData) => {
  try {
    return await prisma.user.create({
      data: userData,
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
      },
    });
  } catch (error) {
    logger.error("Database error while creating user", error);
    throw new Error("Failed to create user");
  }
};

const findById = async (id) => {
  try {
    return await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
      },
    });
  } catch (error) {
    logger.error(`Database error while finding user by ID: ${id}`, error);
    throw new Error("Database query failed");
  }
};

export default { findByEmail, createUser, findById };

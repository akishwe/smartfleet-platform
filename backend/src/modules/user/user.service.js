import prisma from "../../config/prisma.js";
import logger from "../../config/logger.js";

const findByEmail = async (email) => {
  try {
    return await prisma.user.findUnique({
      where: { email },
    });
  } catch (error) {
    logger.error("Error finding user by email:", error);
    throw error;
  }
};

const findByEmailWithRoles = async (email) => {
  try {
    return await prisma.user.findUnique({
      where: { email },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });
  } catch (error) {
    logger.error("Error finding user with roles:", error);
    throw error;
  }
};

const createUser = async (data) => {
  try {
    return await prisma.user.create({
      data,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        roles: {
          select: {
            role: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
      },
    });
  } catch (error) {
    logger.error("Error creating user:", error);
    throw error;
  }
};

const findById = async (id) => {
  try {
    return await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        roles: {
          select: {
            role: {
              select: { id: true, name: true },
            },
          },
        },
      },
    });
  } catch (error) {
    logger.error("Error fetching user by ID:", error);
    throw error;
  }
};

export default {
  findByEmail,
  findByEmailWithRoles,
  createUser,
  findById,
};

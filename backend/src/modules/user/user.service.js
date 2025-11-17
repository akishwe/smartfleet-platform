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

const createUser = async (data) => {
  try {
    const user = await prisma.user.create({
      data: {
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        password: data.password,
        contactNumber: data.contactNumber,
        timezone: data.timezone,
        gender: data.gender,
        dob: data.dob,
        language: data.language,
      },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        contactNumber: true,
        timezone: true,
        gender: true,
        dob: true,
        language: true,
      },
    });

    user.id = user.id.toString();
    return user;
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
        contactNumber: true,
        timezone: true,
        gender: true,
        dob: true,
        language: true,
      },
    });
  } catch (error) {
    logger.error("Error fetching user by ID:", error);
    throw error;
  }
};

export default {
  findByEmail,
  createUser,
  findById,
};

import Joi from "joi";

export const registerSchema = Joi.object({
  firstName: Joi.string().required(),
  lastName: Joi.string().required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  contactNumber: Joi.string().required(),
  timezone: Joi.string().required(),
  gender: Joi.string().valid("M", "F", "O").required(),
  dob: Joi.date().required(),
  language: Joi.string().required(),
});

export const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

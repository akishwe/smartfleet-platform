import bycrypt from "bcrypt";

export async function hashPassword(password) {
  return await bycrypt.hash(password, 10);
}

export async function comparePassword(password, hashedPassword) {
  return await bycrypt.compare(password, hashedPassword);
}

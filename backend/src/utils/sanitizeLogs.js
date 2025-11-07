export const sanitizeLogs = (data) => {
  if (!data) return data;

  let sanitized = JSON.stringify(data);

  const sensitiveKeys = [
    "password",
    "token",
    "accessToken",
    "refreshToken",
    "authorization",
    "apiKey",
    "secret",
  ];

  for (const key of sensitiveKeys) {
    const regex = new RegExp(`"${key}"\\s*:\\s*"[^"]+"`, "gi");
    sanitized = sanitized.replace(regex, `"${key}":"[REDACTED]"`);
  }

  return JSON.parse(sanitized);
};

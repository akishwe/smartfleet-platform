/*
  Warnings:

  - You are about to drop the `driver` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `fuellog` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `location` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `maintenance` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `trip` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vehicle` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `fuellog` DROP FOREIGN KEY `FuelLog_trip_id_fkey`;

-- DropForeignKey
ALTER TABLE `fuellog` DROP FOREIGN KEY `FuelLog_vehicle_id_fkey`;

-- DropForeignKey
ALTER TABLE `location` DROP FOREIGN KEY `Location_trip_id_fkey`;

-- DropForeignKey
ALTER TABLE `location` DROP FOREIGN KEY `Location_vehicle_id_fkey`;

-- DropForeignKey
ALTER TABLE `maintenance` DROP FOREIGN KEY `Maintenance_vehicle_id_fkey`;

-- DropForeignKey
ALTER TABLE `trip` DROP FOREIGN KEY `Trip_driver_id_fkey`;

-- DropForeignKey
ALTER TABLE `trip` DROP FOREIGN KEY `Trip_user_id_fkey`;

-- DropForeignKey
ALTER TABLE `trip` DROP FOREIGN KEY `Trip_vehicle_id_fkey`;

-- DropForeignKey
ALTER TABLE `vehicle` DROP FOREIGN KEY `Vehicle_driver_id_fkey`;

-- DropTable
DROP TABLE `driver`;

-- DropTable
DROP TABLE `fuellog`;

-- DropTable
DROP TABLE `location`;

-- DropTable
DROP TABLE `maintenance`;

-- DropTable
DROP TABLE `trip`;

-- DropTable
DROP TABLE `user`;

-- DropTable
DROP TABLE `vehicle`;

-- CreateTable
CREATE TABLE `organizations` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `organizationId` BIGINT NOT NULL,
    `first_name` VARCHAR(191) NOT NULL,
    `last_name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password_hash` VARCHAR(191) NOT NULL,
    `contact_number` VARCHAR(191) NULL,
    `timezone` VARCHAR(191) NULL,
    `preferred_units` ENUM('METRIC', 'IMPERIAL') NOT NULL DEFAULT 'METRIC',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `roles_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_roles` (
    `userId` BIGINT NOT NULL,
    `roleId` BIGINT NOT NULL,

    PRIMARY KEY (`userId`, `roleId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drivers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `organizationId` BIGINT NOT NULL,
    `first_name` VARCHAR(191) NOT NULL,
    `last_name` VARCHAR(191) NOT NULL,
    `license_number` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NULL,
    `email` VARCHAR(191) NULL,
    `date_of_birth` DATETIME(3) NULL,
    `gender` ENUM('M', 'F', 'O') NULL,
    `certifications` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `drivers_license_number_key`(`license_number`),
    UNIQUE INDEX `drivers_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `driver_scores` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `driverId` BIGINT NOT NULL,
    `score_date` DATETIME(3) NOT NULL,
    `safety_score` DOUBLE NOT NULL,

    UNIQUE INDEX `driver_scores_driverId_score_date_key`(`driverId`, `score_date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicles` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `organizationId` BIGINT NOT NULL,
    `vin` VARCHAR(191) NOT NULL,
    `license_plate` VARCHAR(191) NOT NULL,
    `imei_number` VARCHAR(191) NOT NULL,
    `make` VARCHAR(191) NOT NULL,
    `model` VARCHAR(191) NOT NULL,
    `year` INTEGER NOT NULL,
    `fuel_type` VARCHAR(191) NOT NULL,
    `capacity` INTEGER NULL,
    `purchase_date` DATETIME(3) NOT NULL,
    `current_odometer_km` INTEGER NOT NULL,
    `status` ENUM('AVAILABLE', 'IN_TRANSIT', 'MAINTENANCE', 'INACTIVE') NOT NULL DEFAULT 'AVAILABLE',
    `current_driver_id` BIGINT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `vehicles_vin_key`(`vin`),
    UNIQUE INDEX `vehicles_license_plate_key`(`license_plate`),
    UNIQUE INDEX `vehicles_imei_number_key`(`imei_number`),
    UNIQUE INDEX `vehicles_current_driver_id_key`(`current_driver_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `trips` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `driver_id` BIGINT NOT NULL,
    `start_time` DATETIME(3) NOT NULL,
    `end_time` DATETIME(3) NULL,
    `start_lat` DOUBLE NOT NULL,
    `start_lon` DOUBLE NOT NULL,
    `end_lat` DOUBLE NULL,
    `end_lon` DOUBLE NULL,
    `actual_distance_km` DOUBLE NOT NULL,
    `idle_duration_min` INTEGER NOT NULL,
    `fuel_consumed_litres` DOUBLE NULL,
    `weather_conditions` VARCHAR(191) NULL,
    `status` ENUM('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `telemetry_data` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `timestamp` DATETIME(3) NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `speed` DOUBLE NULL,
    `fuelLevel` DOUBLE NULL,

    INDEX `telemetry_data_vehicle_id_timestamp_idx`(`vehicle_id`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `maintenance_types` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `maintenance_types_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `maintenance_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `maintenance_type_id` BIGINT NOT NULL,
    `service_date` DATETIME(3) NOT NULL,
    `odometer_reading` INTEGER NOT NULL,
    `details` VARCHAR(191) NULL,
    `cost` DOUBLE NULL,
    `currency_code` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `fuel_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `trip_id` BIGINT NULL,
    `fuel_date` DATETIME(3) NOT NULL,
    `quantity` DOUBLE NOT NULL,
    `cost` DOUBLE NOT NULL,
    `currency_code` VARCHAR(191) NULL,
    `location` VARCHAR(191) NULL,
    `remarks` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_dashboard_prefs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `userId` BIGINT NOT NULL,
    `widget_order_json` JSON NOT NULL,
    `theme_preference` VARCHAR(191) NULL,

    UNIQUE INDEX `user_dashboard_prefs_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `users` ADD CONSTRAINT `users_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drivers` ADD CONSTRAINT `drivers_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `driver_scores` ADD CONSTRAINT `driver_scores_driverId_fkey` FOREIGN KEY (`driverId`) REFERENCES `drivers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicles` ADD CONSTRAINT `vehicles_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicles` ADD CONSTRAINT `vehicles_current_driver_id_fkey` FOREIGN KEY (`current_driver_id`) REFERENCES `drivers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trips` ADD CONSTRAINT `trips_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trips` ADD CONSTRAINT `trips_driver_id_fkey` FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `telemetry_data` ADD CONSTRAINT `telemetry_data_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `maintenance_logs` ADD CONSTRAINT `maintenance_logs_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `maintenance_logs` ADD CONSTRAINT `maintenance_logs_maintenance_type_id_fkey` FOREIGN KEY (`maintenance_type_id`) REFERENCES `maintenance_types`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `fuel_logs` ADD CONSTRAINT `fuel_logs_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `fuel_logs` ADD CONSTRAINT `fuel_logs_trip_id_fkey` FOREIGN KEY (`trip_id`) REFERENCES `trips`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_dashboard_prefs` ADD CONSTRAINT `user_dashboard_prefs_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

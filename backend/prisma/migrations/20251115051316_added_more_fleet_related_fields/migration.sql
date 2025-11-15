/*
  Warnings:

  - You are about to alter the column `status` on the `driver_documents` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum(EnumId(3))`.
  - You are about to alter the column `status` on the `drivers` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum(EnumId(3))`.
  - You are about to alter the column `type` on the `geofences` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum(EnumId(11))`.
  - You are about to alter the column `interval_type` on the `maintenance_schedules` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum(EnumId(9))`.
  - You are about to alter the column `status` on the `maintenance_schedules` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum(EnumId(10))`.
  - You are about to drop the column `engine_load_percent` on the `telemetry_data` table. All the data in the column will be lost.
  - You are about to drop the column `engine_rpm` on the `telemetry_data` table. All the data in the column will be lost.
  - You are about to drop the column `heading_degrees` on the `telemetry_data` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `password_hash` on the `users` table. All the data in the column will be lost.
  - You are about to drop the `user_roles` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vehicle_documents` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `updatedAt` to the `maintenance_types` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `organizations` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `role_permissions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `roles` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `user_dashboard_prefs` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `user_roles` DROP FOREIGN KEY `user_roles_roleId_fkey`;

-- DropForeignKey
ALTER TABLE `user_roles` DROP FOREIGN KEY `user_roles_userId_fkey`;

-- DropForeignKey
ALTER TABLE `users` DROP FOREIGN KEY `users_organizationId_fkey`;

-- DropForeignKey
ALTER TABLE `vehicle_documents` DROP FOREIGN KEY `vehicle_documents_vehicle_id_fkey`;

-- DropIndex
DROP INDEX `users_organizationId_fkey` ON `users`;

-- AlterTable
ALTER TABLE `driver_documents` MODIFY `status` ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE `drivers` MODIFY `status` ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE `fuel_logs` ADD COLUMN `anomalyFlags` JSON NULL;

-- AlterTable
ALTER TABLE `geofence_events` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable
ALTER TABLE `geofences` MODIFY `type` ENUM('WAREHOUSE', 'CUSTOMER', 'RESTRICTED', 'DELIVERY_ZONE') NOT NULL;

-- AlterTable
ALTER TABLE `maintenance_logs` ADD COLUMN `status` ENUM('ACTIVE', 'COMPLETED') NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE `maintenance_schedules` MODIFY `interval_type` ENUM('KM', 'DAYS') NOT NULL,
    MODIFY `status` ENUM('ACTIVE', 'COMPLETED') NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE `maintenance_types` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updatedAt` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `organizations` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `role_permissions` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `roles` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `telemetry_data` DROP COLUMN `engine_load_percent`,
    DROP COLUMN `engine_rpm`,
    DROP COLUMN `heading_degrees`,
    ADD COLUMN `altitudeM` DOUBLE NULL,
    ADD COLUMN `averageFuelEconomy` DOUBLE NULL,
    ADD COLUMN `batteryVoltage` DOUBLE NULL,
    ADD COLUMN `coolantTempC` DOUBLE NULL,
    ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `dtc_codes_json` JSON NULL,
    ADD COLUMN `engineLoadPercent` DOUBLE NULL,
    ADD COLUMN `engineOilTemp` DOUBLE NULL,
    ADD COLUMN `engineRpm` INTEGER NULL,
    ADD COLUMN `eventCode` VARCHAR(191) NULL,
    ADD COLUMN `eventDescription` VARCHAR(191) NULL,
    ADD COLUMN `eventSeverity` VARCHAR(191) NULL,
    ADD COLUMN `fuelRate` DOUBLE NULL,
    ADD COLUMN `gpsAccuracyM` DOUBLE NULL,
    ADD COLUMN `harshAccelerationCount` INTEGER NULL,
    ADD COLUMN `harshBrakingCount` INTEGER NULL,
    ADD COLUMN `harshCorneringCount` INTEGER NULL,
    ADD COLUMN `headingDegrees` DOUBLE NULL,
    ADD COLUMN `idlingDurationSec` INTEGER NULL,
    ADD COLUMN `instantFuelEconomy` DOUBLE NULL,
    ADD COLUMN `intakeAirTemp` DOUBLE NULL,
    ADD COLUMN `mafRate` DOUBLE NULL,
    ADD COLUMN `odometerKm` DOUBLE NULL,
    ADD COLUMN `overSpeeding` BOOLEAN NULL,
    ADD COLUMN `throttlePosition` DOUBLE NULL;

-- AlterTable
ALTER TABLE `trip_waypoints` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable
ALTER TABLE `trips` ADD COLUMN `cost` DOUBLE NULL,
    ADD COLUMN `efficiency` DOUBLE NULL;

-- AlterTable
ALTER TABLE `user_dashboard_prefs` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `users` DROP COLUMN `organizationId`,
    DROP COLUMN `password_hash`,
    ADD COLUMN `password` VARCHAR(191) NOT NULL;

-- DropTable
DROP TABLE `user_roles`;

-- DropTable
DROP TABLE `vehicle_documents`;

-- CreateTable
CREATE TABLE `UserOrganization` (
    `userId` BIGINT NOT NULL,
    `organizationId` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`userId`, `organizationId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `UserRole` (
    `userId` BIGINT NOT NULL,
    `roleId` BIGINT NOT NULL,
    `organizationId` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`userId`, `roleId`, `organizationId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `DriverVehicleAssignment` (
    `driverId` BIGINT NOT NULL,
    `vehicleId` BIGINT NOT NULL,
    `startTime` DATETIME(3) NOT NULL,
    `endTime` DATETIME(3) NULL,

    PRIMARY KEY (`driverId`, `vehicleId`, `startTime`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VehicleDocument` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NOT NULL,
    `type` ENUM('RC_BOOK', 'INSURANCE', 'PUC', 'PERMIT', 'FITNESS', 'ROAD_TAX', 'OTHER') NOT NULL,
    `documentUrl` VARCHAR(191) NOT NULL,
    `validFrom` DATETIME(3) NULL,
    `validTill` DATETIME(3) NULL,
    `uploadedBy` BIGINT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VehicleDevice` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NOT NULL,
    `imei` VARCHAR(191) NOT NULL,
    `firmwareVersion` VARCHAR(191) NULL,
    `lastSync` DATETIME(3) NULL,

    UNIQUE INDEX `VehicleDevice_imei_key`(`imei`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VehicleHealthScore` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NOT NULL,
    `score` DOUBLE NOT NULL,
    `recordedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alerts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NULL,
    `driverId` BIGINT NULL,
    `type` VARCHAR(191) NOT NULL,
    `message` VARCHAR(191) NOT NULL,
    `severity` VARCHAR(191) NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `read` BOOLEAN NOT NULL DEFAULT false,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `UserOrganization` ADD CONSTRAINT `UserOrganization_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserOrganization` ADD CONSTRAINT `UserOrganization_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserRole` ADD CONSTRAINT `UserRole_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserRole` ADD CONSTRAINT `UserRole_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserRole` ADD CONSTRAINT `UserRole_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DriverVehicleAssignment` ADD CONSTRAINT `DriverVehicleAssignment_driverId_fkey` FOREIGN KEY (`driverId`) REFERENCES `drivers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DriverVehicleAssignment` ADD CONSTRAINT `DriverVehicleAssignment_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VehicleDocument` ADD CONSTRAINT `VehicleDocument_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VehicleDocument` ADD CONSTRAINT `VehicleDocument_uploadedBy_fkey` FOREIGN KEY (`uploadedBy`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VehicleDevice` ADD CONSTRAINT `VehicleDevice_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VehicleHealthScore` ADD CONSTRAINT `VehicleHealthScore_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

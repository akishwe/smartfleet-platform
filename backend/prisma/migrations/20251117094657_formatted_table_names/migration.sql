/*
  Warnings:

  - You are about to drop the `drivervehicleassignment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `userorganization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `userrole` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vehicledevice` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vehicledocument` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vehiclehealthscore` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `drivervehicleassignment` DROP FOREIGN KEY `DriverVehicleAssignment_driverId_fkey`;

-- DropForeignKey
ALTER TABLE `drivervehicleassignment` DROP FOREIGN KEY `DriverVehicleAssignment_vehicleId_fkey`;

-- DropForeignKey
ALTER TABLE `userorganization` DROP FOREIGN KEY `UserOrganization_organizationId_fkey`;

-- DropForeignKey
ALTER TABLE `userorganization` DROP FOREIGN KEY `UserOrganization_userId_fkey`;

-- DropForeignKey
ALTER TABLE `userrole` DROP FOREIGN KEY `UserRole_roleId_fkey`;

-- DropForeignKey
ALTER TABLE `userrole` DROP FOREIGN KEY `UserRole_userId_fkey`;

-- DropForeignKey
ALTER TABLE `vehicledevice` DROP FOREIGN KEY `VehicleDevice_vehicleId_fkey`;

-- DropForeignKey
ALTER TABLE `vehicledocument` DROP FOREIGN KEY `VehicleDocument_uploadedBy_fkey`;

-- DropForeignKey
ALTER TABLE `vehicledocument` DROP FOREIGN KEY `VehicleDocument_vehicleId_fkey`;

-- DropForeignKey
ALTER TABLE `vehiclehealthscore` DROP FOREIGN KEY `VehicleHealthScore_vehicleId_fkey`;

-- DropTable
DROP TABLE `drivervehicleassignment`;

-- DropTable
DROP TABLE `userorganization`;

-- DropTable
DROP TABLE `userrole`;

-- DropTable
DROP TABLE `vehicledevice`;

-- DropTable
DROP TABLE `vehicledocument`;

-- DropTable
DROP TABLE `vehiclehealthscore`;

-- CreateTable
CREATE TABLE `user_organizations` (
    `userId` BIGINT NOT NULL,
    `organizationId` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`userId`, `organizationId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_roles` (
    `userId` BIGINT NOT NULL,
    `roleId` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`userId`, `roleId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `driver_vehicle_assignments` (
    `driverId` BIGINT NOT NULL,
    `vehicleId` BIGINT NOT NULL,
    `startTime` DATETIME(3) NOT NULL,
    `endTime` DATETIME(3) NULL,

    PRIMARY KEY (`driverId`, `vehicleId`, `startTime`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_documents` (
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
CREATE TABLE `vehicle_devices` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NOT NULL,
    `imei` VARCHAR(191) NOT NULL,
    `firmwareVersion` VARCHAR(191) NULL,
    `lastSync` DATETIME(3) NULL,

    UNIQUE INDEX `vehicle_devices_imei_key`(`imei`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_health_scores` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicleId` BIGINT NOT NULL,
    `score` DOUBLE NOT NULL,
    `recordedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `user_organizations` ADD CONSTRAINT `user_organizations_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_organizations` ADD CONSTRAINT `user_organizations_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `driver_vehicle_assignments` ADD CONSTRAINT `driver_vehicle_assignments_driverId_fkey` FOREIGN KEY (`driverId`) REFERENCES `drivers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `driver_vehicle_assignments` ADD CONSTRAINT `driver_vehicle_assignments_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_documents` ADD CONSTRAINT `vehicle_documents_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_documents` ADD CONSTRAINT `vehicle_documents_uploadedBy_fkey` FOREIGN KEY (`uploadedBy`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_devices` ADD CONSTRAINT `vehicle_devices_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_health_scores` ADD CONSTRAINT `vehicle_health_scores_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

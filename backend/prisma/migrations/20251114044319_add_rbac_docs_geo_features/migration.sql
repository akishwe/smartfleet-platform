/*
  Warnings:

  - A unique constraint covering the columns `[gps_unit_id]` on the table `vehicles` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE `drivers` ADD COLUMN `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE `fuel_logs` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `receipt_file_url` VARCHAR(191) NULL,
    ADD COLUMN `recorded_by_user_id` BIGINT NULL;

-- AlterTable
ALTER TABLE `maintenance_logs` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `receipt_file_url` VARCHAR(191) NULL,
    ADD COLUMN `recorded_by_user_id` BIGINT NULL;

-- AlterTable
ALTER TABLE `telemetry_data` ADD COLUMN `engine_load_percent` DOUBLE NULL,
    ADD COLUMN `engine_rpm` INTEGER NULL,
    ADD COLUMN `heading_degrees` DOUBLE NULL;

-- AlterTable
ALTER TABLE `trips` ADD COLUMN `planned_distance_km` DOUBLE NULL,
    ADD COLUMN `planned_duration_min` INTEGER NULL,
    ADD COLUMN `planned_fuel_consumption_litres` DOUBLE NULL,
    ADD COLUMN `route_geometry_json` JSON NULL;

-- AlterTable
ALTER TABLE `vehicles` ADD COLUMN `gps_unit_id` VARCHAR(191) NULL,
    ADD COLUMN `load_capacity_kg` DOUBLE NULL,
    ADD COLUMN `vehicle_type` ENUM('CAR', 'VAN', 'TRUCK', 'BUS', 'MOTORCYCLE', 'OTHER') NOT NULL DEFAULT 'CAR',
    ADD COLUMN `volume_capacity_m3` DOUBLE NULL;

-- CreateTable
CREATE TABLE `permissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,

    UNIQUE INDEX `permissions_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role_permissions` (
    `roleId` BIGINT NOT NULL,
    `permissionId` BIGINT NOT NULL,

    PRIMARY KEY (`roleId`, `permissionId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `driver_documents` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `driver_id` BIGINT NOT NULL,
    `document_type` VARCHAR(191) NOT NULL,
    `file_url` VARCHAR(191) NOT NULL,
    `issue_date` DATETIME(3) NULL,
    `expiration_date` DATETIME(3) NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
    `remarks` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_documents` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `document_type` VARCHAR(191) NOT NULL,
    `file_url` VARCHAR(191) NOT NULL,
    `issue_date` DATETIME(3) NULL,
    `expiration_date` DATETIME(3) NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
    `remarks` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `trip_waypoints` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `trip_id` BIGINT NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `sequence` INTEGER NOT NULL,
    `waypoint_type` VARCHAR(191) NOT NULL,
    `scheduled_time` DATETIME(3) NULL,
    `actual_time` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `maintenance_schedules` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `maintenance_type_id` BIGINT NOT NULL,
    `last_service_date` DATETIME(3) NULL,
    `last_odometer_km` INTEGER NULL,
    `next_service_date` DATETIME(3) NOT NULL,
    `next_odometer_km` INTEGER NOT NULL,
    `interval_type` VARCHAR(191) NOT NULL,
    `interval_value` INTEGER NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `geofences` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `organizationId` BIGINT NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `coordinates_json` JSON NOT NULL,
    `alert_on_enter` BOOLEAN NOT NULL DEFAULT false,
    `alert_on_exit` BOOLEAN NOT NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `geofence_events` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vehicle_id` BIGINT NOT NULL,
    `geofence_id` BIGINT NOT NULL,
    `timestamp` DATETIME(3) NOT NULL,
    `event_type` VARCHAR(191) NOT NULL,
    `location_lat` DOUBLE NULL,
    `location_lon` DOUBLE NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NULL,
    `action` VARCHAR(191) NOT NULL,
    `entity_type` VARCHAR(191) NULL,
    `entity_id` BIGINT NULL,
    `changes_json` JSON NULL,
    `ip_address` VARCHAR(191) NULL,
    `user_agent` VARCHAR(191) NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `vehicles_gps_unit_id_key` ON `vehicles`(`gps_unit_id`);

-- AddForeignKey
ALTER TABLE `role_permissions` ADD CONSTRAINT `role_permissions_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `role_permissions` ADD CONSTRAINT `role_permissions_permissionId_fkey` FOREIGN KEY (`permissionId`) REFERENCES `permissions`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `driver_documents` ADD CONSTRAINT `driver_documents_driver_id_fkey` FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_documents` ADD CONSTRAINT `vehicle_documents_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trip_waypoints` ADD CONSTRAINT `trip_waypoints_trip_id_fkey` FOREIGN KEY (`trip_id`) REFERENCES `trips`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `maintenance_logs` ADD CONSTRAINT `maintenance_logs_recorded_by_user_id_fkey` FOREIGN KEY (`recorded_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `maintenance_schedules` ADD CONSTRAINT `maintenance_schedules_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `maintenance_schedules` ADD CONSTRAINT `maintenance_schedules_maintenance_type_id_fkey` FOREIGN KEY (`maintenance_type_id`) REFERENCES `maintenance_types`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `fuel_logs` ADD CONSTRAINT `fuel_logs_recorded_by_user_id_fkey` FOREIGN KEY (`recorded_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `geofences` ADD CONSTRAINT `geofences_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `geofence_events` ADD CONSTRAINT `geofence_events_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `geofence_events` ADD CONSTRAINT `geofence_events_geofence_id_fkey` FOREIGN KEY (`geofence_id`) REFERENCES `geofences`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `audit_logs` ADD CONSTRAINT `audit_logs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

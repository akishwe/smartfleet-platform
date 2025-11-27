/*
  Warnings:

  - The primary key for the `userrole` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `organizationId` on the `userrole` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `userrole` DROP FOREIGN KEY `UserRole_organizationId_fkey`;

-- DropIndex
DROP INDEX `UserRole_organizationId_fkey` ON `userrole`;

-- AlterTable
ALTER TABLE `userrole` DROP PRIMARY KEY,
    DROP COLUMN `organizationId`,
    ADD PRIMARY KEY (`userId`, `roleId`);

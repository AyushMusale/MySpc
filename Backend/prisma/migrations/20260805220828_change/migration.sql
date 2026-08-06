/*
  Warnings:

  - The primary key for the `Friend` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `user1Id` on the `Friend` table. All the data in the column will be lost.
  - You are about to drop the column `user2Id` on the `Friend` table. All the data in the column will be lost.
  - The primary key for the `SpaceMember` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `userId` on the `SpaceMember` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[userId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `profile1Id` to the `Friend` table without a default value. This is not possible if the table is not empty.
  - Added the required column `profile2Id` to the `Friend` table without a default value. This is not possible if the table is not empty.
  - Added the required column `profileId` to the `SpaceMember` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Friend" DROP CONSTRAINT "Friend_user1Id_fkey";

-- DropForeignKey
ALTER TABLE "Friend" DROP CONSTRAINT "Friend_user2Id_fkey";

-- DropForeignKey
ALTER TABLE "SpaceMember" DROP CONSTRAINT "SpaceMember_userId_fkey";

-- DropIndex
DROP INDEX "Space_id_key";

-- DropIndex
DROP INDEX "SpaceMember_userId_idx";

-- DropIndex
DROP INDEX "User_id_key";

-- AlterTable
ALTER TABLE "Friend" DROP CONSTRAINT "Friend_pkey",
DROP COLUMN "user1Id",
DROP COLUMN "user2Id",
ADD COLUMN     "profile1Id" INTEGER NOT NULL,
ADD COLUMN     "profile2Id" INTEGER NOT NULL,
ADD CONSTRAINT "Friend_pkey" PRIMARY KEY ("profile1Id", "profile2Id");

-- AlterTable
CREATE SEQUENCE message_id_seq;
ALTER TABLE "Message" ALTER COLUMN "id" SET DEFAULT nextval('message_id_seq');
ALTER SEQUENCE message_id_seq OWNED BY "Message"."id";

-- AlterTable
CREATE SEQUENCE space_id_seq;
ALTER TABLE "Space" ALTER COLUMN "id" SET DEFAULT nextval('space_id_seq');
ALTER SEQUENCE space_id_seq OWNED BY "Space"."id";

-- AlterTable
ALTER TABLE "SpaceMember" DROP CONSTRAINT "SpaceMember_pkey",
DROP COLUMN "userId",
ADD COLUMN     "profileId" INTEGER NOT NULL,
ADD CONSTRAINT "SpaceMember_pkey" PRIMARY KEY ("spaceId", "profileId");

-- AlterTable
CREATE SEQUENCE user_id_seq;
ALTER TABLE "User" ADD COLUMN     "userId" INTEGER NOT NULL,
ALTER COLUMN "id" SET DEFAULT nextval('user_id_seq');
ALTER SEQUENCE user_id_seq OWNED BY "User"."id";

-- CreateIndex
CREATE INDEX "Space_createdById_idx" ON "Space"("createdById");

-- CreateIndex
CREATE INDEX "SpaceMember_profileId_idx" ON "SpaceMember"("profileId");

-- CreateIndex
CREATE UNIQUE INDEX "User_userId_key" ON "User"("userId");

-- AddForeignKey
ALTER TABLE "SpaceMember" ADD CONSTRAINT "SpaceMember_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Friend" ADD CONSTRAINT "Friend_profile1Id_fkey" FOREIGN KEY ("profile1Id") REFERENCES "Profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Friend" ADD CONSTRAINT "Friend_profile2Id_fkey" FOREIGN KEY ("profile2Id") REFERENCES "Profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

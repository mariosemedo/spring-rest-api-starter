-- Those scripts are only useful if you plan to use the custom functions and users for manual support.
-- Be wary that they may not be compatible from one version of MySQL to another.

-- https://stackoverflow.com/questions/32903696/issue-with-executing-procedure-in-spring-boot-schema-sql-file
DELIMITER ^;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0^;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0^;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'^;

-- -----------------------------------------------------
-- Schema spring_rest_api_starter
-- -----------------------------------------------------
-- A generic database starter.
DROP SCHEMA IF EXISTS `spring_rest_api_starter` ^;

-- -----------------------------------------------------
-- Schema spring_rest_api_starter
--
-- A generic database starter.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spring_rest_api_starter` DEFAULT CHARACTER SET utf8 ^;
SHOW WARNINGS^;
USE `spring_rest_api_starter` ^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_client_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_client_details`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_client_details` (
  `client_id` VARCHAR(255) PRIMARY KEY,
  `resource_ids` VARCHAR(255),
  `client_secret` VARCHAR(255),
  `scope` VARCHAR(255),
  `authorized_grant_types` VARCHAR(255),
  `web_server_redirect_uri` VARCHAR(255),
  `authorities` VARCHAR(255),
  `access_token_validity` INTEGER,
  `refresh_token_validity` INTEGER,
  `additional_information` VARCHAR(4096),
  `autoapprove` VARCHAR(255)
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_client_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_client_token`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_client_token` (
  `token_id` VARCHAR(255),
  `token` LONG VARBINARY,
  `authentication_id` VARCHAR(255) PRIMARY KEY,
  `user_name` VARCHAR(255),
  `client_id` VARCHAR(255)
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_access_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_access_token`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_access_token` (
  `token_id` VARCHAR(255),
  `token` LONG VARBINARY,
  `authentication_id` VARCHAR(255) PRIMARY KEY,
  `user_name` VARCHAR(255),
  `client_id` VARCHAR(255),
  `authentication` LONG VARBINARY,
  `refresh_token` VARCHAR(255)
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_refresh_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_refresh_token`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_refresh_token` (
  `token_id` VARCHAR(255),
  `token` LONG VARBINARY,
  `authentication` LONG VARBINARY
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_code`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_code` (
  `code` VARCHAR(255),
  `authentication` LONG VARBINARY
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`oauth_approvals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `oauth_approvals`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS `oauth_approvals` (
    `userId` VARCHAR(255),
    `clientId` VARCHAR(255),
    `scope` VARCHAR(255),
    `status` VARCHAR(10),
    `expiresAt` TIMESTAMP,
    `lastModifiedAt` TIMESTAMP
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`ClientDetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ClientDetails`^;

SHOW WARNINGS^;
CREATE TABLE IF NOT EXISTS ClientDetails (
  `appId` VARCHAR(255) PRIMARY KEY,
  `resourceIds` VARCHAR(255),
  `appSecret` VARCHAR(255),
  `scope` VARCHAR(255),
  `grantTypes` VARCHAR(255),
  `redirectUrl` VARCHAR(255),
  `authorities` VARCHAR(255),
  `access_token_validity` INTEGER,
  `refresh_token_validity` INTEGER,
  `additionalInformation` VARCHAR(4096),
  `autoApproveScopes` VARCHAR(255)
) ENGINE = InnoDB^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`role`
-- -----------------------------------------------------

-- Should be generated by JPA for now

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`user`
-- -----------------------------------------------------

-- Should be generated by JPA for now

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`type`
-- -----------------------------------------------------

-- Should be generated by JPA for now

-- -----------------------------------------------------
-- Table `spring_rest_api_starter`.`permission`
-- -----------------------------------------------------

-- Should be generated by JPA for now

-- -----------------------------------------------------
-- function get_uuid
-- -----------------------------------------------------

USE `spring_rest_api_starter`^;
DROP function IF EXISTS `spring_rest_api_starter`.`get_uuid`^;
SHOW WARNINGS^;

USE `spring_rest_api_starter`^;
CREATE FUNCTION `get_uuid` (uuid VARCHAR(40))
	RETURNS BINARY(16)
BEGIN
	RETURN UNHEX(REPLACE(uuid, '-', ''));
END^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- function new_uuid
-- -----------------------------------------------------

USE `spring_rest_api_starter`^;
DROP function IF EXISTS `spring_rest_api_starter`.`new_uuid`^;
SHOW WARNINGS^;

USE `spring_rest_api_starter`^;
CREATE FUNCTION `new_uuid` ()
	RETURNS BINARY(16)
BEGIN
	RETURN `get_uuid`(UUID());
END^;

SHOW WARNINGS^;

-- -----------------------------------------------------
-- function read_uuid
-- -----------------------------------------------------

USE `spring_rest_api_starter`^;
DROP function IF EXISTS `spring_rest_api_starter`.`read_uuid`^;
SHOW WARNINGS^;

USE `spring_rest_api_starter`^;
CREATE FUNCTION `read_uuid` (uuid BINARY(16))
	RETURNS VARCHAR(32)
BEGIN
	DECLARE uuidHexStr VARCHAR(36) DEFAULT HEX(uuid);
    
    SET uuidHexStr = INSERT(uuidHexStr, 9, 1, '-');
    SET uuidHexStr = INSERT(uuidHexStr, 14, 1, '-');
    SET uuidHexStr = INSERT(uuidHexStr, 19, 1, '-');
    SET uuidHexStr = INSERT(uuidHexStr, 24, 1, '-');
    
	RETURN uuidHexStr;
END^;

SHOW WARNINGS^;


-- -----------------------------------------------------
-- User grants
-- -----------------------------------------------------

SET SQL_MODE = ''^;
GRANT USAGE ON *.* TO spring_rest_api_starter_rw^;
 DROP USER spring_rest_api_starter_rw^;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'^;
SHOW WARNINGS^;
CREATE USER 'spring_rest_api_starter_rw' IDENTIFIED BY 'spring_rest_api_starter_rw'^;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON TABLE `spring_rest_api_starter`.* TO 'spring_rest_api_starter_rw'^;
SHOW WARNINGS^;

SET SQL_MODE = ''^;
GRANT USAGE ON *.* TO spring_rest_api_starter_ro^;
 DROP USER spring_rest_api_starter_ro^;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'^;
SHOW WARNINGS^;
CREATE USER 'spring_rest_api_starter_ro' IDENTIFIED BY 'spring_rest_api_starter_ro'^;

GRANT SELECT ON TABLE `spring_rest_api_starter`.* TO 'spring_rest_api_starter_ro'^;
SHOW WARNINGS^;

/*
SET SQL_MODE = ''^;
GRANT USAGE ON *.* TO spring_rest_api_starter^;
 DROP USER spring_rest_api_starter^;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'^;
SHOW WARNINGS^;
CREATE USER 'spring_rest_api_starter' IDENTIFIED BY 'spring_rest_api_starter'^;

GRANT ALL ON `spring_rest_api_starter`.* TO 'spring_rest_api_starter'^;
SHOW WARNINGS^;
*/

SET SQL_MODE=@OLD_SQL_MODE^;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS^;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS^;

DELIMITER ;

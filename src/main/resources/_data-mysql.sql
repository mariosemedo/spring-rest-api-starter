-- Those scripts are only useful if you plan to use the custom functions and users for manual support.
-- Be wary that they may not be compatible from one version of MySQL to another.


-- https://stackoverflow.com/questions/32903696/issue-with-executing-procedure-in-spring-boot-schema-sql-file
DELIMITER ^;

-- -----------------------------------------------------
-- Clean generic data for `spring_rest_api_starter`
-- -----------------------------------------------------
START TRANSACTION^;
USE `spring_rest_api_starter`^;

DELETE FROM `spring_rest_api_starter`.`oauth_client_details`^;
DELETE FROM `spring_rest_api_starter`.`oauth_client_token`^;
DELETE FROM `spring_rest_api_starter`.`oauth_access_token`^;
DELETE FROM `spring_rest_api_starter`.`oauth_refresh_token`^;
DELETE FROM `spring_rest_api_starter`.`oauth_code`^;
DELETE FROM `spring_rest_api_starter`.`oauth_approvals`^;
DELETE FROM `spring_rest_api_starter`.`ClientDetails`^;

COMMIT^;


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0^;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0^;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'^;

-- If some data must be inserted regardless of foreign keys

SET SQL_MODE=@OLD_SQL_MODE^;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS^;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS^;

-- -----------------------------------------------------
-- Data for table `spring_rest_api_starter`.`oauth_client_details`
-- -----------------------------------------------------
START TRANSACTION^;
USE `spring_rest_api_starter`^;

INSERT INTO `oauth_client_details`
    (client_id, client_secret, scope, 
    authorized_grant_types,
    web_server_redirect_uri, authorities, 
    access_token_validity, refresh_token_validity,
    additional_information, autoapprove)
VALUES
    ("clientMobileIdPassword", "secret", "api,read,write",
    "password,authorization_code,refresh_token", 
    null, null, 
    36000, 36000, 
    null, true)^;

INSERT INTO `oauth_client_details`
    (client_id, client_secret, scope, 
    authorized_grant_types,
    web_server_redirect_uri, authorities, 
    access_token_validity, refresh_token_validity,
    additional_information, autoapprove)
VALUES
    ("clientWebIdPassword", "secret", "api,read,write",
    "password,authorization_code,refresh_token", 
    null, null, 
    36000, 36000, 
    null, true)^;

COMMIT^;

-- -----------------------------------------------------
-- Data for table `spring_rest_api_starter`.`user`
-- -----------------------------------------------------

-- Should be generated by Spring-Rest-Api-Starter InitialDataLoader for now


-- -----------------------------------------------------
-- Data for table `spring_rest_api_starter`.`role`
-- -----------------------------------------------------

-- Should be generated by Spring-Rest-Api-Starter InitialDataLoader for now

-- -----------------------------------------------------
-- Data for table `spring_rest_api_starter`.`type`
-- -----------------------------------------------------

-- Should be generated by Spring-Rest-Api-Starter InitialDataLoader for now

-- -----------------------------------------------------
-- Data for table `spring_rest_api_starter`.`permission`
-- -----------------------------------------------------

-- Should be generated by Spring-Rest-Api-Starter InitialDataLoader for now

DELIMITER ;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema first_app_development
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema first_app_development
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `first_app_development` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `first_app_development` ;

-- -----------------------------------------------------
-- Table `first_app_development`.`searches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `first_app_development`.`searches` (
  `requestid` INT NOT NULL AUTO_INCREMENT,
  `users_id` INT NOT NULL,
  `q` VARCHAR(4096) NULL,
  `lang` VARCHAR(2) NOT NULL,
  `state` INT NOT NULL,
  `request_date` DATETIME NOT NULL,
  `last_update_date` DATETIME NULL,
  `process_count` INT ZEROFILL NULL,
  `total_count` INT ZEROFILL NULL,
  PRIMARY KEY (`requestid`),
  UNIQUE INDEX `requestid_UNIQUE` (`requestid` ASC),
  INDEX `fk_searchs_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_searchs_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `first_app_development`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `first_app_development`.`slides`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `first_app_development`.`slides` (
  `requestid` INT NOT NULL,
  `ID` VARCHAR(45) NOT NULL,
  `userid` INT NOT NULL,
  `Title` VARCHAR(45) NULL DEFAULT NULL,
  `Description` TEXT NULL DEFAULT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `URL` VARCHAR(255) NULL DEFAULT NULL,
  `ThumbnailURL` VARCHAR(255) NULL DEFAULT NULL,
  `ThumbnailSize` VARCHAR(45) NOT NULL,
  `ThumbnailSmallURL` VARCHAR(255) NULL DEFAULT NULL,
  `Embed` TEXT NULL,
  `Created` DATETIME NOT NULL,
  `Updated` DATETIME NULL,
  `Format` VARCHAR(45) NOT NULL,
  `DownloadURL` VARCHAR(255) NULL DEFAULT NULL,
  `SlideshowType` VARCHAR(45) NOT NULL,
  `userid` INT NOT NULL,
  `language` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`requestid`, `ID`),
  INDEX `fk_slides_searches1_idx` (`requestid` ASC),
  CONSTRAINT `fk_slides_searches1`
    FOREIGN KEY (`requestid`)
    REFERENCES `first_app_development`.`searches` (`requestid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


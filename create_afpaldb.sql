warnings;
CREATE DATABASE IF NOT EXISTS AFPALdb;
use AFPALdb;


# ------------------------------------------------------------------------------------------------------------------------
# Former QDGC database

DROP TABLE IF EXISTS tmpr_max;
CREATE TABLE IF NOT EXISTS `tmpr_max` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `jan` double DEFAULT NULL,
  `feb` double DEFAULT NULL,
  `mar` double DEFAULT NULL,
  `apr` double DEFAULT NULL,
  `may` double DEFAULT NULL,
  `jun` double DEFAULT NULL,
  `jul` double DEFAULT NULL,
  `aug` double DEFAULT NULL,
  `sep` double DEFAULT NULL,
  `oct` double DEFAULT NULL,
  `nov` double DEFAULT NULL,
  `dcm` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_tmpr_max_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS tmpr_min;
CREATE TABLE IF NOT EXISTS `tmpr_min` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `jan` double DEFAULT NULL,
  `feb` double DEFAULT NULL,
  `mar` double DEFAULT NULL,
  `apr` double DEFAULT NULL,
  `may` double DEFAULT NULL,
  `jun` double DEFAULT NULL,
  `jul` double DEFAULT NULL,
  `aug` double DEFAULT NULL,
  `sep` double DEFAULT NULL,
  `oct` double DEFAULT NULL,
  `nov` double DEFAULT NULL,
  `dcm` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_tmpr_min_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS tmpr_mean;
CREATE TABLE IF NOT EXISTS `tmpr_mean` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `jan` double DEFAULT NULL,
  `feb` double DEFAULT NULL,
  `mar` double DEFAULT NULL,
  `apr` double DEFAULT NULL,
  `may` double DEFAULT NULL,
  `jun` double DEFAULT NULL,
  `jul` double DEFAULT NULL,
  `aug` double DEFAULT NULL,
  `sep` double DEFAULT NULL,
  `oct` double DEFAULT NULL,
  `nov` double DEFAULT NULL,
  `dcm` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_tmpr_mean_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS pet;
CREATE TABLE IF NOT EXISTS `pet` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `jan` double DEFAULT NULL,
  `feb` double DEFAULT NULL,
  `mar` double DEFAULT NULL,
  `apr` double DEFAULT NULL,
  `may` double DEFAULT NULL,
  `jun` double DEFAULT NULL,
  `jul` double DEFAULT NULL,
  `aug` double DEFAULT NULL,
  `sep` double DEFAULT NULL,
  `oct` double DEFAULT NULL,
  `nov` double DEFAULT NULL,
  `dcm` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_pet_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS precip;
CREATE TABLE IF NOT EXISTS `precip` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `jan` double DEFAULT NULL,
  `feb` double DEFAULT NULL,
  `mar` double DEFAULT NULL,
  `apr` double DEFAULT NULL,
  `may` double DEFAULT NULL,
  `jun` double DEFAULT NULL,
  `jul` double DEFAULT NULL,
  `aug` double DEFAULT NULL,
  `sep` double DEFAULT NULL,
  `oct` double DEFAULT NULL,
  `nov` double DEFAULT NULL,
  `dcm` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_precip_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS taxalist;
CREATE TABLE IF NOT EXISTS `taxalist` (
  `CODE` varchar(20) NOT NULL DEFAULT '-1/-1',
  `GENNO` int(11) NOT NULL DEFAULT '0',
  `SPNO` int(11) NOT NULL DEFAULT '0',
  `FAMNAME` varchar(100) DEFAULT NULL,
  `GENNAME` varchar(100) DEFAULT NULL,
  `SPNAME` varchar(150) DEFAULT NULL,
  `TAXNAME` varchar(150) DEFAULT NULL,
  `POLTYPE` varchar(150) DEFAULT NULL,
  `NB_OCCURENCES` int(11) DEFAULT NULL,
  PRIMARY KEY (`CODE`),
  KEY `CODE_Index` (`CODE`) 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS distrib;
CREATE TABLE IF NOT EXISTS `distrib` (
  `CODE` varchar(20) NOT NULL DEFAULT '0.0',
  `GENNO` int(11) NOT NULL DEFAULT '0',
  `SPNO` int(11) NOT NULL DEFAULT '0',
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`CODE`,`lon`,`lat`),
  KEY `CODE_lo_la_Index` (`CODE`,`lon`,`lat`) 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS bio;
CREATE TABLE IF NOT EXISTS `bio` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `Tmean_ann` double DEFAULT NULL,
  `Mean_Diurnal_Range` double DEFAULT NULL,
  `Isothermality` double DEFAULT NULL,
  `Temp_seasonality` double DEFAULT NULL,
  `Tmax_Warm_M` double DEFAULT NULL,
  `Tmin_Cold_M` double DEFAULT NULL,
  `Temp_ann_range` double DEFAULT NULL,
  `Tmean_Wet_Q` double DEFAULT NULL,
  `Tmean_Dry_Q` double DEFAULT NULL,
  `Tmean_Warm_Q` double DEFAULT NULL,
  `Tmean_Cold_Q` double DEFAULT NULL,
  `Prec_ann` double DEFAULT NULL,
  `Prec_Wet_M` double DEFAULT NULL,
  `Prec_Dry_M` double DEFAULT NULL,
  `Prec_seasonality` double DEFAULT NULL,
  `Prec_Wet_Q` double DEFAULT NULL,
  `Prec_Dry_Q` double DEFAULT NULL,
  `Prec_Warm_Q` double DEFAULT NULL,
  `Prec_Cold_Q` double DEFAULT NULL,
  `SWC_Winter` double DEFAULT NULL,
  `SWC_Summer` double DEFAULT NULL,
  `Aridity` double DEFAULT NULL,
  `WRZ_percent` double DEFAULT NULL,
  `Frost_days` double DEFAULT NULL,
  `Wet_days` double DEFAULT NULL,
  `Wet_days_DJF` double DEFAULT NULL,
  `Wet_days_JJA` double DEFAULT NULL,
  `Prec_Dry_S` double DEFAULT NULL,
  `Prec_Wet_S` double DEFAULT NULL,
  `Peff_Wet_Q` double DEFAULT NULL,
  `Peff_Wet_S` double DEFAULT NULL,
  `Peff_Dry_Q` double DEFAULT NULL,
  `Peff_Dry_S` double DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_bio_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Biome;
CREATE TABLE IF NOT EXISTS `Biome` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `BIOME_ID` int(11),
  `BIOME` varchar(150),
  `ECO_ID` int(11),
  `ECO` varchar(150),
  `COUNTRY` varchar(150),
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_tmpr_min_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Altitude;
CREATE TABLE IF NOT EXISTS `Altitude` (
  `lon` double NOT NULL DEFAULT '0',
  `lat` double NOT NULL DEFAULT '0',
  `Alt` int(11) DEFAULT NULL,
  `sd` int(11) DEFAULT NULL,
  `min` int(11) DEFAULT NULL,
  `max` int(11) DEFAULT NULL,
  PRIMARY KEY (`lon`,`lat`),
  KEY `lo_la_altitude_Index` (`lon`,`lat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS encompte;
CREATE TABLE IF NOT EXISTS `encompte` (
  `POLTYPE` varchar(150) NOT NULL,
  `Tmean_ann` double DEFAULT NULL,
  `Mean_Diurnal_Range` double DEFAULT NULL,
  `Isothermality` double DEFAULT NULL,
  `Temp_seasonality` double DEFAULT NULL,
  `Tmax_Warm_M` double DEFAULT NULL,
  `Tmin_Cold_M` double DEFAULT NULL,
  `Temp_ann_range` double DEFAULT NULL,
  `Tmean_Wet_Q` double DEFAULT NULL,
  `Tmean_Dry_Q` double DEFAULT NULL,
  `Tmean_Warm_Q` double DEFAULT NULL,
  `Tmean_Cold_Q` double DEFAULT NULL,
  `Prec_ann` double DEFAULT NULL,
  `Prec_Wet_M` double DEFAULT NULL,
  `Prec_Dry_M` double DEFAULT NULL,
  `Prec_seasonality` double DEFAULT NULL,
  `Prec_Wet_Q` double DEFAULT NULL,
  `Prec_Dry_Q` double DEFAULT NULL,
  `Prec_Warm_Q` double DEFAULT NULL,
  `Prec_Cold_Q` double DEFAULT NULL,
  `SWC_Winter` double DEFAULT NULL,
  `SWC_Summer` double DEFAULT NULL,
  `Aridity` double DEFAULT NULL,
  `WRZ_percent` double DEFAULT NULL,
  `Frost_days` double DEFAULT NULL,
  `Wet_days` double DEFAULT NULL,
  `Wet_days_DJF` double DEFAULT NULL,
  `Wet_days_JJA` double DEFAULT NULL,
  `Prec_Dry_S` double DEFAULT NULL,
  `Prec_Wet_S` double DEFAULT NULL,
  `Peff_Wet_Q` double DEFAULT NULL,
  `Peff_Wet_S` double DEFAULT NULL,
  `Peff_Dry_Q` double DEFAULT NULL,
  `Peff_Dry_S` double DEFAULT NULL,
  PRIMARY KEY (`POLTYPE`),
  KEY `lo_la_bio_Index` (`POLTYPE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Former QDGC database
# ------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------------------
# African Palaeo Database


DROP TABLE IF EXISTS Site;
CREATE TABLE IF NOT EXISTS `Site` (
  `Site_ID` int(10) NOT NULL AUTO_INCREMENT,
  `Record_Name` varchar(30) NOT NULL,
  `Site_Name` varchar(30) NOT NULL,
  `lon` double NULL,
  `lat` double NULL,
  `Archive` varchar(50) NOT NULL,
  `Country` varchar(100)  DEFAULT NULL,
  `Altitude` double  DEFAULT NULL,
  `Terrestrial` boolean NOT NULL,
  PRIMARY KEY (`Record_Name`),
  KEY `Sites_Index` (`Site_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS SiteRegion;
CREATE TABLE IF NOT EXISTS `SiteRegion` (
  `Record_Name` varchar(30) NOT NULL,
  `Region` varchar(200)  NOT NULL,
  PRIMARY KEY (`Record_Name`,`Region`),
  KEY `SitesRegion_Index` (`Record_Name`,`Region`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Reference;
CREATE TABLE IF NOT EXISTS `Reference` (
  `Citation_Key` varchar(70) NOT NULL,
  `Authors` varchar(300) NOT NULL,
  `Published` boolean NOT NULL,
  `Journal` varchar(100) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `Volume` int(4) DEFAULT NULL,
  `Issue` varchar(4) DEFAULT NULL,
  `Pages` varchar(20) DEFAULT NULL,
  `Title` varchar(600) DEFAULT NULL,
  `DOI` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`Citation_Key`),
  KEY `Reference_Index` (`Citation_Key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS RefSite;
CREATE TABLE IF NOT EXISTS `RefSite` (
  `Citation_Key` varchar(70) NOT NULL,
  `Record_Name` varchar(30) NOT NULL,
  PRIMARY KEY (`Citation_Key`,`Record_Name`),
  KEY `RefSite_Index` (`Citation_Key`,`Record_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Dataset;
CREATE TABLE IF NOT EXISTS `Dataset` (
  `Dataset_ID`int(10)  NOT NULL,
  `Record_Name` varchar(30) NOT NULL,
  `Citation_Key` varchar(70) NOT NULL,
  `Proxy` varchar(50) NOT NULL,
  `Digitized` boolean NOT NULL,
  `dataset` JSON NULL,
  `Uncertainties` JSON NULL,
  `Metadata` JSON NULL,
  PRIMARY KEY (`Record_Name`,`Citation_Key`,`Proxy`),
  KEY `Dataset_Index` (`Dataset_ID`)
  #FOREIGN KEY (`Record_Name`) REFERENCES Sites(`Record_Name`),
  #FOREIGN KEY (Citation_Key) REFERENCES Reference(Citation_Key)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Chronology;
CREATE TABLE IF NOT EXISTS `Chronology` (
  `Chrono_ID` int(10) NOT NULL,
  `Citation_Key` varchar(70) NOT NULL,
  `Record_Name` varchar(30) NOT NULL,
  `Chrono_Name` varchar(30) NOT NULL,
  `Model` varchar(30) NOT NULL,
  `Digitized` boolean NOT NULL,
  `Sample` JSON NOT NULL,
  `Depth` JSON NULL,
  `Chronology` JSON NOT NULL,
  `Uncertainties` JSON NULL,
  `Metadata` JSON NULL,
  PRIMARY KEY (`Record_Name`,`Citation_Key`,`Chrono_Name`),
  KEY `Chronology_Index` (`Chrono_ID`)
  #FOREIGN KEY (Citation_Key) REFERENCES Reference(Citation_Key),
  #FOREIGN KEY (`Record_Name`) REFERENCES Sites(`Record_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS ChronoData;
CREATE TABLE IF NOT EXISTS `ChronoData` (
  `Chrono_ID` int(10) NOT NULL,
  `Dataset_ID`int(10)  NOT NULL,
  PRIMARY KEY (`Chrono_ID`,`Dataset_ID`),
  KEY `ChronoData_Index` (`Chrono_ID`,`Dataset_ID`)
  #FOREIGN KEY (`Chrono_ID`) REFERENCES Chronology(`Chrono_ID`),
  #FOREIGN KEY (`Dataset_ID`) REFERENCES Dataset(`Dataset_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS ChronoAge;
CREATE TABLE IF NOT EXISTS `ChronoAge` (
  `Chrono_ID` int(10) NOT NULL,
  `LabCode` varchar(20) NOT NULL,
  PRIMARY KEY (`Chrono_ID`,`LabCode`),
  KEY `ChronoData_Index` (`Chrono_ID`,`LabCode`)
  #FOREIGN KEY (`Chrono_ID`) REFERENCES Chronology(`Chrono_ID`),
  #FOREIGN KEY (`LabCode`) REFERENCES Age(`LabCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Age;
CREATE TABLE IF NOT EXISTS `Age`(
  `LabCode` varchar(20) NOT NULL,
  `Record_Name` varchar(30) NOT NULL,
  `Citation_Key` varchar(70) NOT NULL,
  `Type` varchar(70) NOT NULL,
  `Age` double NOT NULL,
  `Reservoir` double NULL,
  `Error` double NOT NULL,
  `Depth` double NULL,
  `Year` int(4) DEFAULT NULL, # Annee de mesure
  `Material` varchar(50) NOT NULL, # Ce qui est analyse pour la frfr
  PRIMARY KEY (`LabCode`),
  KEY `Age_Index` (`LabCode`)
  #FOREIGN KEY (Record_Name) REFERENCES Sites(Record_Name),
  #FOREIGN KEY (Citation_Key) REFERENCES Reference(Citation_Key)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# African Palaeo Database
# ------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------------------
# Graphical library


# Graphical library
# ------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------------------
# GCMs database


# GCMs database
# ------------------------------------------------------------------------------------------------------------------------

show tables;

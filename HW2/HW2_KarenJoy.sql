/*
Karen Joy Homework 2 DB Programming Submission: Sept 24/2020
*/

DROP DATABASE IF EXISTS usstrikecommand;
CREATE DATABASE usstrikecommand;
USE usstrikecommand;

CREATE TABLE USBomber(
	Designation VARCHAR(100),
	BRole VARCHAR(100) NOT NULL DEFAULT 'Strategic Bomber',
	InService INT NOT NULL,
	CONSTRAINT Pk_USBomber PRIMARY KEY (Designation)
);

CREATE TABLE bomber_general(
	Bomber VARCHAR(100),
	Manufacturer VARCHAR(100) NOT NULL DEFAULT 'Boeing',
	UnitCost INT NOT NULL,
	Description VARCHAR(100),
	CONSTRAINT Pk_bomber_general PRIMARY KEY (Bomber),
	CONSTRAINT Fk_bomber_general FOREIGN KEY (Bomber) REFERENCES USBomber(Designation)
);

CREATE TABLE bomber_units(
	Unitname VARCHAR(100) NOT NULL,
	B_Type ENUM('B1B','B2','B52H'),
	BCount INT NOT NULL,
	CONSTRAINT Pk_bomber_units PRIMARY KEY (Unitname)
);

CREATE TABLE bomber_inventory(
	Bomber_N VARCHAR(100),
	B_Type ENUM ('B1B','B2','B52H'),
	CONSTRAINT Pk_bomber_inventory PRIMARY KEY (Bomber_N)
);

CREATE TABLE performance(
	Bmbr VARCHAR(100), 
	MaxSpeed INT NOT NULL, 
	OpRange INT NOT NULL, 
	OpRadius INT NOT NULL, 
	OpCeiling INT NOT NULL,
	ClimbRate INT NOT NULL,
	CONSTRAINT Pk_performance PRIMARY KEY (Bmbr),
	CONSTRAINT Fk_performance FOREIGN KEY (Bmbr) REFERENCES USBomber(Designation)

);

CREATE TABLE armament(
	Bmbr VARCHAR(100),
	InternalBays VARCHAR(100),
	Hardpoints INT NOT NULL,
	CONSTRAINT Pk_armament PRIMARY KEY (Bmbr),
	CONSTRAINT Fk_armannent FOREIGN KEY (Bmbr) REFERENCES USBomber(Designation)

);

CREATE TABLE avionics(
	Bmbr VARCHAR(100),
	Radar VARCHAR(100),
	RadarWarning VARCHAR(100),
	Defense VARCHAR(100),
	Targetting VARCHAR(100),
	CONSTRAINT Pk_avionics PRIMARY KEY (Bmbr),
	CONSTRAINT Fk_Avionics FOREIGN KEY (Bmbr) REFERENCES USBomber(Designation)

);

CREATE TABLE characteristics(
	B_Type VARCHAR(100),
	Crew VARCHAR(100) NOT NULL DEFAULT '3',
	Payload VARCHAR(100),
	Length VARCHAR(100),
	WingSpan VARCHAR(100),
	Height INT NOT NULL,
	CONSTRAINT Pk_characteristics PRIMARY KEY (B_Type),
	CONSTRAINT Fk_Pk_characteristics FOREIGN KEY(B_Type) REFERENCES bomber_general(Bomber)
);

CREATE TABLE powerplant(
	B_Type VARCHAR(100),
	Engines VARCHAR(100) NOT NULL DEFAULT '2',
	EngineType VARCHAR(100),
	MaxThrust INT NOT NULL,
	CONSTRAINT Pk_powerplant PRIMARY KEY (B_Type)

);

#Import Data
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW2/HW2Data.sql

/* Solutions */
/* to */
/* queries:*/

#1. What is the total cost (in millions of dollars) of all B1B bombers assigned to the Ellsworth unit.

SELECT TRUNCATE((BG.UnitCost * BU.BCount)/1000000,2)
	FROM bomber_units BU
	JOIN  bomber_general BG
	ON BU.B_type = BG.Bomber
	WHERE BU.UnitName = 'Ellsworth' INTO @Query1;

SELECT CONCAT('The total cost of all B1B Bombers at Ellsworth AFB is ',FORMAT(@Query1, 'C4'),' million dollars') AS 'Query 1';

#SELECT CONCAT('The total cost of all B1B Bombers at Ellsworth AFB is ', @Query1,' million dollars') AS 'Query 1 without commas';


#2 How long does it take a B1B, flying at its maximum speed, to reach its operational range.

SELECT TRUNCATE ((PR.OpRange/PR.MaxSpeed),2)
	FROM performance PR
	JOIN USBomber USB
	ON PR.Bmbr = USB.Designation
	WHERE PR.Bmbr = 'B1B' INTO @Query2;

SELECT CONCAT('The time required for a B1B to fly to its Operational Range ', @Query2,' hours') AS 'Query2';

#3 How long does it take a B2, flying at half of its maximum speed, to reach a target 2,000 miles away.

SELECT ROUND ((2000/(PR.MaxSpeed/2)),2)
	FROM performance PR
	JOIN USBomber USB
	ON PR.Bmbr = USB.Designation
	WHERE PR.Bmbr = 'B2' INTO @Query3;

SELECT CONCAT('The time required for a B2 to fly to a target  2000 miles away is ', @Query3 , ' hours') AS 'Query3';

#4 What is the difference (in millions of dollars) between the total cost of all B1B bombers and the total cost of all B2 bombers.

SELECT UnitCost INTO @b1bCOST 
	FROM bomber_general 
	WHERE Bomber = 'B1B';

SELECT UnitCost INTO @b2COST 
	FROM bomber_general 
	WHERE Bomber = 'B2';

SELECT COUNT(*) INTO @b1bcount 
	FROM bomber_inventory 
	WHERE B_Type = 'B1B';

SELECT COUNT(*) INTO @b2count 
	FROM bomber_inventory 
	WHERE B_Type = 'B2';

SET @total = (@b1bCOST*@b1bcount)-(@b2COST*@b2count); #total = query 4

SELECT CONCAT('The difference between total costs of B1B and B2 is ', FORMAT(@total, 2),' dollars') AS 'Query 4';

#SELECT CONCAT('The difference between total costs of B1B and B2 is ', @total,' dollars') AS 'Query 4 without commas';


#5. What is the maximum speed, maximum thrust, and radar of the B1 and B2 bombers

SELECT CONCAT(USB.Designation,' ',USB.BRole) AS 'Bomber Type', 
	CONCAT(PR.MaxSpeed,' MPH') AS 'Maximum Aircraft Speed', 
	CONCAT(FORMAT(PW.MaxThrust,2),' LBS') AS 'Maximum Engine Thrust', 
	CONCAT(AV.Radar) AS 'Radar System' 
	FROM USBomber USB
	JOIN performance PR
	ON USB.Designation = PR.Bmbr
	JOIN powerplant PW
	ON USB.Designation = PW.B_type
	JOIN avionics AV
	ON USB.Designation = AV.Bmbr;


/*
Questions:

1. What is the total cost (in millions of dollars) of all B1B bombers assigned to the Ellsworth unit.
2. How long does it take a B1B, flying at its maximum speed, to reach its operational range.
3. How long does it take a B2, flying at half of its maximum speed, to reach a target 2,000 miles away.
4. What is the difference (in millions of dollars) between the total cost of all B1B bombers and the total cost of all B2 bombers.
5. What is the maximum speed, maximum thrust, and radar of the B1 and B2 bombers
	(must utilize an Equijoin is the creation of this query)

Solutions should be as follows: 

Query OK, 1 row affected (0.00 sec)

+---------------------------+
| FINAL SCRIPT MSG          |
+---------------------------+
| DATA POPULATION COMPLETED |
+---------------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)

+-----------------------------------------------------------------------------+
| Query 1                                                                     |
+-----------------------------------------------------------------------------+
| The total cost of all B1B Bombers at Ellsworth AFB is 9,600 million dollars |
+-----------------------------------------------------------------------------+
1 row in set, 1 warning (0.00 sec)

Query OK, 1 row affected (0.00 sec)

+------------------------------------------------------------------------+
| Query2                                                                 |
+------------------------------------------------------------------------+
| The time required for a B1B to fly to its Operational Range 6.14 hours |
+------------------------------------------------------------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)

+------------------------------------------------------------------------------+
| Query3                                                                       |
+------------------------------------------------------------------------------+
| The time required for a B2 to fly to a target  2000 miles away is 6.35 hours |
+------------------------------------------------------------------------------+
1 row in set (0.00 sec)

+------------------------------------------------------------------------------+
| Query 4                                                                      |
+------------------------------------------------------------------------------+
| The difference between total costs of B1B and B2 is 2,060,000,000.00 dollars |
+------------------------------------------------------------------------------+
1 row in set (0.00 sec)

+----------------------+------------------------+-----------------------+--------------+
| Bomber Type          | Maximum Aircraft Speed | Maximum Engine Thrust | Radar System |
+----------------------+------------------------+-----------------------+--------------+
| B1B Strategic Bomber | 830 MPH                | 30,780.00 LBS         | ANALQ161     |
| B2 Strategic Bomber  | 630 MPH                | 34,600.00 LBS         | ANALQ181     |
+----------------------+------------------------+-----------------------+--------------+
2 rows in set (0.00 sec)

*/









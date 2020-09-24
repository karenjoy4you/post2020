/*
Titanic Database Homework 1
This database contains:
	Passenger information for the RMS Titanic (Training Set)
---These features are included in the Titanic Dataset... https://www.kaggle.com/c/titanic-survival/data
Labelled Feature: Survival... 0 No 1 Yes
Arbitrary Feature: Passenger Number...1 to 891
Raw Features:
	Passenger Class (Pclass)... 1 (First Class) 2 (Second Class) 3 (Third Class)
	Passenger Name (name)...Passengers Name
	Passenger Gender (sex)... male or female
	Passenger Age (age)...Passenger's Age
	Passenger Sibling Count (sibsp)...Number of Siblings or Spouses aboard
	Passenger Parent/Child Count (parch)...Number of Parents or Children aboard
	Passenger Ticket Number (ticket)...Passenger's Ticket Number
	Passenger Fare Cost (fare)...Fare paid by Passenger
	Passenger Cabin (cabin)...Designation of Passenger's Cabin
	Passenger Port of Embarkation (emabrked)...Where the passenger boarded the ship C (Cherbourg) Q (Queenstown) S (Southhampton) 
	Passenger Home or Destination (home.dest)...Where the passenger would debark the ship
*/

DROP DATABASE IF EXISTS titanic;
CREATE DATABASE titanic;
USE titanic;

CREATE TABLE Passenger(
PNumber INT,
PGender Enum('male','female') NOT NULL DEFAULT 'UNK',
PAge DECIMAL(10,2) NOT NULL DEFAULT 0.0,
CONSTRAINT pk_passenger PRIMARY KEY(PNumber)
);

CREATE TABLE PassengerName(
PNumber INT,
PName VARCHAR(100) NOT NULL DEFAULT 'UNK',
CONSTRAINT pk_passName PRIMARY KEY(PNumber),
CONSTRAINT fk_passName FOREIGN KEY(PNumber) REFERENCES Passenger(PNumber),
CONSTRAINT uk_passName UNIQUE KEY(PName)
);

CREATE TABLE Companions(
PNumber INT,
PSib INT NOT NULL DEFAULT 0,
PPOC INT NOT NULL DEFAULT 0,
CONSTRAINT pk_companions PRIMARY KEY(PNumber),
CONSTRAINT fk_companions FOREIGN KEY(PNumber) REFERENCES Passenger(PNumber)
);

CREATE TABLE Ticketing(
PNumber INT,
PClass INT NOT NULL DEFAULT 0,
TicketNumber VARCHAR(40) NOT NULL DEFAULT 'UNK',
FarePrice DECIMAL(10,2) NOT NULL DEFAULT 0.0,
Cabin VARCHAR(40) NOT NULL DEFAULT 'UNK',
Embarked VARCHAR(10) NOT NULL DEFAULT 'UNK',
CONSTRAINT pk_ticketing PRIMARY KEY(PNumber),
CONSTRAINT fk_ticketing FOREIGN KEY(PNumber) REFERENCES Passenger(PNumber)
);

CREATE TABLE Survival(
PNumber INT,
Survived INT NOT NULL DEFAULT 0,
CONSTRAINT pk_survival PRIMARY KEY(PNumber),
CONSTRAINT fk_survival FOREIGN KEY(PNumber) REFERENCES Passenger(PNumber)
);

SELECT 'TRANSFER TO PASSENGER TABLE POPULATION SCRIPT' AS MSG_1;
-- source [your file path]\Passenger.sql
SELECT 'TRANSFER TO PASSENGERNAME TABLE POPULATION SCRIPT' AS MSG_2;
-- source [your file path]\PassengerName.sql
SELECT 'TRANSFER TO COMPANIONS TABLE POPULATION SCRIPT' AS MSG_3;
-- source [your file path]\Companions.sql

SELECT 'TRANSFER TO TICKETING TABLE POPULATION SCRIPT' AS MSG_4;
-- source [your file path]\Ticketing.sql
SELECT 'TRANSFER TO SURVIVAL TABLE POPULATION SCRIPT' AS MSG_5;
-- source [your file path]\Survival.sql
SELECT 'SCRIPT COMPLETE' AS Final_MSG;

SELECT * FROM Passenger LIMIT 3;
SELECT * FROM PassengerName LIMIT 3;
SELECT * FROM Companions LIMIT 3;
SELECT * FROM Ticketing LIMIT 3;
SELECT * FROM Survival LIMIT 3;

-- QUERIES
SELECT 'Titanic Database QUERIES' AS MSG;

# TASK 1: How many passengers are female
SELECT COUNT(*) AS 'Female Passenger Count' FROM Passenger WHERE PGender = 'Female';
# TASK 2: How many passengers are male
SELECT COUNT(*) AS 'Male Passenger Count' FROM Passenger WHERE PGender = 'Male';
# TASK 3: How many passengers are over 30
SELECT COUNT(*) AS 'Over 30 Passenger Count' FROM Passenger WHERE PAge > 30;
# TASK 4: How many passengers are under 30
SELECT COUNT(*) AS '30 or Under 30 Passenger Count' FROM Passenger WHERE PAge <= 30;
# TASK 5: How many female passengers survived
SELECT COUNT(Passenger.PNumber) AS 'Female Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Passenger.PGender = 'Female' AND Survival.Survived = 1;
# TASK 6: How many male passengers survived
SELECT COUNT(Passenger.PNumber) AS 'Male Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Passenger.PGender = 'Male' AND Survival.Survived = 1;
# TASK 7: How many female passengers over 30 survived
SELECT COUNT(Passenger.PNumber) AS 'Female Over 30 Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Passenger.PGender = 'Female' AND Passenger.PAge > 30 AND Survival.Survived = 1;
# TASK 8: How many first class passengers survived
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 1 AND Ticketing.PClass = 1;
# TASK 10: How many first class male passengers survived
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Male Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 1 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Male';
# TASK 11: How many first class female passengers survived
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Female Survivor Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 1 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Female';
# TASK 11: How many first class female passengers did not survive
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Female Perished Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 0 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Female';
# TASK 12: How many first class male passengers did not survive
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Male Perished Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 0 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Male';
# TASK 13: How many first class male passengers under 20 did not survive
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Under 20 Male Perished Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 0 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Male' AND Passenger.PAge < 20;
# TASK 14: How many first class female passengers under 20 did not survive
SELECT COUNT(Passenger.PNumber) AS 'First Class Cabin Under 20 Female Perished Count' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
JOIN Ticketing ON Passenger.PNumber = Ticketing.PNumber
WHERE Survival.Survived = 0 AND Ticketing.PClass = 1 AND Passenger.PGender = 'Female';
# TASK 15: Maximum age of female survivor
SELECT MAX(Passenger.PAge) AS 'Maximum Age of Female Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Female';
# TASK 16: Minimum age of female survivor
SELECT MIN(Passenger.PAge) AS 'Minimum Age of Female Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Female';
# TASK 17: Mean age of female survivor
SELECT AVG(Passenger.PAge) AS 'Mean Age of Female Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Female';
# TASK 18: Maximum age of male survivor
SELECT MAX(Passenger.PAge) AS 'Maximum Age of Male Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Male';
# TASK 19: Minimum age of male survivor
SELECT MIN(Passenger.PAge) AS 'Minimum Age of Male Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Male';
# TASK 20: Mean age of male survivor
SELECT AVG(Passenger.PAge) AS 'Mean Age of Male Survivor' 
FROM Passenger
JOIN Survival ON Passenger.PNumber = Survival.PNumber
WHERE Survival.Survived = 1 AND Passenger.PGender = 'Male';
/*
Karen Joy Homework 1 DB Programming Submission: Sept 17/2020
*/

DROP DATABASE IF EXISTS titanic;
CREATE DATABASE titanic;
USE titanic;

CREATE TABLE Passenger(
	Pnumber VARCHAR(100) NOT NULL,
	PGender VARCHAR(100) NOT NULL DEFAULT 'UNK',
	PAge VARCHAR(100) NOT NULL DEFAULT 0,
	CONSTRAINT Pk_Passenger PRIMARY KEY (Pnumber)
);

CREATE TABLE PassengerName(
	Pnumber VARCHAR(100) NOT NULL,
	PName VARCHAR(100) NOT NULL DEFAULT'UNK',
	CONSTRAINT Pk_PassengerName PRIMARY KEY (Pnumber)

);

CREATE TABLE Companions(
	Pnumber VARCHAR(100) NOT NULL,
	PSib VARCHAR(100) NOT NULL,
	PPOC VARCHAR(100) NOT NULL,
	CONSTRAINT Pk_Companions PRIMARY KEY (Pnumber),
	CONSTRAINT FK_Companions FOREIGN KEY (Pnumber) REFERENCES Passenger(Pnumber)
);

CREATE TABLE Ticketing(
	Pnumber VARCHAR(100) NOT NULL,
	PClass VARCHAR(100),
	TicketNumber VARCHAR(100) NOT NULL,
	FarePrice VARCHAR(100),
	Cabin VARCHAR(100),
	Embarked VARCHAR(100),
	CONSTRAINT Pk_Ticketing PRIMARY KEY (Pnumber),
	CONSTRAINT Fk_Ticketing FOREIGN KEY (Pnumber) REFERENCES Passenger(Pnumber)

);

CREATE TABLE Survival(
	Pnumber VARCHAR(100) NOT NULL,
	Survived VARCHAR(100),
	CONSTRAINT Pk_Survival PRIMARY KEY (Pnumber),
	CONSTRAINT Fk_Survival FOREIGN KEY (Pnumber) REFERENCES Passenger(Pnumber)
);

# Passenger 
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW1/Passenger(1).sql
# PassengerName
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW1/PassengerName(1).sql
#Companions
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW1/Companions(1).sql
#Ticketing
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW1/Ticketing(1).sql
#Survival
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/HW1/Survival(1).sql


/* Solutions */
/* to */
/* queries:*/

#1. How many passengers are female?

SELECT COUNT(*) AS 'Count of Female Passengers'
	FROM Passenger
	WHERE PGender = 'female';

#2. How many passengers are male?

SELECT COUNT(*) AS 'Count of Male Passengers'
	FROM Passenger
	WHERE PGender = 'Male';

#3. How many passengers are over 30 years of age?

SELECT COUNT(*) AS 'Passengers over 30'
	FROM Passenger
	WHERE PAge>30;

#4. How many passengers are under 30?

SELECT COUNT(*) AS 'Passengers under 30'
	FROM Passenger
	WHERE PAge<30;

#5. How many female passengers survived?

SELECT COUNT(*) AS 'Female Survivors'
	FROM Passenger Pas JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	WHERE Pas.PGender = 'female' AND Sur.Survived = 1;

#6. How many male passengers survived?

SELECT COUNT(*) AS 'Male Survivors'
	FROM Passenger Pas JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	WHERE Pas.PGender = 'male' AND Sur.Survived = 1;

#7. How many female passengers over 30 survived?

SELECT COUNT(*) AS 'Female passengers over 30'
	FROM Passenger Pas JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	WHERE Pas.PGender='female' AND Pas.PAge>30 AND Sur.Survived = 1;

#8. How many first class passengers survived?

SELECT COUNT(*) AS 'First Class Survivors'
	FROM Ticketing Tic JOIN Survival Sur ON Tic.Pnumber = Sur.Pnumber
	WHERE Tic.PClass = 1 AND Sur.Survived = 1;

#9. How many first class male passengers survived?

SELECT COUNT(*) AS 'Male First Class Survivors'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	JOIN Ticketing Tic ON Sur.Pnumber = Tic.Pnumber
	WHERE Pas.PGender = 'male' AND Sur.Survived = 1 AND Tic.PClass = 1;


#10.How many first class female passengers survived?

SELECT COUNT(*) AS 'Female First Class Survivors'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	JOIN Ticketing Tic ON Sur.Pnumber = Tic.Pnumber
	WHERE Pas.PGender = 'female' AND Sur.Survived = 1 AND Tic.PClass = 1;

#11. How many first class female passengers did not survive?

SELECT COUNT(*) AS 'Deceased Female Passenger in First Class'
	FROM Passenger Pas 
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	JOIN Ticketing Tic ON Tic.PClass = Sur.Pnumber
	WHERE Pas.PGender='female' AND Sur.Survived = 0 AND Tic.PClass = 1;

#12. How many first class male passengers did not survive?

SELECT COUNT(*) AS 'Deceased Male Passenger in First Class'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	JOIN Ticketing Tic ON Sur.Pnumber = Tic.PClass
	WHERE Pas.PGender='male' AND Sur.Survived = 0 AND Tic.PClass = 1;

#13. How many first class male passengers under 20 did not survive?

SELECT COUNT(*) AS 'Deceased First Class Male Passengers under 20'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber = Sur.Pnumber
	JOIN Ticketing Tic ON Sur.Pnumber = Tic.PClass
	WHERE Pas.PGender = 'male' AND Pas.PAge<20 AND Sur.Survived=0 AND Tic.PClass = 1;


#14. How many first class female passengers under 20 did not survive?

SELECT COUNT(*) AS 'Deceased First Class Female Passengers under 20'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	JOIN Ticketing Tic ON Sur.Pnumber= Tic.PClass
	WHERE Pas.PGender='female' AND Pas.PAge<20 AND Sur.Survived=0 AND Tic.PClass = 1;


#15. Maximum age of female survivors?

SELECT MAX(Pas.PAge) AS 'Maximum age of female survivor'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender='female' AND Sur.Survived = 1; 

#16. Minimum age of female survivors?


SELECT MIN(Pas.PAge) AS 'Minimum age of female survivor'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender = 'female' AND Sur.Survived = 1 ;

#17. Mean age of female survivors?

SELECT AVG(Pas.PAge)
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender = 'female' AND Sur. Survived = 1;

#18. Maximum age of male survivors?

SELECT MAX(Pas.PAge) AS 'Maximum age of male survivor'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender='male' AND Sur.Survived = 1; 

#19. Minimum age of male survivors?

SELECT MIN(Pas.PAge) AS 'Minimum age of male survivor'
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender = 'male' AND Sur.Survived = 1 ;

#20. Mean age of male survivors?

SELECT AVG(Pas.PAge)
	FROM Passenger Pas
	JOIN Survival Sur ON Pas.Pnumber=Sur.Pnumber
	WHERE Pas.PGender = 'male' AND Sur. Survived = 1;


/* Solutions */
/* to */
/* queries:

1.How many passengers are female?
	314
2. How many passengers are male?
	577
3. How many passengers are over 30 years of age?
	305
4. How many passengers are under 30?
	561
5. How many female passengers survived?
	233
6. How many male passengers survived?
	109
7. How many female passengers over 30 survived?
	83
8. How many first class passengers survived?
	136
9. How many first class male passengers survived?
	45
10.How many first class female passengers survived?
	91
11. How many first class female passengers did not survive?
	0
12. How many first class male passengers did not survive?
	216
13. How many first class male passengers under 20 did not survive?
	0
14. How many first class female passengers under 20 did not survive?
	0
15. Maximum age of female survivors?
	8
16. Minimum age of female survivors?
	0
17. Mean age of female survivors?
	24.39
18. Maximum age of male survivors?
	9
19. Minimum age of male survivors?
	0
20. Mean age of male survivors?
	23.27
*/



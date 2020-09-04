/*LECTURE 2 PRACTICAL EX. PPT SLIDE 29*/

DROP DATABASE IF EXISTS pacestudent;
CREATE DATABASE pacestudent;
USE pacestudent;

CREATE TABLE STUDENT(
IDNumber VARCHAR(10),
LastName VARCHAR(10),
FirstName VARCHAR(10),
Age INT(10),
Gender VARCHAR(10),
Major VARCHAR(10),
CONSTRAINT PK_STUDENT PRIMARY KEY(IDNumber)
);


CREATE TABLE MEALS(
IDNumber VARCHAR(10),
MealNumber VARCHAR(10),
CONSTRAINT PK_MEALS PRIMARY Key(MealNumber),
CONSTRAINT FK_MEALS FOREIGN KEY (IDNumber) REFERENCES STUDENT(IDNumber)
);


INSERT INTO STUDENT VALUES ('U001','Anderson','Donald','23','Male','CS');
INSERT INTO STUDENT VALUES ('U002','Baker','Erica','24','Female','IS');

INSERT INTO MEALS VALUES ('U001','A678');
INSERT INTO MEALS VALUES ('U002','B789');

SELECT * FROM STUDENT;
SELECT * FROM MEALS;


/*
mysql> source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/DBCodes/lec2practice.sql
Query OK, 0 rows affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Database changed
Query OK, 0 rows affected, 1 warning (0.05 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 1 row affected (0.01 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

+----------+----------+-----------+------+--------+-------+
| IDNumber | LastName | FirstName | Age  | Gender | Major |
+----------+----------+-----------+------+--------+-------+
| U001     | Anderson | Donald    |   23 | Male   | CS    |
| U002     | Baker    | Erica     |   24 | Female | IS    |
+----------+----------+-----------+------+--------+-------+
2 rows in set (0.00 sec)

+----------+------------+
| IDNumber | MealNumber |
+----------+------------+
| U001     | A678       |
| U002     | B789       |
+----------+------------+
2 rows in set (0.00 sec)

mysql> 
*/
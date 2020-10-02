/* Exam Midterm - Karen Joy , 1st Oct 2020 */

DROP DATABASE IF EXISTS paceWSN2;
CREATE DATABASE paceWSN2;
USE paceWSN2;

CREATE TABLE node(

	IDNumber VARCHAR(100) NOT NULL,
	NodeType VARCHAR(100) NOT NULL DEFAULT 'Computer',
	Location_X INT NOT NULL,
	Location_Y INT NOT NULL,
	NodeStatus ENUM('Online','Offline') NOT NULL DEFAULT 'Online',

	CONSTRAINT Pk_node PRIMARY KEY(IDNumber)

);

CREATE TABLE node_battery(

	BatteryID VARCHAR(100) NOT NULL,
	Voltage INT NOT NULL,
	Ampheres DECIMAL(6,2) GENERATED ALWAYS AS (1.85 * Voltage),
	ServiceLife DECIMAL(6,2) GENERATED ALWAYS AS (11.7 * Ampheres),
	
	CONSTRAINT Pk_node_battery PRIMARY KEY(BatteryID)

);


CREATE TABLE node_type(

	NodeID VARCHAR(100) NOT NULL,
	NodeType ENUM('Active') NOT NULL DEFAULT 'Active',
	HWCost DECIMAL(6,2) NOT NULL,
	SWCost DECIMAL(6,2) NOT NULL,
	NodeCost DECIMAL(6,2) GENERATED ALWAYS AS ((0.2 * HWCost) + (0.8 * SWCost)),
	ServiceLife DECIMAL(6,2) GENERATED ALWAYS AS (LN(NodeCost)),
	Battery VARCHAR(100) NOT NULL,

	CONSTRAINT Pk_node_type PRIMARY KEY(NodeID),
	CONSTRAINT Fk1_node_type FOREIGN KEY(NodeID) REFERENCES node(IDNumber),
	CONSTRAINT Fk2_node_type FOREIGN KEY(Battery) REFERENCES node_battery(BatteryID)

);

CREATE TABLE network(

	NetworkID VARCHAR (100) NOT NULL,
	NetworkName VARCHAR (100) NOT NULL,
	NetworkType ENUM('Secure','Unsecure') NOT NULL DEFAULT 'Secure',

	CONSTRAINT Pk_network PRIMARY KEY(NetworkID),
	CONSTRAINT Uk_network UNIQUE KEY(NetworkName)

);

CREATE TABLE network_gateway(
	
	GatewayID VARCHAR (100) NOT NULL,
	NetworkID VARCHAR (100) NOT NULL,

	CONSTRAINT Pk_network_gateway PRIMARY KEY(GatewayID),
	CONSTRAINT Fk_network_gateway FOREIGN KEY(NetworkID) REFERENCES network(NetworkID)
);

CREATE TABLE network_band(

	NetworkID VARCHAR (100) NOT NULL,
	LinkBand ENUM('I','J') NOT NULL DEFAULT 'I',
	LinkType ENUM ('SAT', 'WIRE') NOT NULL DEFAULT 'WIRE',

	CONSTRAINT Pk_network_band PRIMARY KEY(NetworkID),
	CONSTRAINT Fk_network_band FOREIGN KEY(NetworkID) REFERENCES network(NetworkID)

);


CREATE TABLE node_inNetwork(

	NodeID VARCHAR(100) NOT NULL,
	Connected VARCHAR(100) NOT NULL,
	NodeAccessCode VARCHAR(100) GENERATED ALWAYS AS (CONCAT(NodeID,'-X-',Connected)),
	
	CONSTRAINT Pk_node_inNetwork PRIMARY KEY(NodeID),
	CONSTRAINT Fk1_node_inNetwork FOREIGN KEY(Connected) REFERENCES network(NetworkName),
	CONSTRAINT Fk2_node_inNetwork FOREIGN KEY(NodeID) REFERENCES node(IDNumber)

);


#import data file
source /Users/karenjoy/Documents/ClassesFall2020/IS664 - DB programming/ExamMidterm/Exam1Data.sql


/*Solution to Queries*/

#1. What is the Voltage, Ampheres, and Service Life of the Batteries for all Nodes that are not in the A Network

SELECT NB.Voltage, NB.Ampheres, NB.ServiceLife, NIN.NodeID, NIN.Connected AS 'Connected to this Network'
	FROM node_battery NB
	JOIN node_type NTY ON NTY.Battery = NB.BatteryID
	JOIN node_inNetwork NIN ON NTY.NodeID = NIN.NodeID
	WHERE NIN.Connected!='A';

#2. What is the average service life of all batteries not in the C Network

SELECT CONCAT(ROUND(AVG(NB.ServiceLife),2),' hours ') AS 'Mean Service Life A and B Node Batteries'
	FROM node_battery NB
	JOIN node_type NTY ON NTY.Battery = NB.BatteryID
	JOIN node_inNetwork NIN ON NTY.NodeID = NIN.NodeID
	WHERE NIN.Connected!='C';

/*  

3. Create the view nodeView that displays the NodeID, NodeType, HWCost, SWCost, and NodeCost, Network and
NodeAccessCode for all Nodes that are in either the A or C Networks (assume that there may be may more
networks than are represented in your data)

4. Show all the tuples in nodeView */

CREATE VIEW nodeView AS

SELECT NTY.NodeID, NTY.NodeType, 

	CONCAT('$ ',NTY.HWCost) AS 'Hardware', CONCAT('$ ',NTY.SWCost) AS 'Software', 
	CONCAT('$ ',NTY.NodeCost) AS 'Total Node Cost', NIN.Connected AS 'Network Assigned'

	FROM node_type NTY
	JOIN node NO ON NTY.NodeID = NO.IDNumber
	JOIN node_inNetwork NIN ON NIN.NodeID = NO.IDNumber
	WHERE NIN.Connected = 'A' OR NIN.Connected = 'C';

SELECT * FROM nodeView;

/*

OUTPUT:

+----------------------+
| MSG_FINAL            |
+----------------------+
| POPULATION COMPLETED |
+----------------------+
1 row in set (0.00 sec)

+---------+----------+-------------+--------+---------------------------+
| Voltage | Ampheres | ServiceLife | NodeID | Connected to this Network |
+---------+----------+-------------+--------+---------------------------+
|      12 |    22.20 |      259.74 | N5     | B                         |
|      12 |    22.20 |      259.74 | N6     | B                         |
|      12 |    22.20 |      259.74 | N7     | B                         |
|      12 |    22.20 |      259.74 | N8     | B                         |
|      13 |    24.05 |      281.39 | N10    | C                         |
|      13 |    24.05 |      281.39 | N11    | C                         |
|      13 |    24.05 |      281.39 | N12    | C                         |
|      13 |    24.05 |      281.39 | N9     | C                         |
+---------+----------+-------------+--------+---------------------------+
8 rows in set (0.00 sec)

+------------------------------------------+
| Mean Service Life A and B Node Batteries |
+------------------------------------------+
| 248.92 hours                             |
+------------------------------------------+
1 row in set (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

+--------+----------+----------+----------+-----------------+------------------+
| NodeID | NodeType | Hardware | Software | Total Node Cost | Network Assigned |
+--------+----------+----------+----------+-----------------+------------------+
| N1     | Active   | $ 12.50  | $ 9.75   | $ 10.30         | A                |
| N2     | Active   | $ 12.50  | $ 9.75   | $ 10.30         | A                |
| N3     | Active   | $ 12.50  | $ 9.75   | $ 10.30         | A                |
| N4     | Active   | $ 12.50  | $ 9.75   | $ 10.30         | A                |
| N10    | Active   | $ 10.80  | $ 3.15   | $ 4.68          | C                |
| N11    | Active   | $ 10.80  | $ 3.15   | $ 4.68          | C                |
| N12    | Active   | $ 10.80  | $ 3.15   | $ 4.68          | C                |
| N9     | Active   | $ 10.80  | $ 3.15   | $ 4.68          | C                |
+--------+----------+----------+----------+-----------------+------------------+
8 rows in set (0.00 sec)

mysql> 

*/
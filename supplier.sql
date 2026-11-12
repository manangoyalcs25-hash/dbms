
CREATE DATABASE 1BM25CS172;
USE 1BM25CS172;
CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(30)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2) CHECK (cost >= 0),

    PRIMARY KEY (sid, pid),

    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES
(1, 'Acme Widget Suppliers', 'Delhi'),
(2, 'Global Traders', 'Mumbai'),
(3, 'National Traders', 'Delhi');

INSERT INTO Parts VALUES
(101, 'Nut', 'Red'),
(102, 'Bolt', 'Blue'),
(103, 'Gear', 'Red');

INSERT INTO Catalog VALUES
(1, 101, 50),
(1, 102, 40),
(1, 103, 60),
(2, 101, 55),
(2, 102, 40),
(2, 103, 70),
(3, 101, 70),
(3, 102, 71),
(3, 103, 50);

SELECT * FROM Supplier;
SELECT * FROM Parts;
SELECT * FROM Catalog;


SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid;


SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);

SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE P.color = 'Red'
    AND NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);

SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Supplier S ON C.sid = S.sid
WHERE S.sname = 'Acme Widget Suppliers'
AND NOT EXISTS (
    SELECT *
    FROM Catalog C2
    WHERE C2.pid = P.pid
    AND C2.sid <> S.sid
);


SELECT DISTINCT C1.sid
FROM Catalog C1
WHERE C1.cost > (
    SELECT AVG(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C1.pid
);

SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
JOIN Parts P ON C.pid = P.pid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);


SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Parts P ON C.pid = P.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(cost)
    FROM Catalog
);


SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Catalog C
    JOIN Parts P ON C.pid = P.pid
    WHERE C.sid = S.sid
    AND P.color = 'Red'
);


SELECT S.sname, SUM(C.cost) AS total_value
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT C.pid) >= 2;


SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Parts P ON C.pid = P.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MIN(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);

CREATE VIEW Most_Expensive_Supplier AS
SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Parts P ON C.pid = P.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);



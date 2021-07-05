USE task6;

CREATE TABLE IF NOT EXISTS students_tmp (
id INT NOT NULL,
studentid INT NOT NULL AUTO_INCREMENT,
student VARCHAR(255) NOT NULL,
PRIMARY KEY (studentid)
 );
 
LOAD DATA LOCAL INFILE '/var/lib/mysql/L_O_S.csv'
INTO TABLE students_tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (id, student);

CREATE TABLE IF NOT EXISTS result_tmp (
id int NOT NULL AUTO_INCREMENT,
Task1 VARCHAR(255) NOT NULL,
Task2 VARCHAR(255) NOT NULL,
Task3 VARCHAR(255) NOT NULL,
Task4 VARCHAR(255) NOT NULL,
studentid INT NOT NULL,
FOREIGN KEY (studentid) REFERENCES students_tmp(studentid),
PRIMARY KEY (id)
 );
 
SET foreign_key_checks = 0;
 
LOAD DATA LOCAL INFILE '/var/lib/mysql/L_O_S.csv'
INTO TABLE result_tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id, @student, @Task1, @Task2, @Task3, @Task4)
set id=@id, Task1=@Task1, Task2=@Task2, Task3=@Task3, Task4=@Task4;



CREATE TABLE IF NOT EXISTS students (
id INT NOT NULL,
studentid INT NOT NULL AUTO_INCREMENT,
student VARCHAR(255) NOT NULL,
PRIMARY KEY (studentid)
 );
 
CREATE TABLE IF NOT EXISTS result (
id int NOT NULL AUTO_INCREMENT,
Task1 VARCHAR(255) NOT NULL,
Task2 VARCHAR(255) NOT NULL,
Task3 VARCHAR(255) NOT NULL,
Task4 VARCHAR(255) NOT NULL,
studentid INT NOT NULL,
FOREIGN KEY (studentid) REFERENCES students(studentid),
PRIMARY KEY (id)
 );
 
INSERT into students (student, studentid) SELECT student,studentid FROM students_tmp WHERE students_tmp.studentid NOT IN (SELECT studentid FROM students);
INSERT into result (studentid,Task1,Task2,Task3,Task4) SELECT studentid,Task1,Task2,Task3,Task4 FROM result_tmp WHERE result_tmp.studentid NOT IN (SELECT studentid from result);

SET foreign_key_checks = 1;

DROP TABLE result_tmp;  
DROP TABLE students_tmp;



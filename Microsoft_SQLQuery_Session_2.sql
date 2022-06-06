CREATE DATABASE LibDatabase;

Use LibDatabase;

--Create Two Schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;

--create Book.Book table

--create Book.Book table
CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL

	);

  --create Book.Author table

CREATE TABLE [Book].[Author](
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);  

--create Publisher Table

CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL
	);



 --create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY NOT NULL,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);   

    --create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);

  --cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);
  

  --INSERT

  INSERT person.Person (SSN, Person_FirstName, Person_LastName)
  VALUES(75056659595, 'Zehra', 'Tekin');

  -- INSERT INTO  person.Person (SSN, Person_FirstName, Person_LastName)
  -- VALUES(75056659595, 'Zehra', 'Tekin');


-- Applied to all columns
  INSERT person.Person ()
  VALUES(889623218866, 'Kerem', 'Yılmaz');

 -- Last_Name column should be NULL able!
 INSERT person.Person (SSN, Person_FirstName)
 VALUES(889623218876, 'Kerim');

 --

 INSERT Person.Person VALUES (35532888963,'Ali','Tekin');
 INSERT Person.Person VALUES (88232556264,'Metin','Sakin');

 
 -- Insert more than one values w/ one command 

 INSERT Person.Person 
 VALUES (35534588963,'Ali',null),
        (88232556514,'Metin',null);


--Mail_Id Column --> Because of being IDENTITY Column (Seed, Increment)
-- Only 2 insertion is enough.

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963);


--SELECT ... INTO

SELECT *
FROM Person.Person;

SELECT *
INTO Person.Person2
FROM Person.Person;

SELECT *
FROM Person.Person2;

--INSERT INTO SELECT

INSERT Person.Person2
SELECT * FROM Person.Person
WHERE Person_FirstName = 'Ali';

--- INSERT DEFAULT VALUES

INSERT Book.Publisher
DEFAULT VALUES

SELECT * FROM Book.Publisher;


--UPDATE

UPDATE Person.Person2
SET Person_FirstName = 'Default_name'

SELECT * 
FROM Person.Person2

UPDATE Person.Person2
SET Person_FirstName = 'Ahmet'
WHERE Person_LastName = 'Yilmaz';

SELECT * 
FROM Person.Person2


--DELETE

insert Book.Publisher values ('�� Bankas� K�lt�r Yay�nc�l�k'), ('Can Yay�nc�l�k'), ('�leti�im Yay�nc�l�k')

DELETE 
FROM Book.Publisher;

INSERT Book.Publisher values ('CONTACT')

DELETE FROM Book.Publisher
WHERE Publisher_Name = 'CONTACT';


--DROP TABLE

DROP TABLE Person.Person2

--TRUNCATE TABLE (Format Table)

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;


--ALTER TABLE


---book.book


ALTER TABLE Book.Author 
ALTER COLUMN Author_ID  INT NOT NULL 

ALTER TABLE Book.Author 
ADD CONSTRAINT pk_author
PRIMARY KEY (Author_ID)



ALTER TABLE book.book 
ADD CONSTRAINT FK_Author 
FOREIGN KEY (Author_ID)
REFERENCES book.author (Author_ID)

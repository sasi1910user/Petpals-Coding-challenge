--1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”
CREATE DATABASE PetPals;
--2. Create tables for pets, shelters, donations, adoption events, and participants. 
CREATE TABLE Pets(
    PetID INT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Breed VARCHAR(255),
    Type VARCHAR(50),
    AvailableForAdoption BIT);


CREATE TABLE Shelters(
    ShelterID INT PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255));

CREATE TABLE Donations(
	DonationID INT PRIMARY KEY,
	DonorName VARCHAR(255),
    DonationType VARCHAR(50),
    DonationAmount DECIMAL(10, 2),
    DonationItem VARCHAR(255),
    DonationDate DATETIME,
	ShelterID int foreign key references Shelters(ShelterID));

CREATE TABLE AdoptionEvents(
    EventID INT PRIMARY KEY,
    EventName VARCHAR(255),
    EventDate DATETIME,
    Location VARCHAR(255));

CREATE TABLE Participants(
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(255),
    ParticipantType VARCHAR(50),
    EventID INT,
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID));

	
-- Example records for Pets table
INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption)
VALUES
    (1, 'Buddy', 3, 'Golden Retriever', 'Dog', 1),
    (2, 'Mittens', 2, 'Persian', 'Cat', 1),
    (3, 'Rocky', 1, 'German Shepherd', 'Dog', 0);

Select * from Pets

-- Example records for Shelters table
INSERT INTO Shelters (ShelterID, Name, Location)
VALUES
    (101, 'Happy Paws Shelter', 'Chennai'),
    (102, 'Second Chance Rescue', 'Hyderabad'),
    (103, 'Safe Haven Animal Shelter', 'Bangalore');

Select * from Shelters
-- Example records for Donations table
INSERT INTO Donations (DonationID, DonorName, DonationType, DonationAmount, DonationItem, DonationDate, ShelterID)
VALUES
    (1, 'Bargavi', 'Cash', 10000.00, NULL, '2024-04-15 03:30:00',101),
    (2, 'Ram', 'Item', NULL, 'Pet Food', '2024-05-20 07:45:00',103),
    (3, 'Priya', 'Cash', 5000.00, NULL, '2024-04-25 10:10:00',103);


Select * from Donations

-- Example records for AdoptionEvents table
INSERT INTO AdoptionEvents (EventID, EventName, EventDate, Location)
VALUES
    (1, 'Adoption Day', '2024-05-10 12:00:00', 'Central Park'),
    (2, 'Rescue Festival', '2024-06-15 10:00:00', 'City Hall Plaza'),
    (3, 'Pet Expo', '2024-07-20 09:30:00', 'Convention Center');

Select * from AdoptionEvents;

-- Example records for Participants table
INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID)
VALUES
    (1,'Happy Paws Shelter','Shelter',1),
    (2,'Chandini','Adopter', 1),
    (3,'Second Chance Rescue','Shelter',2);

Select * from Participants;

--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption)
--from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that
--the query filters out pets that are not available for adoption--

Select Name,Age,Breed,Type
FROM Pets
WHERE AvailableForAdoption = 1;

--6.. Write an SQL query that retrieves the names of participants (shelters and adopters) registered 
--for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query 
--joins the necessary tables to retrieve the participant names and types.

Select ParticipantName,ParticipantType
FROM Participants
JOIN AdoptionEvents ON Participants.EventID = AdoptionEvents.EventID
WHERE AdoptionEvents.EventID = 1;


--7. Create a stored procedure in SQL that allows a shelter to update its information (name and location)
--in the "Shelters" table. Use parameters to pass the shelter ID and the new information. 
--Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID




--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) 
--from the "Donations" table. The result should include the shelter name and the total donation amount. 
--Ensure that the query handles cases where a shelter has received no donations.

select s.shelterid,s.name as sheltername,d.donationamount from donations d join shelters s 
on s.shelterid=d.shelterid 
where d.donationamount is not null
order by DonationAmount desc

--9.. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). 
--Include the pet's name, age, breed, and type in the result set.

Alter table Pets ADD OwnerID int;

Select * from pets
update pets set OwnerID=1 where PetID=1;
update pets set OwnerID=2 where PetID=2;
update pets set OwnerID=NULL where PetID=3;

SELECT Name,Age,Breed,Type
FROM Pets
WHERE OwnerID IS NULL;

--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g., 
--January 2023) from the "Donations" table. The result should include the month-year and the 
--corresponding total donation amount. Ensure that the query handles cases where no donations 
--were made in a specific month-year.--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption)
VALUES
(4, 'Abbie', 7, 'Campbell Dwarf', 'Hamster', 4),
(5, 'Bam', 5, 'Doberman', 'Dog', null);

SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 3 OR Age > 5;


--12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
alter table PETS 
add ShelterId int foreign key references Shelters(ShelterID)

update PETS set ShelterId=101 where PetID=1;
update PETS set ShelterId=101 where PetID=2;
update PETS set ShelterId=102 where PetID=3;
update PETS set ShelterId=103 where PetID=4;
update PETS set ShelterId=103 where PetID=5;

SELECT P.Name AS PetName, P.Breed, P.Type, S.Name AS ShelterName
FROM Pets P
JOIN Shelters S ON P.ShelterId = S.ShelterId
WHERE P.AvailableForAdoption = 1;

--13. Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai

SELECT COUNT(P.ParticipantID) AS TotalParticipants
FROM Participants P
JOIN AdoptionEvents E ON P.EventID = E.EventID
JOIN Shelters S ON P.ShelterId = S.ShelterId
WHERE S.Location = 'Chennai';

--13. Find the total number of participants in events organized by shelters located in specific city.
--Example: City=Chennai
SELECT * FROM AdoptionEvents

DECLARE @EventCity VARCHAR(100)
SET @EventCity = 'Central Park'

SELECT COUNT(*) AS No_participants,p.ParticipantName,p.ParticipantType,ae.EventName,ae.Location 
FROM Participants p 
JOIN AdoptionEvents ae ON p.EventID = ae.EventID 
WHERE ae.location = @EventCity 
GROUP BY p.ParticipantName,p.ParticipantType,ae.EventName,ae.Location


--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;

--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.

SELECT * FROM PETS

SELECT NAME
FROM Pets
WHERE AvailableForAdoption =1;


--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
CREATE TABLE users (
    userid INT PRIMARY KEY IDENTITY(10,20),
    username VARCHAR(50) NOT NULL,
    petid INT FOREIGN KEY REFERENCES pets(petid));

INSERT INTO users (username, petid)
VALUES
    ('ravi', 4),  
    ('haritha', 1), 
    ('kishan', 5),
    ('Emma', 7), 
    ('Siya', 2);


SELECT P.Name AS PetName,p.breed,p.type,U.userName AS AdopterName
FROM pets p 
JOIN Users U ON u.PetID = P.PetID
where p.availableforadoption=1


--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.

SELECT S.Name AS ShelterName, COUNT(P.PetID) AS AvailablePetsCount
FROM Shelters S
LEFT JOIN Pets P ON S.ShelterID = P.ShelterID AND P.AvailableForAdoption = 1
GROUP BY S.Name;


--18. Find pairs of pets from the same shelter that have the same breed.
INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption,OwnerID,shelterid)
VALUES
(6, 'Matty',3 , 'Campbell Dwarf', 'Hamster', 1,6,103),
(7, 'holly', 2, 'pomerian', 'Dog',0,7,102);

select * from pets
SELECT P1.Name AS Pet1Name, P2.Name AS Pet2Name, P1.Breed ,P1.Shelterid
FROM Pets P1
JOIN Pets P2 ON P1.ShelterID = P2.ShelterID AND P1.PetID < P2.PetID
WHERE P1.Breed = P2.Breed;

--19. List all possible combinations of shelters and adoption events.

select S.ShelterID, E.EventID
FROM Shelters S, AdoptionEvents E;


--20. Determine the shelter that has the highest number of adopted petsSELECT TOP 1 ShelterID, Name AS ShelterName, COUNT(*) AS AdoptedPetsCount
FROM Pets
WHERE AvailableForAdoption = 0
GROUP BY ShelterID, Name
ORDER BY COUNT(*) DESC;
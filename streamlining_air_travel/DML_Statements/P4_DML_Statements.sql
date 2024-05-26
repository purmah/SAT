use FlightBookingSystem
GO





INSERT INTO Airport (Airport_Code, AirportName, AirportCity, AirportCountry) 
VALUES
(13, 'Cairo International Airport', 'Cairo', 'Egypt'),
(14, 'Indira Gandhi International Airport', 'New Delhi', 'India'),
(15, 'Suvarnabhumi Airport', 'Bangkok', 'Thailand'),
(16, 'Ataturk International Airport', 'Istanbul', 'Turkey'),
(17, 'Incheon International Airport', 'Seoul', 'South Korea'),
(18, 'Adolfo Suárez Madrid–Barajas Airport', 'Madrid', 'Spain'),
(19, 'São Paulo–Guarulhos International Airport', 'São Paulo', 'Brazil'),
(20, 'Toronto Pearson International Airport', 'Toronto', 'Canada'),
(21, 'Kuala Lumpur International Airport', 'Kuala Lumpur', 'Malaysia'),
(22, 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia');
GO

-- Insert more airports
INSERT INTO Airport (Airport_Code, AirportName, AirportCity, AirportCountry) 
VALUES
(23, 'Heathrow Airport', 'London', 'United Kingdom'),
(24, 'Los Angeles International Airport', 'Los Angeles', 'United States'),
(25, 'Charles de Gaulle Airport', 'Paris', 'France'),
(26, 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
(27, 'Haneda Airport', 'Tokyo', 'Japan');

INSERT INTO Airport (Airport_Code, AirportName, AirportCity, AirportCountry) 
VALUES
(28, 'Frankfurt Airport', 'Frankfurt', 'Germany'),
(29, 'Beijing Capital International Airport', 'Beijing', 'China'),
(30, 'Sydney Airport', 'Sydney', 'Australia'),
(31, 'Johannesburg OR Tambo International Airport', 'Johannesburg', 'South Africa'),
(32, 'Singapore Changi Airport', 'Singapore', 'Singapore'),
(33, 'Rome Fiumicino Airport', 'Rome', 'Italy'),
(34, 'Hong Kong International Airport', 'Hong Kong', 'Hong Kong'),
(35, 'Istanbul Airport', 'Istanbul', 'Turkey'),
(36, 'Zurich Airport', 'Zurich', 'Switzerland'),
(37, 'Denver International Airport', 'Denver', 'United States');




INSERT INTO Passenger (Passenger_ID, FirstName, LastName, Email, PhoneNumber, Address, Gender, DateOfBirth, City, State, Zipcode, Country) VALUES
(13, 'Emily', 'Brown', 'emily.brown@example.com', '(555) 123-4567', '123 Bay Street', 'F', '1988-08-08', 'Vancouver', 'British Columbia', 90001, 'Canada'),
(14, 'James', 'Wilson', 'james.wilson@example.com', '(555) 234-5678', '234 Lake Ave', 'M', '1989-09-09', 'Toronto', 'Ontario', 10002, 'Canada'),
(15, 'Isabella', 'Garcia', 'isabella.garcia@example.com', '(555) 345-6789', '345 River Road', 'F', '1990-10-10', 'Montreal', 'Quebec', 20003, 'Canada'),
(16, 'Michael', 'Martinez', 'michael.martinez@example.com', '(555) 456-7890', '456 Pine Street', 'M', '1991-11-11', 'Calgary', 'Alberta', 30004, 'Canada'),
(17, 'Sophia', 'Anderson', 'sophia.anderson@example.com', '(555) 567-8901', '567 Oak Street', 'F', '1992-12-12', 'Ottawa', 'Ontario', 40005, 'Canada'),
(18, 'Daniel', 'Thomas', 'daniel.thomas@example.com', '(555) 678-9012', '678 Maple Street', 'M', '1993-01-13', 'Edmonton', 'Alberta', 50006, 'Canada'),
(19, 'Olivia', 'Jackson', 'olivia.jackson@example.com', '(555) 789-0123', '789 Birch Street', 'F', '1994-02-14', 'Winnipeg', 'Manitoba', 60007, 'Canada'),
(20, 'David', 'Lee', 'david.lee@example.com', '(555) 890-1234', '890 Cedar Ave', 'M', '1995-03-15', 'Halifax', 'Nova Scotia', 70008, 'Canada'),
(21, 'Mia', 'Harris', 'mia.harris@example.com', '(555) 901-2345', '901 Spruce Street', 'F', '1996-04-16', 'Regina', 'Saskatchewan', 80009, 'Canada'),
(22, 'Ethan', 'Clark', 'ethan.clark@example.com', '(555) 012-3456', '012 Elm Street', 'M', '1997-05-17', 'Fredericton', 'New Brunswick', 90010, 'Canada');
GO



INSERT INTO Passenger (Passenger_ID, FirstName, LastName, Email, PhoneNumber, Address, Gender, DateOfBirth, City, State, Zipcode, Country) VALUES
(23, 'Emma', 'Johnson', 'emma.johnson@example.com', '(555) 123-4567', '123 Elm Street', 'F', '1987-07-07', 'London', 'England', '98765', 'United Kingdom'),
(24, 'Noah', 'Brown', 'noah.brown@example.com', '(555) 234-5678', '234 Oak Ave', 'M', '1986-06-06', 'Los Angeles', 'California', '90001', 'United States'),
(25, 'Liam', 'Lee', 'liam.lee@example.com', '(555) 345-6789', '345 Pine Road', 'M', '1985-05-05', 'Paris', 'llaede', '75001', 'France'),
(26, 'Ava', 'Martinez', 'ava.martinez@example.com', '(555) 456-7890', '456 Maple Blvd', 'F', '1984-04-04', 'Dubai', 'Ajman', '89765', 'United Arab Emirates'),
(27, 'Oliver', 'Garcia', 'oliver.garcia@example.com', '(555) 567-8901', '567 Cedar Lane', 'M', '1983-03-03', 'Ginza','Tokyo', '98254', 'Japan');


INSERT INTO Flight ( Flight_Id,Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 1,13, 15, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International'),
( 2,14, 17, '2024-05-02 12:00:00', '2024-05-02 07:00:00', 'International'),
( 3,15,13, '2024-05-03 10:00:00', '2024-05-03 06:00:00', 'International'),
( 4,16, 14, '2024-05-04 09:00:00', '2024-05-04 05:00:00', 'International'),
( 5,17, 16, '2024-05-05 15:00:00', '2024-05-05 11:00:00', 'International');
GO


INSERT INTO Flight (Flight_Id, Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 6,16, 19, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International')


INSERT INTO Flight ( Flight_Id,Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 7,13, 15, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International'),
( 8,14, 17, '2024-05-01 12:00:00', '2024-05-01 07:00:00', 'International'),
( 9,15,13, '2024-05-01 10:00:00', '2024-05-01 06:00:00', 'International'),
( 10,16, 14, '2024-05-01 09:00:00', '2024-05-01 05:00:00', 'International'),
( 11,17, 16, '2024-05-01 15:00:00', '2024-05-01 11:00:00', 'International');
GO

INSERT INTO Flight ( Flight_Id,Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 12,13, 17, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International'),
( 13,15, 17, '2024-05-01 12:00:00', '2024-05-01 07:00:00', 'International'),
( 14,13,16, '2024-05-01 10:00:00', '2024-05-01 06:00:00', 'International'),
( 15,14, 15, '2024-05-01 09:00:00', '2024-05-01 05:00:00', 'International'),
( 16,16, 17, '2024-05-01 15:00:00', '2024-05-01 11:00:00', 'International');

INSERT INTO Flight ( Flight_Id,Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 17,14, 17, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International'),
( 18,14, 17, '2024-05-01 12:00:00', '2024-05-01 07:00:00', 'International'),
( 19,14,17, '2024-05-01 10:00:00', '2024-05-01 06:00:00', 'International'),
( 20,14, 17, '2024-05-01 09:00:00', '2024-05-01 05:00:00', 'International'),
( 21,14, 17, '2024-05-01 15:00:00', '2024-05-01 11:00:00', 'International');

INSERT INTO Flight (Flight_Id, Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 22,14 ,17, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International')

INSERT INTO Flight (Flight_Id, Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 23,14 ,17, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International')



INSERT INTO Flight (Flight_Id, Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 25,14 ,17, '2024-05-01 12:00:00', '2024-05-01 08:00:00', 'International')

INSERT INTO Flight ( Flight_Id,Arrival_Airport_Code, Departure_Airport_Code, Arrival_Time, Departure_Time, TypeOfFlight) VALUES
( 26,20, 23, '2024-05-06 18:00:00', '2024-05-06 14:00:00', 'Domestic'),
( 27,24, 25, '2024-05-07 14:00:00', '2024-05-07 10:00:00', 'Domestic'),
( 28,26, 27, '2024-05-08 16:00:00', '2024-05-08 12:00:00', 'Domestic'),
( 29,13, 25, '2024-05-09 20:00:00', '2024-05-09 16:00:00', 'Domestic'),
( 30,14, 26, '2024-05-10 22:00:00', '2024-05-10 18:00:00', 'Domestic'),
(31, 22, 28, '2024-05-11 10:00:00', '2024-05-11 06:00:00', 'International'),
(32, 23, 29, '2024-05-12 12:00:00', '2024-05-12 08:00:00', 'International'),
(33, 24, 30, '2024-05-13 14:00:00', '2024-05-13 10:00:00', 'International'),
(34, 25, 31, '2024-05-14 16:00:00', '2024-05-14 12:00:00', 'International'),
(35, 26, 32, '2024-05-15 18:00:00', '2024-05-15 14:00:00', 'International'),
(36, 27, 33, '2024-05-16 20:00:00', '2024-05-16 16:00:00', 'International'),
(37, 28, 34, '2024-05-17 22:00:00', '2024-05-17 18:00:00', 'International'),
(38, 29, 35, '2024-05-18 12:00:00', '2024-05-18 08:00:00', 'International'),
(39, 30, 36, '2024-05-19 14:00:00', '2024-05-19 10:00:00', 'International'),
(40, 31, 37, '2024-05-20 16:00:00', '2024-05-20 12:00:00', 'International');

GO



UPDATE Flight
SET Arrival_Time = DATEADD(MINUTE, RAND() * 720, Arrival_Time), -- Adding a random time difference of up to 12 hours (720 minutes)
    Departure_Time = DATEADD(MINUTE, RAND() * 720, Departure_Time) -- Adding a random time difference of up to 12 hours (720 minutes)
WHERE TypeOfFlight = 'International';


INSERT INTO Travel_Class (Class_ID, ClassName, ClassCapacity) VALUES
(1, 'Economy', 150),
(2, 'Business', 50),
(3, 'First Class', 20),
(4, 'Premium Economy', 70),
(5, 'Economy Plus', 100),
(6, 'Business Suite', 30),
(7, 'First Class Suite', 10),
(8, 'Premium Business', 40),
(9, 'Economy Premium', 120),
(10, 'Ultra Economy', 200);
GO





INSERT INTO Seat( Flight_Id, Class_ID) VALUES
( 1, 1),
( 1, 1),
( 2, 1),
( 2, 2),
( 3, 1),
( 3, 2),
( 4, 1),
( 4, 2),
( 5, 1),
( 5, 2);
GO

 

INSERT INTO Reservation ( Passenger_ID, Seat_ID) VALUES
( 13, 1),
( 14, 2),
( 15, 3),
( 16, 4),
( 17, 5),
( 18,6),
( 19, 7),
( 20, 8),
( 21, 9),
( 22, 10);

  

INSERT INTO Reservation ( Passenger_ID, Seat_ID) VALUES
( 19, 7);



INSERT INTO PaymentStatus ( Reservation_ID, Amount, Transaction_Date, PaymentStatus) VALUES
(1, 500.00, '2024-04-01', 'Completed'),
( 2, 750.00, '2024-04-02', 'Pending'),
( 3, 600.00, '2024-04-03', 'Completed'),
( 4, 1200.00, '2024-04-04', 'Refunded'),
( 5, 800.00, '2024-04-05', 'Completed'),
( 6, 700.00, '2024-04-06', 'Pending'),
(7, 550.00, '2024-04-07', 'Completed'),
(8, 650.00, '2024-04-08', 'Refunded'),
( 9, 900.00, '2024-04-09', 'Completed'),
( 10, 1000.00, '2024-04-10', 'Pending');



INSERT INTO Flight_Cost (Seat_ID, ValidFromDate, Cost, ValidToDate) VALUES
(1, '2024-04-01', 300.00, '2024-04-03'),
(2, '2024-04-02', 350.00, '2024-04-04'),
(3, '2024-04-03', 200.00, '2024-04-05'),
(4, '2024-04-04', 400.00, '2024-04-06'),
(5, '2024-04-05', 250.00, '2024-04-08'),
(6, '2024-04-06', 450.00, '2024-04-10'),
(7, '2024-04-07', 300.00, '2024-04-12'),
(8, '2024-04-08', 500.00, '2024-04-14'),
(9, '2024-04-09', 550.00, '2024-04-11'),
(10, '2024-04-10', 600.00, '2024-04-15');

 

INSERT INTO Flight_Service (Service_ID, Service_Name) VALUES
(1, 'WiFi'),
(2, 'Extra Legroom'),
(3, 'Priority Boarding'),
(4, 'Additional Luggage'),
(5, 'Meal Service'),
(6, 'Seat Selection'),
(7, 'Entertainment'),
(8, 'Fast Track Security'),
(9, 'Lounge'),
(10, 'Sleep Kit');

 

INSERT INTO Service_Offering (Service_ID, Class_ID, Start_Date, End_Date, Offered) VALUES
(1, 1, '2024-04-01', '2024-04-30', 'Y'),
(2, 2, '2024-04-01', '2024-04-30', 'Y'),
(3, 3, '2024-04-01', '2024-04-30', 'Y'),
(4, 4, '2024-04-01', '2024-04-30', 'Y'),
(5, 5, '2024-04-01', '2024-04-30', 'Y'),
(6, 6, '2024-04-01', '2024-04-30', 'Y'),
(7, 7, '2024-04-01', '2024-04-30', 'Y'),
(8, 8, '2024-04-01', '2024-04-30', 'Y'),
(9, 9, '2024-04-01', '2024-04-30', 'Y'),
(10, 10, '2024-04-01', '2024-04-30', 'Y');
GO


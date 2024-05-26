create database FlightBookingSystem;
GO

Use FlightBookingSystem
GO

CREATE TABLE Airport (
    Airport_Code INT PRIMARY KEY not null, 
    AirportName VARCHAR(50),
    AirportCity VARCHAR(50),
    AirportCountry VARCHAR(50)
);

CREATE TABLE Passenger (
    Passenger_ID INT PRIMARY KEY not null ,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255),
    Gender CHAR(1),
    DateOfBirth Date,
    City Varchar(100),
    State Varchar(100),
    Zipcode INT,
    Country VARCHAR(100),
    CONSTRAINT CHK_EmailFormat CHECK (Email LIKE '[a-z,0-9,_,-]%@[a-z]%.[a-z][a-z]%'),
    -- Constraint to ensure valid Gender values
    CONSTRAINT CHK_ValidGender CHECK (Gender IN ('M', 'F', 'O')),
    -- Constraint to ensure PhoneNumber follows US format (10 digits)
    CONSTRAINT CHK_ValidPhoneNumber CHECK (PhoneNumber LIKE '(___) ___-____'),
    -- Constraint to ensure Zipcode is valid according to US standards
    CONSTRAINT CHK_ValidZipcode CHECK (LEN(Zipcode) = 5 AND Zipcode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
    -- Constraint to ensure Zipcode is positive
    CONSTRAINT CHK_PositiveZipcode CHECK (CONVERT(INT, Zipcode) > 0)

);

CREATE TABLE Flight (
    Flight_Id INT PRIMARY KEY not null,
    Arrival_Airport_Code INT NOT NULL,
    Departure_Airport_Code INT NOT NULL,
    Arrival_Time DateTime ,
    Departure_Time DateTime,
    TypeOfFlight VARCHAR(25),
    
    FOREIGN KEY (Arrival_Airport_Code) REFERENCES Airport(Airport_Code),
    FOREIGN KEY (Departure_Airport_Code) REFERENCES Airport(Airport_Code),
     -- Constraint to ensure Arrival_Time is after Departure_Time
    CONSTRAINT CHK_ArrivalAfterDeparture CHECK (Arrival_Time > Departure_Time),
    -- Constraint to ensure Duration is non-negative
   
    CONSTRAINT CHK_DifferentAirports CHECK (Arrival_Airport_Code != Departure_Airport_Code),
    -- Constraint to ensure TypeOfFlight is one of the specified values
    CONSTRAINT CHK_ValidTypeOfFlight CHECK (TypeOfFlight IN ('Domestic', 'International'))

    
);

CREATE TABLE Travel_Class (
    Class_ID INT PRIMARY KEY not null,
    ClassName VARCHAR(50) NOT NULL,
    ClassCapacity INT ,
    CONSTRAINT UC_ClassName UNIQUE (ClassName),
    CONSTRAINT CHK_ValidClassName CHECK (ClassName IN ('Economy', 'Business', 'First Class', 'Premium Economy', 'Economy Plus','Business Suite','First Class Suite','Premium Business','Economy Premium','Ultra Economy'))
);

CREATE TABLE Seat (
    Seat_ID INT PRIMARY KEY IDENTITY(1,1) not null,
    Flight_Id INT Not null,
    Class_ID INT not null,
    FOREIGN KEY (Flight_Id) REFERENCES Flight(Flight_Id),
    FOREIGN KEY (Class_ID) REFERENCES Travel_Class(Class_ID),
);



CREATE TABLE Reservation (
    Reservation_ID INT PRIMARY KEY IDENTITY(1,1),
    Passenger_ID INT NOT Null ,
    Seat_ID INT NOT Null,
    Reservation_Details Date DEFAULT(getDate()),
    Reservation_Status VARCHAR(20),
        -- status VARCHAR(20),
    FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
    FOREIGN KEY (Seat_ID) REFERENCES Seat(Seat_ID)
);




CREATE TABLE PaymentStatus (
    Payment_ID INT PRIMARY KEY IDENTITY(1,1),
    Reservation_ID INT NOT NULL,
    Amount DECIMAL(16, 2),
    Transaction_Date DATE ,
    PaymentStatus Varchar(25),
    CONSTRAINT ReservationID FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID),
    CONSTRAINT CHK_ValidPaymentStatus CHECK (PaymentStatus IN ('Completed', 'Pending','Refunded'))
);

DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2024-12-31';

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Calendar')
BEGIN
    CREATE TABLE Calendar (
        Date DATE PRIMARY KEY,
        Business_Day_YN CHAR(1) NOT NULL DEFAULT 'N' -- Default to 'N' (non-business day)
    );
END;

-- Loop through each day from start date to end date
WHILE @StartDate <= @EndDate
BEGIN
    -- Insert the current date into the Calendar table and mark it as a business day ('Y')
    INSERT INTO Calendar (Date, Business_Day_YN)
    VALUES (@StartDate, 'Y');
    
    -- Increment the start date by one day
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

CREATE TABLE Flight_Cost (
    
    Seat_ID INT NOT NULL,
    ValidFromDate DATE NOT NULL,
    Cost DECIMAL(10, 2),
    ValidToDate DATE NOT NULL,
    CONSTRAINT Flight_Cost_PK PRIMARY KEY (Seat_ID,ValidFromDate),
    CONSTRAINT FK_SeatID FOREIGN KEY (Seat_ID) REFERENCES Seat(Seat_ID),
    CONSTRAINT FK_ValidFromDate FOREIGN KEY (ValidFromDate) REFERENCES Calendar(Date),
    CONSTRAINT FK_ValidToDate FOREIGN KEY (ValidToDate) REFERENCES Calendar(Date)
);

CREATE TABLE Flight_Service (
    Service_ID INT PRIMARY KEY not null,
    Service_Name VARCHAR(100) CONSTRAINT Service_chk CHECK(Service_Name in ('Meal Service','Wifi','Entertainment','Lounge','Drinks','Extra Legroom','Priority Boarding','Additional Luggage','Seat Selection','Fast Track Security','Sleep Kit'))
);


CREATE TABLE Service_Offering (
    
    Service_ID INT NOT NULL,
    Class_ID INT NOT NULL,
    Start_Date DATE,
    End_Date DATE,
     Offered CHAR(1) Constraint check_character_Offered_YN Check(Offered In ('Y','N')),
    FOREIGN KEY (Service_ID) REFERENCES Flight_Service(Service_ID),
    FOREIGN KEY (Class_ID) REFERENCES Travel_Class(Class_ID),
     CONSTRAINT Service_Offering_PK PRIMARY KEY (Class_ID,Service_ID)
);

CREATE TABLE FlightChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    Flight_Id INT,
    ChangeDate DATETIME,
    PreviousArrival DATETIME,
    NewArrival DATETIME,
    FOREIGN KEY (Flight_Id) REFERENCES Flight(Flight_Id)
);
go 

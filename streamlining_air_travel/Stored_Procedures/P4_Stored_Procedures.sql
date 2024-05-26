use FlightBookingSystem;
GO


CREATE PROCEDURE Flight_Availability
    @Departure_Date DATE,
    @Arrival_Date DATE,
    @Available CHAR(1) OUTPUT,
    @Message VARCHAR(100) OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT Flight_Id
        FROM Flight
        WHERE CONVERT(DATE, Departure_Time) = @Departure_Date
        AND CONVERT(DATE, Arrival_Time) = @Arrival_Date 
    )
    BEGIN
        SET @Available = 'Y';    
        SET @Message = 'Flight details are available for the specified dates.';
        SELECT * FROM Flight
        WHERE CONVERT(DATE, Departure_Time) = @Departure_Date
        AND CONVERT(DATE, Arrival_Time) = @Arrival_Date;
    END
    ELSE
    BEGIN
        SET @Available = 'N';
        SET @Message = 'Flight details do not exist for the specified dates.';
    END
END;
go

DECLARE @Available CHAR(1);
DECLARE @Message VARCHAR(100);


EXEC Flight_Availability 
    @Departure_Date = '2024-05-01', 
    @Arrival_Date = '2024-05-01',
    @Available = @Available OUTPUT,
    @Message = @Message OUTPUT;


SELECT @Available AS Available, @Message AS Message;
GO



-- ++++++++++++++++++++++++++++++++++++++++++


CREATE PROCEDURE GetFlightDetailsByLocation
    @DepartureAirportCode INT,
    @ArrivalAirportCode INT,
    @Message NVARCHAR(100) OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Flight
        WHERE Departure_Airport_Code = @DepartureAirportCode 
        AND Arrival_Airport_Code = @ArrivalAirportCode
    )
    BEGIN
        SELECT 
            F.Flight_ID,
            F.Departure_Airport_Code,
            DA.AirportName AS Departure_Airport_Name,
            F.Arrival_Airport_Code,
            AA.AirportName AS Arrival_Airport_Name,
            F.Departure_Time,
            F.Arrival_Time,
            F.TypeOfFlight
        FROM 
            Flight AS F
        JOIN 
            Airport AS DA ON F.Departure_Airport_Code = DA.Airport_Code
        JOIN 
            Airport AS AA ON F.Arrival_Airport_Code = AA.Airport_Code
        WHERE 
            F.Departure_Airport_Code = @DepartureAirportCode
            AND F.Arrival_Airport_Code = @ArrivalAirportCode;
        
        SET @Message = 'Flight details retrieved successfully.';
    END
    ELSE
    BEGIN
        SET @Message = 'No flights found for the specified locations.';
    END
END;





DECLARE @Message NVARCHAR(100);

EXEC GetFlightDetailsByLocation
    @DepartureAirportCode = 17,
    @ArrivalAirportCode = 14,
    @Message = @Message OUTPUT;

SELECT @Message AS Message;
Go


-- =====================================

CREATE PROCEDURE UpdateFlightDetails
    @Flag BIT OUTPUT, -- Return 0 for fail, 1 for success
    @FlightID INT,
    @DeptDateTime DATETIME,
    @ArrivalDateTime DATETIME,
    @AirplaneType VARCHAR(100)
AS
BEGIN
    -- Check if FlightID exists
    IF NOT EXISTS (SELECT 1 FROM Flight WHERE Flight_Id = @FlightID)
    BEGIN
        SET @Flag = 0;
        SELECT 'Flight ID does not exist.' AS ErrorMessage;
        RETURN;
    END;

    -- Check if Departure Time is not after Arrival Time
    IF @DeptDateTime >= @ArrivalDateTime
    BEGIN
        SET @Flag = 0;
        SELECT 'Departure time cannot be equal to or after Arrival time.' AS ErrorMessage;
        RETURN;
    END;

    -- Update the flight details
    BEGIN TRY
        UPDATE Flight
        SET Departure_Time = @DeptDateTime,
            Arrival_Time = @ArrivalDateTime,
            TypeOfFlight = @AirplaneType
        WHERE Flight_Id = @FlightID;

        SET @Flag = 1;
        SELECT 'Flight details updated successfully.' AS SuccessMessage;
    END TRY
    BEGIN CATCH
        SET @Flag = 0;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;



DECLARE @flag BIT;

EXEC UpdateFlightDetails
    @flag = @flag OUTPUT,
    @FlightID = 1,  -- Provide the FlightID value
    @DeptDateTime = '2024-04-01 08:00:00', -- Provide the Departure Date and Time
    @ArrivalDateTime = '2024-04-01 12:00:00', -- Provide the Arrival Date and Time
    @AirplaneType = 'International'; -- Provide the Airplane Type

SELECT @flag AS 'Result';



-- ============================================
GO
CREATE PROCEDURE BookFlightForPassenger
    @PassengerID INT,
    @DepartureAirportCode INT,
    @ArrivalAirportCode INT,
    @ClassID INT,
    @ReservationID INT OUTPUT,
    @Message NVARCHAR(100) OUTPUT
AS
BEGIN
    DECLARE @FlightID INT;
    DECLARE @Cost DECIMAL(10, 2);

    -- Check if the passenger exists
    IF NOT EXISTS (SELECT 1 FROM Passenger WHERE Passenger_ID = @PassengerID)
    BEGIN
        SET @Message = 'Passenger not found. Please register before booking a flight.';
        RETURN;
    END;

    -- Check if the departure airport exists
    IF NOT EXISTS (SELECT 1 FROM Airport WHERE Airport_Code = @DepartureAirportCode)
    BEGIN
        SET @Message = 'Departure airport does not exist.';
        RETURN;
    END;

    -- Check if the arrival airport exists
    IF NOT EXISTS (SELECT 1 FROM Airport WHERE Airport_Code = @ArrivalAirportCode)
    BEGIN
        SET @Message = 'Arrival airport does not exist.';
        RETURN;
    END;

    -- Check if the class exists
    IF NOT EXISTS (SELECT 1 FROM Travel_Class WHERE Class_ID = @ClassID)
    BEGIN
        SET @Message = 'Travel class does not exist.';
        RETURN;
    END;

    -- Get the flight ID based on the departure and arrival airport codes
    SELECT @FlightID = Flight_ID
    FROM Flight
    WHERE Departure_Airport_Code = @DepartureAirportCode
    AND Arrival_Airport_Code = @ArrivalAirportCode;

    -- Check if a valid flight is found
    IF @FlightID IS NULL
    BEGIN
        SET @Message = 'No flight available for the specified route.';
        RETURN;
    END;

    -- Calculate the cost based on the flight and class
    SELECT @Cost = Cost
    FROM Flight_Cost
    WHERE Seat_ID IN (SELECT Seat_ID FROM Seat WHERE Flight_ID = @FlightID AND Class_ID = @ClassID);

    -- Book the flight for the passenger
    INSERT INTO Reservation ( Passenger_ID, Seat_ID)
    VALUES ( @PassengerID, (SELECT TOP 1 Seat_ID FROM Seat WHERE Flight_ID = @FlightID AND Class_ID = @ClassID));

    -- Output the success message with the cost
    SET @Message = 'Flight booked successfully. Cost: $' + CONVERT(NVARCHAR(50), @Cost);
    SET @ReservationID = SCOPE_IDENTITY(); -- Retrieve the generated Reservation_ID
END;
GO




DECLARE @Message NVARCHAR(100);
DECLARE @ReservationID INT;  -- Declare the output parameter
EXEC BookFlightForPassenger 
     @PassengerID = 20,  -- Example passenger ID
     @DepartureAirportCode = 26,  -- Example departure airport code
     @ArrivalAirportCode = 14,    -- Example arrival airport code
     @ClassID = 1,                -- Example class ID
     @ReservationID = @ReservationID OUTPUT,  -- Pass the output parameter
     @Message = @Message OUTPUT;  -- Pass the output parameter

-- Display the result message and reservation ID
Select @Message as Result;
PRINT 'Reservation ID: ' + CAST(@ReservationID AS NVARCHAR(10));


-- +++++++++++++++++++++++++++++++++++++++++++++
GO


CREATE PROCEDURE GetFlightDetailsForPassenger
    @PassengerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the passenger exists
    IF NOT EXISTS (SELECT 1 FROM Passenger WHERE Passenger_ID = @PassengerID)
    BEGIN
        PRINT 'Passenger does not exist.';
        RETURN;
    END;

    -- Retrieve flight details for the passenger
    SELECT 
        R.Reservation_ID,
        F.Flight_ID,
        F.Departure_Airport_Code AS DepartureAirportCode,
        DA.AirportName AS DepartureAirportName,
        F.Arrival_Airport_Code AS ArrivalAirportCode,
        AA.AirportName AS ArrivalAirportName,
        F.Departure_Time,
        F.Arrival_Time,
        dbo.CalculateDuration(F.Departure_Time, F.Arrival_Time) AS FlightDuration,
        TC.ClassName AS TravelClass
    FROM 
        Reservation AS R
    INNER JOIN 
        Seat AS S ON R.Seat_ID = S.Seat_ID
    INNER JOIN 
        Flight AS F ON S.Flight_ID = F.Flight_ID
    INNER JOIN 
        Airport AS DA ON F.Departure_Airport_Code = DA.Airport_Code
    INNER JOIN 
        Airport AS AA ON F.Arrival_Airport_Code = AA.Airport_Code
    INNER JOIN 
        Travel_Class AS TC ON S.Class_ID = TC.Class_ID
    WHERE 
        R.Passenger_ID = @PassengerID;
END;

EXEC GetFlightDetailsForPassenger @PassengerID = 20
GO

-- =====================================


GO
CREATE PROCEDURE PassengerCRUD 
    @Action VARCHAR(10), 
    @Passenger_ID INT = NULL, 
    @FName VARCHAR(100) = NULL, 
    @LName VARCHAR(100) = NULL, 
    @Email VARCHAR(100) = NULL,
    @PNumber Varchar(20) = NULL, 
    @Address VARCHAR(100) = NULL,
    @City VARCHAR(100) = NULL,  
    @State VARCHAR(100) = NULL, 
    @Zipcode VARCHAR(100) = NULL, 
    @Country VARCHAR(100) = NULL,
    @Gender CHAR(1) = NULL,
    @DateOfBirth DATE = NULL,
    @Message VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    --SELECT
    IF @Action = 'SELECT'
    BEGIN
        SELECT Passenger_ID, FirstName, LastName, Email, PhoneNumber, Address, City,
            State,Zipcode,Country, Gender, DateOfBirth
        FROM dbo.Passenger;
        SET @Message = 'Passenger details retrieved successfully.';
    END

    --INSERT
    IF @Action = 'INSERT'
    BEGIN
        -- Check if Passenger_ID is provided
        IF @Passenger_ID IS NULL
        BEGIN
            SET @Message = 'Passenger_ID is required for INSERT operation.';
            RETURN;
        END

        -- Check if Passenger_ID already exists
        IF EXISTS (SELECT 1 FROM dbo.Passenger WHERE Passenger_ID = @Passenger_ID)
        BEGIN
            SET @Message = 'Passenger with provided Passenger_ID already exists.';
            RETURN;
        END

        INSERT INTO dbo.Passenger (
            Passenger_ID, FirstName, LastName, Email, PhoneNumber, Address, City,
            State,Zipcode,Country, Gender, DateOfBirth
        )
        VALUES (
            @Passenger_ID, @FName, @LName, @Email, @PNumber, @Address, @City,
            @State, @Zipcode, @Country, @Gender, @DateOfBirth
        );
        SET @Message = 'Passenger inserted successfully.';
    END

    --UPDATE
    IF @Action = 'UPDATE'
    BEGIN
        -- Check if Passenger_ID is provided
        IF @Passenger_ID IS NULL
        BEGIN
            SET @Message = 'Passenger_ID is required for UPDATE operation.';
            RETURN;
        END

        -- Check if Passenger_ID exists
        IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE Passenger_ID = @Passenger_ID)
        BEGIN
            SET @Message = 'Passenger with provided Passenger_ID does not exist.';
            RETURN;
        END

        UPDATE dbo.Passenger
        SET FirstName = @FName, LastName = @LName, Email = @Email, PhoneNumber = @PNumber, 
            Address = @Address, City = @City, State = @State, Zipcode =  @Zipcode,
            Country = @Country, Gender = @Gender, DateOfBirth = @DateOfBirth
        WHERE Passenger_ID = @Passenger_ID;
        SET @Message = 'Passenger updated successfully.';
    END

    --DELETE
    IF @Action = 'DELETE'
    BEGIN
        -- Check if Passenger_ID is provided
        IF @Passenger_ID IS NULL
        BEGIN
            SET @Message = 'Passenger_ID is required for DELETE operation.';
            RETURN;
        END

        -- Check if Passenger_ID exists
        IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE Passenger_ID = @Passenger_ID)
        BEGIN
            SET @Message = 'Passenger with provided Passenger_ID does not exist.';
            RETURN;
        END

        DELETE FROM dbo.Passenger WHERE Passenger_ID = @Passenger_ID;
        SET @Message = 'Passenger deleted successfully.';
    END
END


DECLARE @Message VARCHAR(255);
EXEC [dbo].[PassengerCRUD] 'INSERT', @Passenger_ID = 29, @FName = 'John', @LName = 'Doe', @Email = 'john@example.com', @PNumber = '(585) 123-4567', @Address = '123 Main St', @City = 'Anytown', @State = 'CA', @Zipcode = '12345', @Country = 'USA', @Gender = 'M', @DateOfBirth = '1990-01-01', @Message = @Message OUTPUT;
Select @Message as Result;



select * from Passenger;

DECLARE @Message VARCHAR(255);
DECLARE @Passenger_ID INT, @FName VARCHAR(100), @LName VARCHAR(100), @Email VARCHAR(100), @PNumber Varchar(20), @Address VARCHAR(100), @City VARCHAR(100), @State VARCHAR(100), @Zipcode VARCHAR(100), @Country VARCHAR(100), @Gender CHAR(1), @DateOfBirth DATE;

EXEC [dbo].[PassengerCRUD] 'SELECT', @Message = @Message OUTPUT;

Select @Message as Result;

DECLARE @Message VARCHAR(255);
EXEC [dbo].[PassengerCRUD] 'UPDATE', @Passenger_ID = 1, @FName = 'Jane', @LName = 'Smith', @Email = 'jane.smith@example.com', @PNumber = '(585) 123-4567', @Address = '456 Oak St', @City = 'Othertown', @State = 'NY', @Zipcode = '54321', @Country = 'USA', @Gender = 'F', @DateOfBirth = '1995-05-05', @Message = @Message OUTPUT;
Select @Message as Result;



DECLARE @Message VARCHAR(255);
EXEC [dbo].[PassengerCRUD] 'DELETE', @Passenger_ID = 1, @Message = @Message OUTPUT;
Select @Message as Result;
GO



-- ==========================

CREATE PROCEDURE UpdatePayment 
       @paymentID INT,
       @paid_date DATE OUTPUT,
       @Message VARCHAR(255) OUTPUT
AS
BEGIN
    -- Corrected multiple SET usage and properly update @paid_date within the UPDATE statement.
    UPDATE PaymentStatus
    SET PaymentStatus = 'Completed', 
        @paid_date = GETDATE() -- This sets the @paid_date to the current date/time.
    WHERE Payment_ID = @paymentID;

    SET @Message = 'Payment updated successfully.';
END

Go
DECLARE @paymentID INT = 1003; -- Specify the payment ID you want to update

DECLARE @paid_date DATE;
DECLARE @Message VARCHAR(255);

EXEC UpdatePayment 
       @paymentID = @paymentID,
       @paid_date = @paid_date OUTPUT,
       @Message = @Message OUTPUT;

SELECT @paid_date AS 'Paid Date', @Message AS 'Message';



GO


-- =================================

select * from Reservation
GO
CREATE PROCEDURE CancelReservation 
@Reservation_ID int,
@Message VARCHAR(225) OUTPUT
AS
DECLARE
@Reservation_st VARCHAR(25)
BEGIN 
    IF @Reservation_ID IS NULL
    BEGIN
    Set @Message = 'Reservation Id is required to Cancel Reservation'
    RETURN
    END
    ELSE 
    UPDATE Reservation
    SET Reservation_Status = 'Cancelled'
    where Reservation_ID = @Reservation_ID;
    Set @Message ='Reservation Cancelled Successfully.'

end;

Go 
DECLARE
@Reservation_ID int = 28,
@Message VARCHAR(225);

EXEC CancelReservation
     @Reservation_ID = @Reservation_ID,
     @Message = @Message OUTPUT;
Select @Message as Result;




-- =============================================
Go
CREATE PROCEDURE ConfirmReservation 
@Reservation_ID int,
@Message VARCHAR(225) OUTPUT
AS
DECLARE
@Reservation_st VARCHAR(25)
BEGIN 
    IF @Reservation_ID IS NULL
    BEGIN
    Set @Message = 'Reservation Id is required to Confirm Reservation'
    RETURN
    END
    ELSE 
    UPDATE Reservation
    SET Reservation_Status = 'Confirmed'
    where Reservation_ID = @Reservation_ID;
    Set @Message ='Reservation Confirmed Successfully.'

end;

Go 
DECLARE
@Reservation_ID int = 30,
@Message VARCHAR(225);

EXEC ConfirmReservation
     @Reservation_ID = @Reservation_ID,
     @Message = @Message OUTPUT;
Select @Message as Result;
GO



-- =============================================================

CREATE PROCEDURE CalculateTotalrevenue 
@Message VARCHAR(225) OUTPUT,
@TotalRevenue FLOAT OUTPUT
AS 
BEGIN
Declare @CompletedRevenue Float;

Select @CompletedRevenue =  SUM(Amount)
 from
 PaymentStatus 
 where PaymentStatus = 'Completed';

 Declare @IncompleteRevenue Float;
 Select @IncompleteRevenue =  SUM(Amount)
 from 
 PaymentStatus
 where PaymentStatus ='Refunded' or PaymentStatus ='Pending';

 SET @TotalRevenue = @CompletedRevenue - @IncompleteRevenue;

    -- Set the message with the total revenue
    SET @Message = 'Total Revenue Generated is ' + CAST(@TotalRevenue AS VARCHAR);
END;
go 

DECLARE 
@Message VARCHAR(225),
@TotalRevenue FLOAT;

EXEC CalculateTotalrevenue 
    @Message = @Message OUTPUT,
    @TotalRevenue = @TotalRevenue OUTPUT;

SELECT @TotalRevenue AS TotalRevenue, @Message AS Message;




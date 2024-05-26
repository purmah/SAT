use FlightBookingSystem;
GO


CREATE FUNCTION Cal_Cost (
    @Start_Date DATE,
    @Dep_Date DATE,
    @Travel_Class_ID INT,
    @Business_Day CHAR(3)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Diff INT
    DECLARE @Cost DECIMAL(10, 2)

    
    SET @Diff = DATEDIFF(DAY, @Start_Date, @Dep_Date)

   
    SET @Cost = 100.00

   
    SET @Cost = @Cost +
        CASE 
            WHEN @Business_Day = 'Yes' THEN 10.00
            ELSE 0
        END + 
        CASE 
            WHEN @Travel_Class_ID = 1 THEN 50.00
            WHEN @Travel_Class_ID = 2 THEN 60.00 -- Business class has a higher additional cost
            WHEN @Travel_Class_ID = 3 THEN 80.00 -- First class has an even higher additional cost
            WHEN @Travel_Class_ID = 4 THEN 40.00
            WHEN @Travel_Class_ID = 5 THEN 30.00
            WHEN @Travel_Class_ID = 6 THEN 70.00
            WHEN @Travel_Class_ID = 7 THEN 90.00
            WHEN @Travel_Class_ID = 8 THEN 55.00
            WHEN @Travel_Class_ID = 9 THEN 35.00
            WHEN @Travel_Class_ID = 10 THEN 25.00
            ELSE 10.00
        END + -- Additional cost based on travel class
        CASE 
            WHEN @Diff > 20 AND @Diff <= 30 THEN 0
            WHEN @Diff > 10 AND @Diff <= 20 THEN 20.00
            ELSE 50.00
        END -- Additional cost based on interval between start and departure dates

    RETURN @Cost;
END;
GO



DECLARE @Cost DECIMAL(10, 2);

SET @Cost = dbo.Cal_Cost('2024-04-01', '2024-04-05', 1, 'Y');

SELECT @Cost AS TotalCost;
GO

-- +++++++++++++++++++++++++++++++++++++++++++

CREATE FUNCTION dbo.CalculateDuration (@DepartureTime DATETIME, @ArrivalTime DATETIME)
RETURNS TIME
AS
BEGIN
    DECLARE @Duration TIME;

    -- Calculate duration
    SET @Duration = CONVERT(TIME, DATEADD(MINUTE, DATEDIFF(MINUTE, @DepartureTime, @ArrivalTime), 0));

    RETURN @Duration;
END;

GO


ALTER TABLE Flight
ADD FlightDuration AS dbo.CalculateDuration(Departure_Time, Arrival_Time);
Go


-- ++++++++++++++++++++++++++++++++++++++++++++
CREATE FUNCTION dbo.CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    -- Calculate age based on date of birth
    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());

    -- Adjust age if birthday has not yet occurred this year
    IF (MONTH(@DateOfBirth) > MONTH(GETDATE()) OR (MONTH(@DateOfBirth) = MONTH(GETDATE()) AND DAY(@DateOfBirth) > DAY(GETDATE())))
        SET @Age = @Age - 1;

    RETURN @Age;
END;
GO



ALTER TABLE Passenger
ADD Age AS dbo.CalculateAge(DateOfBirth);







-- =======================================

CREATE FUNCTION dbo.CheckEmailValidity (@Email VARCHAR(255))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT
    SET @IsValid = CASE 
                     WHEN @Email LIKE '%@%.%' 
                          AND CHARINDEX(' ', @Email) = 0 -- No spaces
                          AND CHARINDEX('..', @Email) = 0 -- No consecutive dots
                          AND LEFT(@Email, 1) != '@' -- Doesn't start with '@'
                          AND RIGHT(@Email, 1) != '.' -- Doesn't end with '.'
                          AND @Email NOT LIKE '%@%@%' -- Contains only one '@'
                      THEN 1
                      ELSE 0
                   END

    RETURN @IsValid
END


GO

SELECT 
    Passenger_ID, 
    Email, 

    dbo.CheckEmailValidity(Email) AS IsValidEmail
FROM 
    Passenger
    where Passenger_ID = 20;
Go



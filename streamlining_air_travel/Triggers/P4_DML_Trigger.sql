use FlightBookingSystem;
GO

CREATE TRIGGER InsertSeatsOnFlightInsert
ON Flight
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert 20 seats for each new flight
    INSERT INTO Seat (Flight_ID, Class_ID)
    SELECT 
        i.Flight_ID,
        CASE 
            WHEN (SeatNumber BETWEEN 1 AND 5) THEN 1 -- Class ID for the first 5 seats
            WHEN (SeatNumber BETWEEN 6 AND 10) THEN 2 -- Class ID for the next 5 seats
            WHEN (SeatNumber BETWEEN 11 AND 15) THEN 3 -- Class ID for the next 5 seats
            ELSE 4 -- Class ID for the last 5 seats
        END AS Class_ID
    FROM 
        inserted i
    CROSS APPLY (
        SELECT TOP 20 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SeatNumber
        FROM sys.objects
    ) AS SeatNumbers
    ORDER BY i.Flight_ID;
END;



-- ============================================
GO

CREATE TRIGGER Insert_Payment 
ON Reservation
FOR INSERT
AS
BEGIN
   DECLARE @Reservation_ID int, @Reservation_date DATE, @transaction_date DATE, @Cost DECIMAL(10, 2), @seat int
   SELECT @Reservation_ID = Reservation_ID From inserted 
   SELECT @transaction_date=Reservation_Details FROM inserted

   SELECT @seat= Seat_ID 
   FROM Reservation 
   WHERE Reservation_ID=@Reservation_ID

   SELECT @Cost=Cost 
   FROM Flight_Cost 
   WHERE Seat_ID=@seat

   SELECT @Reservation_date=DATEADD(DAY,1,@Reservation_date)
   INSERT INTO PaymentStatus ( Reservation_ID, Transaction_Date,Amount, PaymentStatus)
   VALUES (@Reservation_ID,@transaction_date,@Cost,'Pending');

END
GO
-- ====================================

CREATE TRIGGER Set_Cost
ON dbo.Seat
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert the calculated costs into Flight_Cost table for each inserted Seat
    INSERT INTO dbo.Flight_Cost (Seat_ID, ValidFromDate, Cost, ValidToDate)
    SELECT 
        i.Seat_ID, 
        f.Departure_Time AS ValidFromDate, 
        dbo.Cal_Cost(f.Departure_Time, f.Departure_Time, i.Class_ID, 'Yes') AS Cost, -- Simplified; adjust based on actual Cal_Cost function logic
        DATEADD(DAY, 1, f.Departure_Time) AS ValidToDate
    FROM 
        inserted i
        INNER JOIN dbo.Flight f ON i.Flight_Id = f.Flight_Id
    WHERE 
        f.Departure_Time IS NOT NULL;
END;
GO


-- =========================================

CREATE TRIGGER trg_FlightUpdateLog
ON Flight
AFTER UPDATE
AS
BEGIN
    INSERT INTO FlightChangeLog (Flight_Id, ChangeDate, PreviousArrival, NewArrival)
    SELECT d.Flight_Id, GETDATE(), d.Arrival_Time, i.Arrival_Time
    FROM deleted d
    INNER JOIN inserted i ON d.Flight_Id = i.Flight_Id
    WHERE d.Arrival_Time != i.Arrival_Time;
END;
GO


-- ======================================

CREATE TRIGGER SetPendingStatusOnInsert
ON Reservation
AFTER INSERT
AS
BEGIN
    -- Update the status to 'Pending' for newly inserted reservations
    UPDATE Reservation
    SET Reservation_Status = 'Pending'
    WHERE Reservation_ID IN (SELECT Reservation_ID FROM inserted);
END;

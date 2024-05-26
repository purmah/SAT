use FlightBookingSystem
Go


create MASTER KEY
ENCRYPTION BY PASSWORD = 'Damg@6210';


 CREATE CERTIFICATE EmpPass
WITH SUBJECT = 'Employee Sample Password';
GO

CREATE SYMMETRIC KEY EmpPass_SM
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE EmpPass;
 
alter table Passenger add Username varchar(50), [Password] varbinary(400)
 
OPEN SYMMETRIC KEY EmpPass_SM
DECRYPTION BY CERTIFICATE EmpPass;


UPDATE Passenger set [username] = 'janedoe', [Password] = EncryptByKey(Key_GUID('EmpPass_SM'), convert(varbinary,'Test@123') ) where Passenger_ID=13
GO
 

-- First open the symmetric key with which to decrypt the data.
OPEN SYMMETRIC KEY EmpPass_SM
DECRYPTION BY CERTIFICATE EmpPass;
SELECT *,
CONVERT(varchar, DecryptByKey([Password]))
AS 'Decrypted password'
FROM Passenger;





-- =====================
-- Other way of doing did for Email

ALTER TABLE Passenger
ADD EmailEncrypted VARBINARY(MAX);

UPDATE Passenger
SET EmailEncrypted = ENCRYPTBYPASSPHRASE('YourSecurePassphraseHere', Email);

INSERT INTO Passenger (Passenger_ID, FirstName, LastName, EmailEncrypted)
VALUES (1, 'John', 'Doe', ENCRYPTBYPASSPHRASE('YourSecurePassphraseHere', 'john.doe@example.com'));

--Check if email encrypted or not
SELECT 
    Passenger_ID,
    Email,
    EmailEncrypted,
    CASE 
        WHEN EmailEncrypted IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS IsEncrypted
FROM 
    Passenger;

--Attempting to check if original matches the encrypted 
SELECT 
    Passenger_ID,
    Email,
    CASE 
        WHEN CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('YourSecurePassphraseHere', EmailEncrypted)) = Email THEN 'Encrypted'
        ELSE 'Not Encrypted or Mismatch'
    END AS EncryptionStatus
FROM 
    Passenger;


--Decryption of encrypted email 
SELECT 
    FirstName, 
    LastName, 
    CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('YourSecurePassphraseHere', EmailEncrypted)) AS Email
FROM Passenger;






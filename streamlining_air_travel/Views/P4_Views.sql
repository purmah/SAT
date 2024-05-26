use FlightBookingSystem
GO


CREATE View SerivceDepedingOnClass AS
Select fs.Service_ID,fs.Service_Name ,so.Class_Id
from Flight_Service fs 
LEFT join  Service_Offering so on fs.Service_ID=so.Service_ID

go

Create View ServiceAndClass 
AS 
Select so.Class_ID,tc.ClassName
from Service_Offering so  
Left join Travel_Class tc on so.Class_ID = tc.Class_Id;
go

select * from SerivceDepedingOnClass
select * from ServiceAndClass

GO
Create View ServiceOfferingToClasses
AS
Select sdo.Service_ID,sdo.Service_Name,sdo.Class_Id,sc.ClassName
from SerivceDepedingOnClass sdo 
Left join  ServiceAndClass sc on sdo.Class_Id = sc.Class_ID

Go

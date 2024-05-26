Use FlightBookingSystem;
Go


CREATE NONCLUSTERED INDEX index_email ON Passenger(Email);
CREATE NONCLUSTERED INDEX index_departure ON Flight(Departure_Time);
CREATE NONCLUSTERED INDEX index_AirportCity ON Airport(AirportCity);

go
sp_helpindex Airport
go
sp_helpindex Passenger
go
sp_helpindex Flight

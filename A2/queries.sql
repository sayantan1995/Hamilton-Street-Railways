/*Sayantan Chattopadhyay 1000818145*/
/*Jay Ganguli 1001575191*/
/*Queries and results are both labeled by question*/
/*q1*/
SELECT BusID, Age, Manufacturer FROM Bus WHERE AdvertisingRevenue > 9000;
/*q2*/
SELECT COUNT(SIN) as 'NumberOfStudents' FROM Person
WHERE
  Occupation = "student"
  OR YEAR(FROM_DAYS(DATEDIFF(20180316, DateOfBirth))) < 25;
/*q3*/
SELECT COUNT(st.SIN)
FROM
  (SELECT SIN FROM Person 
  WHERE Occupation = 'student' OR YEAR(FROM_DAYS(DATEDIFF(20180316, DateOfBirth))) < 25) as st,
  (SELECT * FROM Bus WHERE RouteID = 5) as b,
  Take
WHERE
  st.SIN = Take.SIN AND Take.BusID = b.BusID AND Take.Date = DATE(20170503);
/*q4*/
SELECT RouteID, SUM(AdvertisingRevenue) as TotalRevenue
FROM Bus GROUP BY RouteID ORDER BY TotalRevenue DESC;
/*q5 part a*/
SELECT d.SIN, Person.FirstName, Person.LastName
FROM
  (SELECT Driver.SIN, COUNT(Driver.SIN) as 'Violations' FROM Driver LEFT JOIN Violate ON Driver.SIN = Violate.SIN
    GROUP BY Driver.SIN) as d,
  Person
WHERE Person.SIN = d.SIN AND (d.Violations < 3 OR d.Violations = Null);
/*q5 part b*/
SELECT d.SIN, Person.FirstName, Person.LastName, d.TotalDemerit, d.TotalFine
FROM
  (SELECT SIN, COUNT(SIN) as 'Violations', SUM(Demerit) as 'TotalDemerit', SUM(Fine) as 'TotalFine'
    FROM Violate GROUP BY SIN) as d,
  Person
WHERE Person.SIN = d.SIN AND d.TotalDemerit >= 2
ORDER BY d.TotalDemerit DESC, d.TotalFine DESC;
/*q6*/
SELECT Bus.BusID, Bus.Manufacturer
FROM
  (SELECT Manufacturer, COUNT(BusID) as 'NumOfBuses' FROM Bus GROUP BY Manufacturer) as t,
  Bus
WHERE Bus.Manufacturer = t.Manufacturer AND t.NumOfBuses = 1;
/*q7 part a*/
SELECT Passes.Type, SUM(Fee) as 'revenue'
FROM
  (SELECT Passenger.SIN, Passenger.Type, Fare.Fee FROM Passenger, Fare WHERE Passenger.Type = Fare.Type) as Passes
GROUP BY Passes.Type;
/*q7 part b*/
SELECT Type, revenue
FROM
  (SELECT Passes.Type, SUM(Fee) as 'revenue'
  FROM
    (SELECT Passenger.SIN, Passenger.Type, Fare.Fee FROM Passenger, Fare WHERE Passenger.Type = Fare.Type) as Passes
  GROUP BY Passes.Type) as FareRevenue
WHERE FareRevenue.revenue > 500;
/*q7 part c*/
SELECT Type as 'MostProfitablePassengerType' FROM
  (SELECT Fare.Type, SUM(Fare.Fee) as 'revenue'
  FROM Passenger, Take, Fare
  WHERE Passenger.SIN = Take.SIN AND Passenger.Type = Fare.Type AND Take.Date = DATE(20170501)
  GROUP BY Fare.Type) as FareRevenue
ORDER BY revenue DESC
LIMIT 1;
/*q8 part a*/
SELECT * FROM
  (SELECT Bus.RouteID, COUNT(*) as 'times'
  FROM Bus, Take
  WHERE Take.Date = DATE(20170507) AND Take.BusID = Bus.BusID
  GROUP BY Bus.RouteID) as NumOfTrips
ORDER BY times DESC
LIMIT 1;
/*q8 part b*/
SELECT * FROM
  (SELECT Date, COUNT(*) as 'times' FROM Take GROUP BY Date) as Trips
 ORDER BY times DESC
 LIMIT 1;
 /*q9*/
 /*Here, we assume that if a person takes a route that stops at a library, that person has visited that library*/
SELECT Person.Occupation
FROM
  (SELECT Take.SIN, Bus.RouteID FROM Take, Bus
    WHERE Take.BusID = Bus.BusID AND Take.Date IN (DATE(20170505), DATE(20170506))) as Routes,
  (SELECT * FROM Go WHERE SIName = 'Central Library' OR SIName = 'Locke Library' OR SIName = 'Westdale Library') as LibRoutes,
  Person
WHERE Routes.RouteID = LibRoutes.RouteID AND Person.SIN = Routes.SIN
GROUP BY Occupation;
/*q10*/
SELECT Person.FirstName, Person.LastName, Person.SIN
FROM
  (SELECT Driver.SIN, SUM(Demerit) FROM Driver, Violate
    WHERE Driver.SIN = Violate.SIN AND YearsOfService > 5 AND Salary > 80000 GROUP BY Driver.SIN) as d,
  Person
WHERE Person.SIN = d.SIN;
/*q11*/
/*The 'Marauders Tennis' game is held at 18:15:00 at 'Hamilton Tiger-Cats'*/
SELECT Students.FirstName, Students.LastName, Students.Sex
FROM
  (SELECT Take.SIN FROM Take, Bus
    WHERE Take.Time < TIME('18:15:00') AND Bus.BusID = Take.BusID AND Bus.RouteID = 4) as Attendee,
  (SELECT SIN, FirstName, LastName, Sex FROM Person
    WHERE Occupation = 'student' OR YEAR(FROM_DAYS(DATEDIFF(20180316, DateOfBirth))) < 25) as Students
WHERE Students.SIN = Attendee.SIN;
/*q12*/
SELECT Schedule.RouteID, Stop.SName, Schedule.ArrivalTime
FROM Schedule, Stop
WHERE
  Schedule.Date = DATE(20170501)
  AND Schedule.ArrivalTime >= TIME('16:20:00') AND Schedule.ArrivalTime <= TIME('16:50:00')
  AND Stop.SIName = 'Ron Joyce Stadium' AND Stop.StopID = Schedule.StopID;
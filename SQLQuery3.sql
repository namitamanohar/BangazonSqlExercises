SELECT e.FirstName, e.LastName, e.IsSupervisor, d.Name AS DepartmentName
FROM Employee e
LEFT JOIN Department d ON d.Id = e.DepartmentId
ORDER BY e.FirstName

SELECT d.[Name], d.Budget
FROM Department d 
ORDER BY d.Budget DESC

SELECT d.[Name] AS DepartmentName, e.[FirstName] AS EmployeeFirstName, e.[LastName] AS EmployeeLastName
FROM Department d 
LEFT JOIN Employee e 
ON e.DepartmentId = d.Id
WHERE e.IsSupervisor = 1 


SELECT d.[Name] AS DepartmentName, COUNT(e.Id) AS 'Number of Employees'
FROM Department d 
LEFT JOIN Employee e 
ON e.DepartmentId = d.Id
GROUP BY d.[Name]

UPDATE Department 
SET Budget = Budget*1.2

SELECT e.FirstName, e.LastName, et.TrainingProgramId 
FROM Employee e
LEFT JOIN EmployeeTraining et 
ON et.EmployeeId = e.Id 
WHERE et.TrainingProgramId IS NULL

SELECT e.FirstName, e.LastName, COUNT(et.TrainingProgramId) AS 'Number of Training Programs'
FROM Employee e
LEFT JOIN EmployeeTraining et 
ON et.EmployeeId = e.Id 
WHERE et.TrainingProgramId IS NOT NULL
GROUP BY e.FirstName, e.LastName

SELECT t.[Name], COUNT(et.EmployeeId) AS 'Number of Employees'
FROM TrainingProgram t 
LEFT JOIN EmployeeTraining et 
ON et.TrainingProgramId = t.Id
GROUP BY t.[Name]

SELECT t.[Name], COUNT(et.EmployeeId) AS 'Number of Employees'
FROM TrainingProgram t 
LEFT JOIN EmployeeTraining et 
ON et.TrainingProgramId = t.Id
GROUP BY t.[Name], t.MaxAttendees
HAVING t.MaxAttendees = COUNT(et.EmployeeId)

SELECT t.[Name], t.StartDate, t.endDate, t.MaxAttendees 
FROM TrainingProgram t 
WHERE t.StartDate > GetDate()

INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (20, 11);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (18, 15);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (17, 8);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (8, 7);


--12 THE GROUP BY is doing t.NAME AND t.ID together
SELECT TOP 3 t.[Name], COUNT(et.TrainingProgramId) AS 'Number of Participants'
FROM TrainingProgram t 
LEFT JOIN EmployeeTraining et
ON et.TrainingProgramId = t.Id 
GROUP BY t.[Name], t.Id 
ORDER BY [Number of Participants] DESC

--13
SELECT TOP 3 t.[Name], COUNT(et.TrainingProgramId) AS 'Number of Participants'
FROM TrainingProgram t 
LEFT JOIN EmployeeTraining et
ON et.TrainingProgramId = t.Id 
GROUP BY t.[Name]
ORDER BY [Number of Participants] DESC

--List all employees who do not have computers.
SELECT e.FirstName, e.LastName, ce.ComputerId, e.Id AS EmployeeId
FROM Employee e 
LEFT JOIN ComputerEmployee ce 
ON ce.EmployeeId = e.Id 
WHERE ce.ComputerId IS NULL

--List all employees along with their current computer information make and manufacturer combined into a field entitled ComputerInfo. If they do not have a computer, this field should say "N/A". coalesce value in case it is null; don't have unassigned date 
SELECT e.Id AS EmployeeId, e.FirstName, e.LastName, COALESCE(c.Make + '' + c.Manufacturer, 'N/A') AS ComputerInfo
FROM Employee e 
LEFT JOIN ComputerEmployee ce 
ON ce.EmployeeId = e.Id 
LEFT JOIN Computer c ON c.Id = ce.ComputerId 
WHERE ce.UnassignDate IS NULL

--List all computers that were purchased before July 2019 that have not been decommissioned.
SELECT c.Id, c.PurchaseDate, c.DecomissionDate, c.Make, c.Manufacturer 
FROM Computer c 
WHERE c.DecomissionDate IS NULL 
AND c.PurchaseDate< CONVERT(dateTime,'2019-07-01' )

--List all employees along with the total number of computers they have ever had.
SELECT  e.FirstName, e.LastName, COUNT(ce.ComputerId) AS 'Number of Computers'
FROM Employee e
LEFT JOIN ComputerEmployee ce 
ON ce.EmployeeId = e.Id 
LEFT JOIN Computer c ON c.Id = ce.ComputerId 
GROUP BY e.FirstName, e.LastName
ORDER BY 'Number of Computers' DESC

--List the number of customers using each payment type
SELECT p.[Name], COUNT(p.CustomerId) AS 'Payment Count'
FROM PaymentType p 
GROUP BY p.[Name]

--List the 10 most expensive products and the names of the seller
SELECT TOP 10 p.[Title], p.Price 
FROM Product p 
LEFT JOIN Customer c 
ON p.CustomerId = c.Id 
ORDER BY p.Price DESC

-- 20. List the 10 most purchased products and the names of the seller
SELECT TOP 10 p.[Title], COUNT(op.ProductId) AS 'Number of Purchases', c.FirstName, c.LastName
FROM Product p
LEFT JOIN OrderProduct op 
ON op.ProductId = p.Id
LEFT JOIN Customer c 
ON p.CustomerId = c.Id
GROUP BY p.[Title], op.ProductId, c.FirstName, c.LastName
ORDER BY [Number of Purchases] DESC

--21 Find the name of the customer who has made the most purchases
SELECT TOP 1 c.FirstName, c.LastName, COUNT(o.CustomerId) AS 'Number of Purchases'
FROM [ORDER] o 
LEFT JOIN Customer c 
ON o.CustomerId = c.Id
GROUP BY c.FirstName, c.LastName
ORDER BY [Number of Purchases] DESC

--22 List the amount of total sales by product type
SELECT pt.[Name] AS 'Product Type', SUM(p.Price) AS 'Total Sales'
FROM ProductType pt 
LEFT JOIN Product p 
ON p.ProductTypeId = pt.Id
LEFT JOIN OrderProduct op
ON op.ProductId = p.Id
GROUP BY pt.[Name] 

--23 List the total amount made from all sellers
SELECT c.[FirstName], c.LastName, COALESCE(SUM(p.Price),'0') AS 'Total Sales'
FROM Customer c
LEFT JOIN Product p 
ON p.CustomerId = c.Id
LEFT JOIN OrderProduct op
ON op.ProductId = p.Id
GROUP BY c.[FirstName], c.[LastName] 
ORDER BY [Total Sales] DESC

CREATE TABLE departments
(
	id INT PRIMARY KEY IDENTITY,
	deptName VARCHAR(20) NOT NULL
)
GO
CREATE TABLE cities
(
	id INT PRIMARY KEY IDENTITY,
	cityName VARCHAR(20)
)
GO	
CREATE TABLE employees
(
	employeeId INT IDENTITY PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	cityId INT NOT NULL REFERENCES cities(id),
	DepartmentId INT NOT NULL REFERENCES departments(id),
	gender VARCHAR(6) NOT NULL
)
GO
--SP
ALTER PROC spEmployee
(
	@employeeId INT=NULL,
	@name VARCHAR(20)=NULL,
	@cityId INT=NULL,
	@departmentId INT=NULL,
	@gender VARCHAR(6)=NULL,
	@actionType VARCHAR(25)
)
AS
BEGIN
	IF @actionType='SaveData'
		BEGIN
			IF NOT EXISTS (SELECT * FROM employees WHERE employeeId=@employeeId)
			BEGIN
				INSERT INTO employees(name,cityId,departmentId,gender)
				VALUES(@name,@cityId,@departmentId,@gender)
			END
			ELSE
			BEGIN
				UPDATE employees SET name=@name,cityId=@cityId,DepartmentId=@departmentId,gender=@gender
				WHERE employeeId=@employeeId
			END
		END
	IF @actionType='DeleteData'
	BEGIN
		DELETE FROM employees WHERE employeeId=@employeeId
	END
	IF @actionType='FetchData'
	BEGIN
		SELECT e.employeeId,e.name,e.gender,c.cityName,d.deptName FROM employees e
		INNER JOIN cities c ON e.cityId=c.id
		INNER JOIN departments d ON e.DepartmentId=d.id
	END
	IF @actionType='FetchRecord'
	BEGIN
		SELECT e.employeeId,e.name,e.gender,e.cityId,e.DepartmentId,c.cityName,d.deptName FROM employees e
		INNER JOIN cities c ON e.cityId=c.id
		INNER JOIN departments d ON e.DepartmentId=d.id
		WHERE employeeId=@employeeId
	END
END
GO

SELECT e.employeeId,e.name,e.gender,e.cityId,e.DepartmentId,c.cityName,d.deptName FROM employees e
INNER JOIN cities c ON e.cityId=c.id
INNER JOIN departments d ON e.DepartmentId=d.id
GO

SELECT * FROM employees
SELECT id,cityName FROM cities
SELECT id,deptName FROM departments


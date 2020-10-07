-- List employees with theirs customers
SELECT e.firstName,e.lastName,c.customerName FROM employees e JOIN customers c ON e.employeeNumber=c.salesRepEmployeeNumber;
 -- List employees by number of their clients
SELECT e.firstName,e.lastName, COUNT(*) FROM employees e 
JOIN customers c ON e.employeeNumber=c.salesRepEmployeeNumber
GROUP BY e.firstName,e.lastName;
-- Show employee with highest number of customers
SELECT e.employeeNumber,e.firstName,e.lastName, COUNT(*) mycount FROM employees e 
JOIN customers c ON e.employeeNumber=c.salesRepEmployeeNumber
GROUP BY e.employeeNumber,e.firstName,e.lastName ORDER BY mycount DESC;
-- Show employee with highest number of orders
SELECT e.employeeNumber,e.firstName,e.lastName, c.customerName, o.orderNumber 
FROM employees e 
JOIN customers c ON e.employeeNumber=c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber=o.customerNumber;
-- GROUP BY e.employeeNumber,e.firstName,e.lastName,c.customerName, o.orderNumber;

-- Show customers with number of orders sorted descending
SELECT c.customerNumber, COUNT(*) numberOfOrders
FROM customers c 
JOIN orders o ON c.customerNumber=o.customerNumber
GROUP BY c.customerNumber ORDER BY numberOfOrders DESC;

-- view containing customers with their order count
create or replace view customersWithOrderCount as (
SELECT c.customerNumber,c.salesRepEmployeeNumber, COUNT(*) numberOfOrders
FROM customers c 
JOIN orders o ON c.customerNumber=o.customerNumber
GROUP BY c.customerNumber,c.salesRepEmployeeNumber ORDER BY numberOfOrders DESC
);


-- Show employe with highest number of orders made by his customers
SELECT e.employeeNumber,e.firstName, e.lastName, SUM(cwoc.numberOfOrders) numbersOfCustomersOrders FROM employees e
JOIN customersWithOrderCount cwoc ON cwoc.salesRepEmployeeNumber = e.employeeNumber
GROUP BY e.employeeNumber,e.firstName, e.lastName ORDER BY numbersOfCustomersOrders DESC LIMIT 1;

-- Which product line has the highest number of products
SELECT pl.productLine, COUNT(*) highestNumberOfProducts FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
GROUP BY pl.productLine ORDER BY highestNumberOfProducts DESC LIMIT 1;


-- Which customer has made orders for the heighest total amount 
create view totalAmountOfOrderNumber as(
SELECT od.orderNumber, SUM(od.priceEach * od.quantityOrdered) totalAmount FROM orderdetails od 
GROUP BY od.orderNumber);

create view customersWithOrdersNumber as(
SELECT c.customerName, o.orderNumber FROM customers c
JOIN orders o  ON c.customerNumber = o.customerNumber);

SELECT cwon.customerName, SUM(taoon.totalAmount) highestTotalAmount FROM customersWithOrdersNumber cwon
JOIN totalAmountOfOrderNumber taoon ON cwon.orderNumber=taoon.orderNumber
GROUP BY cwon.customerName ORDER BY highestTotalAmount DESC LIMIT 1;

-- Which customer has highest number of payments
SELECT c.customerName, COUNT(*) highestNumberOfPayments FROM customers c
JOIN payments p  ON c.customerNumber = p.customerNumber
GROUP BY c.customerName ORDER BY highestNumberOfPayments DESC LIMIT 1;

-- Which customer has highest total payment amount
SELECT c.customerName, SUM(p.amount) highestPaymentAmount FROM customers c
JOIN payments p  ON c.customerNumber = p.customerNumber
GROUP BY c.customerName ORDER BY highestPaymentAmount DESC LIMIT 1;


-- Which customer ordered the heighest number of products
create or replace view orderNumberWithNumberOfProducts as(
SELECT od.orderNumber, SUM(od.quantityOrdered) numberOfProducts FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY od.orderNumber);

create or replace view ordersWithNumberOfProducts as(
SELECT  o.customerNumber, onwnop.numberOfProducts FROM orders o 
JOIN orderNumberWithNumberOfProducts onwnop ON o.orderNumber = onwnop.orderNumber
GROUP BY o.customerNumber,onwnop.numberOfProducts
);

SELECT c.customerName,c.customerNumber, SUM(ownop.numberOfProducts) numberOfOrderedProducts FROM customers c
JOIN ordersWithNumberOfProducts ownop  ON c.customerNumber = ownop.customerNumber
GROUP BY c.customerName,c.customerNumber ORDER BY numberOfOrderedProducts DESC LIMIT 1;

-- Employees from which office have the heighest number of customers
SELECT e.officeCode, COUNT(*) customersCount 
FROM employees e
JOIN customers c ON e.employeeNumber=c.salesRepEmployeeNumber
GROUP BY e.officeCode ORDER BY customersCount DESC LIMIT 1;

-- Show manager (employees with report to equal to null)
create or replace view managers as(
SELECT e.firstName, e.lastName, m.managerId FROM (SELECT DISTINCT e.reportsTo managerId FROM employees  e) m 
JOIN employees e ON e.employeeNumber = m.managerId);

-- Show managers with the number of their direct subordinates
SELECT m.managerId, COUNT(*) numberOfDirectSubordinates FROM employees  e
JOIN managers m ON e.reportsTo = m.managerId
GROUP BY m.managerId;






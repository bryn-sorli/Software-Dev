SELECT firstname, lastname FROM employees WHERE country <> 'USA' and hiredate < '2013-11-08' ORDER BY firstname;

SELECT productid, productname, unitsinstock, unitprice FROM products WHERE unitsinstock < reorderlevel and unitsinstock >0;

SELECT productname, unitprice FROM products WHERE unitprice = (SELECT min(unitprice) FROM products) UNION SELECT productname, unitprice FROM products WHERE unitprice = (SELECT MAX(unitprice) FROM products);

SELECT productid, productname, unitsinstock*unitprice AS "Total Inventory Value" FROM products WHERE unitsinstock*unitprice > 1000 ORDER BY unitsinstock*unitprice DESC;

SELECT shipcountry, count(orderid) FROM orders WHERE NOT shipcountry = 'Germany' AND extract(year from shippeddate) = '2013' AND extract(month from shippeddate) = '10' GROUP BY shipcountry ORDER BY shipcountry DESC;

SELECT orders.customerid, orders.shipname FROM orders GROUP BY orders.customerid, orders.shipname HAVING COUNT(orders.customerid) >= 10;

SELECT products.supplierid, SUM(products.unitsinstock*products.unitprice) AS "value of inventory" FROM products GROUP BY products.supplierid HAVING COUNT(products.supplierid) >= 5;

SELECT suppliers.companyname, products.productname, products.unitprice FROM suppliers FULL JOIN products ON suppliers.supplierid = products.supplierid WHERE suppliers.country = 'USA' OR suppliers.country = 'Germany' ORDER BY products.unitprice DESC;

SELECT employees.lastname, employees.firstname, employees.title, employees.extension, COUNT(orders.employeeid) as "Number of orders" FROM employees FULL JOIN orders ON employees.employeeid = orders.employeeid GROUP BY employees.lastname, employees.firstname, employees.title, employees.extension HAVING COUNT(orders.employeeid) > 50 ORDER BY (employees.lastname, employees.firstname) DESC;

SELECT customers.customerid, customers.companyname FROM customers FULL JOIN orders ON orders.customerid = customers.customerid GROUP BY customers.companyname, customers.customerid HAVING COUNT(orders.customerid) = 0;

SELECT suppliers.companyname, suppliers.contactname, categories.categoryname, categories.description, products.productname, products.unitsonorder FROM suppliers FULL JOIN products ON products.supplierid = suppliers.supplierid FULL JOIN categories ON products.categoryid = categories.categoryid GROUP BY suppliers.companyname, suppliers.contactname, categories.categoryname, categories.description, products.productname, products.unitsonorder, products.unitsinstock HAVING products.unitsinstock = 0;

SELECT products.productname, suppliers.companyname, suppliers.country, products.unitsinstock FROM products FULL JOIN suppliers ON products.supplierid = suppliers.supplierid GROUP BY  products.productname, suppliers.companyname, suppliers.country, products.unitsinstock, products.quantityperunit HAVING products.quantityperunit LIKE '%bags%' OR products.quantityperunit LIKE '%bottles%';

CREATE TABLE Top_Items(ItemID int NOT NULL PRIMARY KEY, ItemCode int NOT NULL, ItemName varchar(40) NOT NULL, InventoryDate timestamp NOT NULL, SupplierID int NOT NULL, ItemQuantity int NOT NULL, ItemPrice decimal(9,2) NOT NULL);

INSERT INTO Top_Items (ItemID, itemcode, itemname, inventorydate, itemquantity, itemprice, supplierid) SELECT productid, categoryid, productname, current_timestamp, unitsinstock, unitprice, supplierid  FROM products WHERE unitsinstock*unitprice > 1500;

DELETE FROM Top_Items WHERE supplierid in (SELECT supplierid FROM suppliers WHERE suppliers.country = 'USA' OR suppliers.country = 'Canada');

ALTER TABLE Top_Items ADD InventoryValue decimal(9,2);

UPDATE Top_Items SET inventoryvalue = itemquantity*itemprice;

DROP TABLE Top_Items;

-- Our NAMES: Zhiqing Liu; Junyu Huang; Guanglu Fan

CREATE DATABASE Ecommerce1;
USE Ecommerce1;
-- DROP DATABASE Ecommerce1;

CREATE TABLE Products(
  Product_id			VARCHAR(255)	NOT NULL,
  Product_name    	    VARCHAR(255)	NOT NULL,
  Product_type 	     	VARCHAR(255)	NOT NULL,
  Quantity_in_stock 	INT(10)			NOT NULL,
  Product_price 		FLOAT(6,2)		NOT NULL,
  PRIMARY KEY (Product_id)
);

CREATE TABLE Customer_types(
  Customer_type      			VARCHAR(255)	NOT NULL,
  Type_description   			VARCHAR(255)	NOT NULL,
  Membership_fee 				FLOAT(6,2)		NOT NULL,
  Free_shipping_threshold		FLOAT(6,2)		NOT NULL,
  Standard_shipment_fee			FLOAT(6,2)		NOT NULL,
  PRIMARY KEY (Customer_type)
);

CREATE TABLE Customers(
  Customer_id 		    VARCHAR(255)	NOT NULL,
  Customer_name 		VARCHAR(255)	NOT NULL,
  Password  			VARCHAR(255)	NOT NULL,
  Phone 				INT(10)			NOT NULL,
  City			    	VARCHAR(255)	NOT NULL,
  Customer_type 		VARCHAR(255)	NOT NULL	DEFAULT 'Non-membership',
  Sign_up_date   		DATETIME		NOT NULL    DEFAULT NOW(),
  PRIMARY KEY (Customer_id),
  FOREIGN KEY (Customer_type)	REFERENCES Customer_types(Customer_type)
);


CREATE TABLE Orders 
(
  Order_id 		     	INT	  			NOT NULL,
  Order_date 			DATETIME		NOT NULL       	DEFAULT NOW(),
  Product_id 			VARCHAR(255)	NOT NULL,
  Quantity_order 	    INT				NOT NULL,
  Order_total		    DECIMAL(6,2)	NOT NULL,
  Delivery_id 		    VARCHAR(255)	NOT NULL,
  Customer_id 		    VARCHAR(255)	NOT NULL,
  PRIMARY KEY (Order_id),
  FOREIGN KEY (Customer_id) 	REFERENCES 	Customers(Customer_id),
  FOREIGN KEY (Product_id)   	REFERENCES 	Products(Product_id)
);

CREATE TABLE Delivery(
  Delivery_id        	VARCHAR(255)	NOT NULL,
  Order_id 		     	INT	  			NOT NULL,
  Delivery_status       VARCHAR(255)	NOT NULL   DEFAULT 'Label Creating',
  Shipping_fee 		    FLOAT(6,2)		NOT NULL,
  Shipping_date 		DATETIME		NOT NULL    DEFAULT NOW(),
  Delivered_date 		DATETIME		NOT NULL    DEFAULT NOW(),
  PRIMARY KEY (Delivery_id),
  FOREIGN KEY (Order_id) 	REFERENCES 	Orders(Order_id)
);

CREATE TABLE Account 
(
  Account_id 			VARCHAR(255)	NOT NULL,
  Customer_id 			VARCHAR(255)	NOT NULL,
  Balance 				FLOAT(6,2)		NOT NULL	DEFAULT "0.00",
  PRIMARY KEY (Account_id),
  FOREIGN KEY (Customer_id) 	REFERENCES 	Customers(Customer_id)
);


-- Step 2: Insert data into tables 


-- INSERT INTO Customer_types
INSERT INTO Customer_types (Customer_type, Type_description, Membership_fee,Free_shipping_threshold,Standard_shipment_fee) VALUES('Membership', 'Enjoy Free Shipping','10.00','0.00','0.00');
INSERT INTO Customer_types (Customer_type, Type_description, Membership_fee,Free_shipping_threshold,Standard_shipment_fee) VALUES('Non-membership', 'Enjor Free Shipping when the total consumption amount is larger then $60, otherwise $10 shipping fee','0.00','60.00','10.00');

-- INSERT INTO Customers
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('124', 'John', 'J19859079', '3054589376', 'Coral Gables', 'Membership', '2018-09-12');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('125', 'Smith', 'S98783472', '3058937840', 'Pinecrest', 'Membership', '2019-04-09');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('126', 'Jocob', 'J39847859', '7899387674', 'South Miami', 'Non-Membership', '2017-01-23');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('127', 'Jane', 'J87498372', '7890987633', 'Coral Gables', 'Membership', '2020-08-09');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('128', 'Maria', 'M98376789', '3056784988', 'South Miami', 'Non-Membership', '2018-12-31');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('129', 'Max', 'M19876578', '3053028799', 'North Miami', 'Non-Membership', '2019-12-10');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('130', 'Jiaking', 'J28987890', '7890987899', 'North Miami', 'Membership', '2020-04-08');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('131', 'Xingrui', 'X90908909', '3052098900', 'Pinecrest', 'Membership', '2019-03-09');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('132', 'Animaie', 'A98099098', '3056789098', 'Miami Gardens', 'Membership', '2018-11-09');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('133', 'Kinkor', 'K56489308', '3056789463', 'Miami Gardens', 'Membership', '2018-05-24');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('134', ' Sojuiy', 'S23786578', '2017896777', 'Coral Gables', 'Non-Membership', '2020-09-19');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('135', ' Hingjin', 'H33893322', '2039876789', 'Pinecrest', 'Non-Membership', '2019-05-18');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('136', 'Dadln', 'D90908765', '2045879800', 'South Miami', 'Membership', '2019-08-19'); 
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('137', 'Lindsay', 'L90899038', '2014598777', 'South Miami', 'Non-Membership', '2018-07-29');
INSERT INTO Customers (Customer_id, Customer_name, Password, Phone, City, Customer_Type, Sign_up_date) VALUES('138', 'Guyinj', 'G78092345', '2013490977', 'North Miami', 'Non-Membership', '2020-01-13');




-- INSERT INTO Products
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('01', 'Passiflora Edulis', 'Fruit', '57', '6.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('02', 'Chinese Guava', 'Fruit', '64', '2.39');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('03', 'Persimmon', 'Fruit', '43', '3.49');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('04', 'Fuji Apple', 'Fruit', '55', '2.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('05', 'Wawa Choy', 'Vegetable', '35', '1.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('06', 'Snow Pea Tips', 'Vegetable', '43', '5.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('07', 'Chives', 'Vegetable', '57', '4.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('08', 'Red Onion', 'Vegetable', '24', '0.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('09', 'Ramen Pork Spicy', 'Instant Food', '58', '4.49');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('10', 'Kungpao Chicken Flv inst.Rice', 'Instant Food', '46', '6.49');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('11', 'Instant BBQ', 'Instant Food', '39', '6.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('12', 'Sour Spicy Vermicelli', 'Instant Food', '48', '2.59');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('13', 'Oolong Tea', 'Tea', '89', '1.19');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('14', 'Chinese Cranberry Flv.tea', 'Tea', '52', '2.19');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('15', 'Honeysuckle Tea', 'Tea', '102', '5.59');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('16', 'Rose Buds Tea', 'Tea', '98', '3.79');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('17', 'Spicy Hotpot Seasoning', 'Cooking Seasoning', '79', '1.99');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('18', 'White Seasame Jar', 'Cooking Seasoning', '123', '4.29');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('19', 'Star Aniseed', 'Cooking Seasoning', '104', '2.09');
INSERT INTO Products (Product_id, Product_name, Product_type, Quantity_in_stock,Product_price) VALUES('20', 'Mapo Tofu Paste', 'Cooking Seasoning', '90', '0.99');

-- INSERT INTO Account
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A001', '124', '100.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A002', '125', '2.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A003', '126', '50.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A004', '127', '100.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A005', '128', '30.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A006', '129', '0.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A007', '130', '100.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A008', '131', '70.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A009', '132', '63.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A010', '133', '100.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A011', '134', '88.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A012', '135', '30.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A013', '136', '100.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A014', '137', '19.00');
INSERT INTO Account (Account_id, Customer_id, Balance) 	VALUES('A015', '138', '1.00');

-- INSERT INTO Orders
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139876', '2021-07-10', '03', '23', '80.27', '1478', '125');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139877', '2021-07-11', '04', '10', '29.90', '1479', '128');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139878', '2021-07-13', '05', '35', '69.65', '1480', '129');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139879', '2021-08-09', '03', '34', '118.66', '1481', '131');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139880', '2021-08-21', '02', '28', '66.92', '1482', '132');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139881', '2021-08-22', '13', '14', '16.66', '1483', '133');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139882', '2021-07-15', '15', '22', '122.98', '1484', '133');
INSERT INTO Orders (Order_id, Order_date, Product_id, Quantity_order, Order_total, Delivery_id, Customer_id) VALUES('20139883', '2021-07-21', '20', '15', '14.85', '1485', '134');

-- INSERT INTO Delivery
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1478', '20139876','Delivered', '0', '2021-07-13', '2021-07-15 ');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1479', '20139877','Delivered', '10', '2021-07-13', '2021-07-18');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1480', '20139878','Shipping', '0', '2021-08-01', ' ');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1481', '20139879','Delivered', '0', '2021-08-10', '2021-08-13');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1482', '20139880','Delivered', '0', '2021-08-23', '2021-08-26');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1483', '20139881','Label Creating', '0', ' ', ' ');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1484', '20139882','Label Creating', '0', ' ', ' ');
INSERT INTO Delivery (Delivery_id, Order_id, Delivery_status, Shipping_fee, Shipping_date, Delivered_date) VALUES('1485', '20139883','Shipping', '10', '2021-07-23', ' ');


-- Step 3: Create View

	-- check balance
CREATE OR REPLACE VIEW Customer_Balance AS
SELECT 
	C.Customer_id, Customer_name, Balance 
FROM Customers C
LEFT JOIN Account A
	ON A.Customer_id = C.Customer_id
ORDER BY A.Customer_id 
;
SELECT * FROM Customer_Balance;

	-- check Orders
CREATE OR REPLACE VIEW Customer_Orders AS
SELECT 
	C.Customer_id, Customer_name, O.Order_id, Order_date, Quantity_order,Order_total,P.Product_id,Product_name
FROM Customers C
LEFT JOIN Orders O
	ON O.Customer_id = C.Customer_id
LEFT JOIN Products P
	ON P.Product_id = O.Product_id
ORDER BY 1 
;

SELECT * FROM Customer_Orders;

-- Check membership
CREATE OR REPLACE VIEW Customer_Membership AS
SELECT 
	C.Customer_id, Customer_name, Type_description 
FROM Customers C
LEFT JOIN Customer_types CT
	ON CT.Customer_type = C.Customer_type
ORDER BY 1 
;
SELECT * FROM Customer_Membership;

	-- check Order delivery status

CREATE OR REPLACE VIEW Delivery_Status AS
SELECT 
	O.Order_id, Order_date, D.Delivery_id, Delivery_status
FROM Orders O
LEFT JOIN Delivery D
	ON D.Delivery_id = O.Delivery_id
ORDER BY 1 
;
SELECT * FROM Delivery_Status;

	-- check Best sellers
CREATE OR REPLACE VIEW Most_popular_items AS
SELECT * FROM
(SELECT P.Product_id, P.Product_name, P.Product_type, O.Quantity_order, RANK() OVER(PARTITION BY P.Product_type ORDER BY O.Quantity_order DESC) AS 'Order Rank'
FROM Ecommerce1.Products P
LEFT JOIN Orders O
ON P.Product_id = O.Product_id) n
WHERE `Order Rank` = 1 AND Quantity_order != 'NULL'
ORDER BY Quantity_order DESC;

SELECT * FROM Most_popular_items;

-- Step 4: Stored Procedures
DELIMITER $$

CREATE PROCEDURE insert_new_customer (IN p_Customer_id VARCHAR(255),IN p_Customer_name VARCHAR(255), IN p_password VARCHAR(255), IN p_phone INT(10))
BEGIN
 INSERT INTO Customers (Customer_id, Customer_name, Password, Phone) VALUES(p_Customer_id, p_Customer_name, p_password, p_phone);
END $$

CALL insert_new_customer('139','Lewis','Lewis@','7869069666') $$
SELECT* FROM Customers;

CREATE PROCEDURE delete_customer(IN p_Customer_id VARCHAR(255))
BEGIN
	DELETE FROM Customers WHERE Customer_id = p_Customer_id;
END $$
CALL delete_customer('124') $$
SELECT* FROM Customers;

CREATE PROCEDURE update_customer_password(IN p_Customer_id VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
	UPDATE Customers SET password = p_password WHERE Customer_id = p_Customer_id;
END $$
CALL update_customer_password('138','Passw@rd') $$

CREATE PROCEDURE register_as_a_member(IN p_Customer_id VARCHAR(255), OUT p_message VARCHAR(255))
BEGIN
	
    DECLARE v_Customer_type VARCHAR(255);
    DECLARE v_Customer_balance FLOAT(6,2);
    
    SELECT Balance INTO v_Customer_balance FROM Account WHERE Customer_id = p_Customer_id;
	SELECT Customer_type INTO v_Customer_type FROM Customers WHERE Customer_id = p_Customer_id;
    
    IF v_Customer_type =  'Membership'
		THEN 
			SELECT 'Sorry, this customer is already a member.' INTO p_message;
	ELSEIF v_Customer_balance <= (SELECT Membership_fee FROM Customer_types WHERE Customer_type = 'Membership')
        THEN 
			SELECT 'Sorry, Insufficient account balance.' INTO p_message;
	ELSE		
		UPDATE Customers SET Customer_type = 'Membership' WHERE Customer_id = p_Customer_id;
		UPDATE Account SET Balance = v_Customer_balance - (SELECT Membership_fee FROM Customer_types WHERE Customer_type = 'Membership') WHERE Customer_id = p_Customer_id;
        SELECT 'Thank you for registering as our member.' INTO p_message;
    END IF;
END $$
/* 
if customer is already return 'Sorry, this customer is already a member.'
elif customer account balance less than the membership fee, return 'Sorry, Insufficient account balance.'
else deduct membership fee from the account and chenge the membership status
*/
SELECT * FROM Customers $$
CALL register_as_a_member ('128', @message)$$
SELECT @message$$


#SET SQL_SAFE_UPDATES = 0;
CREATE PROCEDURE create_an_order (IN p_Customer_id VARCHAR(255),IN p_Order_id VARCHAR(255),IN p_Product_id VARCHAR(255), IN p_Quantity_order INT, OUT p_message VARCHAR(255))
BEGIN
    DECLARE v_Customer_type VARCHAR(255);
    
    SELECT Customer_type INTO v_Customer_type FROM Customers WHERE Customer_id = p_Customer_id;
    
    IF (SELECT Quantity_in_stock FROM Products WHERE Product_id = p_Product_id) < p_Quantity_order
		THEN 
			SELECT 'Sorry, Insufficient inventory.' INTO p_message;
	ELSE 
		INSERT INTO Orders (Order_id, Product_id, Quantity_order, Customer_id) 
			VALUES(p_Order_id, p_Product_id, p_Quantity_order, p_Customer_id);
        SELECT 'Order created.' INTO p_message;
	END IF;
    
    IF v_Customer_type !=  'Membership' AND (SELECT Product_price FROM Products WHERE Product_id = p_Product_id) * p_Quantity_order < (SELECT Free_shipping_threshold FROM Customer_types WHERE Customer_type = 'Non-membership')
		THEN 
			UPDATE Orders SET Order_total = (SELECT Product_price FROM Products WHERE Product_id = p_Product_id) * p_Quantity_order + (SELECT Standard_shipment_fee FROM Customer_types WHERE Customer_type = 'Non-membership') WHERE Order_id = p_Order_id;
			SELECT 'Shipping fee added.' INTO p_message;
    ELSE 
		UPDATE Orders SET Order_total = (SELECT Product_price FROM Products WHERE Product_id = p_Product_id) * p_Quantity_order WHERE Order_id = p_Order_id;
        SELECT 'Enjoy your free shipping.' INTO p_message;
    END IF;
    
END $$
SELECT * FROM Orders $$
SELECT * FROM Products $$
CALL create_an_order ('126','20139887','01',5, @message)$$
SELECT @message$$

CREATE PROCEDURE cancel_order (IN p_Order_id VARCHAR(255), OUT p_message VARCHAR(255))
BEGIN
	DECLARE v_Delivery_status VARCHAR(255);
	SELECT Delivery_status INTO v_Delivery_status FROM Delivery WHERE Order_id = p_Order_id;
    IF v_Delivery_status = 'Shipping' OR 'Delivered'
		THEN 
			SELECT 'Your order has been shipped/Delivered' INTO p_message;
    ELSE 
		DELETE FROM Orders WHERE Order_id = p_Order_id;
		SELECT 'Your order has been cancelled' INTO p_message;
    END IF;
END $$
SET FOREIGN_KEY_CHECKS=0;
CALL cancel_order('20139882',@message) $$
SELECT @message$$

DELIMITER ;
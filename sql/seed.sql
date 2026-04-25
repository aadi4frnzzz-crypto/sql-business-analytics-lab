-- ============================================================
-- Seed Data: Realistic Indian E-Commerce Dataset
-- 10 customers, 10 products, 30 orders, 60 line items
-- ============================================================

-- Customers
INSERT INTO customers VALUES
(1,'Rahul Sharma','rahul@email.com','Mumbai','Maharashtra','2023-01-10','vip'),
(2,'Priya Patel','priya@email.com','Ahmedabad','Gujarat','2023-02-15','retail'),
(3,'Amit Kumar','amit@email.com','Delhi','Delhi','2023-03-05','wholesale'),
(4,'Sneha Reddy','sneha@email.com','Hyderabad','Telangana','2023-03-20','retail'),
(5,'Vikram Singh','vikram@email.com','Jaipur','Rajasthan','2023-04-01','retail'),
(6,'Meera Nair','meera@email.com','Kochi','Kerala','2023-04-15','vip'),
(7,'Ravi Teja','ravi@email.com','Bengaluru','Karnataka','2023-05-10','wholesale'),
(8,'Anjali Gupta','anjali@email.com','Kolkata','West Bengal','2023-06-01','retail'),
(9,'Suresh Das','suresh@email.com','Bhubaneswar','Odisha','2023-07-20','retail'),
(10,'Kavita Joshi','kavita@email.com','Pune','Maharashtra','2023-08-05','vip');

-- Products
INSERT INTO products VALUES
(1,'Noise Buds Wireless','Electronics','Audio',1299,650),
(2,'Cotton Kurta Set','Apparel','Ethnic',849,320),
(3,'Stainless Steel Tiffin','Kitchenware','Storage',499,180),
(4,'Python Programming Book','Books','Tech',599,200),
(5,'Yoga Mat Pro','Sports','Fitness',1199,450),
(6,'Whey Protein 1kg','Health','Nutrition',1899,800),
(7,'Mechanical Keyboard','Electronics','Computing',2499,1100),
(8,'Scented Candle Set','Home Decor','Fragrance',349,120),
(9,'Running Shoes','Sports','Footwear',1799,700),
(10,'Face Cream SPF50','Beauty','Skincare',649,200);

-- Orders
INSERT INTO orders VALUES
(1001,1,'2024-01-05','completed','Mumbai','Maharashtra','upi'),
(1002,2,'2024-01-12','completed','Ahmedabad','Gujarat','card'),
(1003,3,'2024-01-20','completed','Delhi','Delhi','netbanking'),
(1004,1,'2024-02-03','completed','Mumbai','Maharashtra','upi'),
(1005,4,'2024-02-10','cancelled','Hyderabad','Telangana','cod'),
(1006,5,'2024-02-18','completed','Jaipur','Rajasthan','upi'),
(1007,6,'2024-03-02','completed','Kochi','Kerala','card'),
(1008,7,'2024-03-15','completed','Bengaluru','Karnataka','netbanking'),
(1009,2,'2024-03-22','completed','Ahmedabad','Gujarat','upi'),
(1010,8,'2024-04-05','completed','Kolkata','West Bengal','cod'),
(1011,1,'2024-04-12','refunded','Mumbai','Maharashtra','upi'),
(1012,9,'2024-04-20','completed','Bhubaneswar','Odisha','card'),
(1013,3,'2024-05-01','completed','Delhi','Delhi','netbanking'),
(1014,10,'2024-05-10','completed','Pune','Maharashtra','upi'),
(1015,6,'2024-05-18','completed','Kochi','Kerala','card'),
(1016,4,'2024-06-02','completed','Hyderabad','Telangana','upi'),
(1017,7,'2024-06-14','completed','Bengaluru','Karnataka','netbanking'),
(1018,5,'2024-06-25','completed','Jaipur','Rajasthan','cod'),
(1019,1,'2024-07-05','completed','Mumbai','Maharashtra','upi'),
(1020,2,'2024-07-15','completed','Ahmedabad','Gujarat','card'),
(1021,10,'2024-07-22','completed','Pune','Maharashtra','upi'),
(1022,8,'2024-08-01','cancelled','Kolkata','West Bengal','cod'),
(1023,6,'2024-08-10','completed','Kochi','Kerala','card'),
(1024,3,'2024-08-20','completed','Delhi','Delhi','netbanking'),
(1025,9,'2024-09-03','completed','Bhubaneswar','Odisha','upi'),
(1026,1,'2024-09-15','completed','Mumbai','Maharashtra','card'),
(1027,7,'2024-09-25','completed','Bengaluru','Karnataka','upi'),
(1028,10,'2024-10-08','completed','Pune','Maharashtra','netbanking'),
(1029,4,'2024-10-20','completed','Hyderabad','Telangana','upi'),
(1030,5,'2024-11-05','completed','Jaipur','Rajasthan','card');

-- Order Line Items
INSERT INTO order_items(order_id,product_id,quantity,unit_price,discount_pct) VALUES
(1001,1,2,1299,0.10),(1001,4,1,599,0),
(1002,2,3,849,0.05),(1002,8,2,349,0),
(1003,7,1,2499,0.15),(1003,6,2,1899,0.10),
(1004,5,1,1199,0),(1004,10,2,649,0.05),
(1005,3,4,499,0),(1005,8,1,349,0),
(1006,9,1,1799,0.08),(1006,6,1,1899,0),
(1007,1,1,1299,0),(1007,7,2,2499,0.12),
(1008,4,3,599,0),(1008,5,2,1199,0.05),
(1009,2,5,849,0.10),(1009,10,1,649,0),
(1010,3,2,499,0),(1010,9,1,1799,0.06),
(1011,6,1,1899,0),(1011,1,3,1299,0.08),
(1012,7,1,2499,0),(1012,4,2,599,0.05),
(1013,5,3,1199,0.12),(1013,2,2,849,0),
(1014,10,4,649,0),(1014,8,3,349,0),
(1015,9,2,1799,0.10),(1015,6,1,1899,0.05),
(1016,1,2,1299,0),(1016,3,3,499,0.08),
(1017,7,2,2499,0.15),(1017,5,1,1199,0),
(1018,4,4,599,0),(1018,10,2,649,0.05),
(1019,9,1,1799,0),(1019,6,2,1899,0.10),
(1020,2,6,849,0.12),(1020,8,4,349,0),
(1021,1,3,1299,0.08),(1021,7,1,2499,0.10),
(1022,3,5,499,0),(1022,4,1,599,0),
(1023,5,2,1199,0.05),(1023,9,1,1799,0),
(1024,6,3,1899,0.15),(1024,10,2,649,0.08),
(1025,8,6,349,0),(1025,2,3,849,0.10),
(1026,7,2,2499,0),(1026,1,4,1299,0.12),
(1027,4,5,599,0.05),(1027,5,3,1199,0),
(1028,9,2,1799,0.10),(1028,6,1,1899,0),
(1029,10,3,649,0),(1029,3,4,499,0.05),
(1030,1,2,1299,0),(1030,7,1,2499,0.08);

CREATE TABLE trains (
  train_id varchar(100), 
  train_name varchar(50) NOT NULL, 
  train_code varchar(50) NOT NULL UNIQUE, 
  PRIMARY KEY (train_id)
);

CREATE TABLE stations (
  station_id varchar(100), 
  name varchar(100) NOT NULL UNIQUE, 
  address varchar(100) NOT NULL, 
  PRIMARY KEY (station_id)
);

CREATE TABLE routes (
  route_id varchar(100), 
  departure_station_id varchar(100) NOT NULL, 
  arrival_station_id varchar(100) NOT NULL, 
  distance number NOT NULL, 
  PRIMARY KEY (route_id), 
  FOREIGN KEY (departure_station_id) REFERENCES stations(station_id), 
  FOREIGN KEY (arrival_station_id) REFERENCES stations(station_id)
);

CREATE TABLE passengers (
  passenger_id varchar(100), 
  email varchar(100) NOT NULL UNIQUE, 
  name varchar(100) NOT NULL, 
  phone varchar(20), 
  address varchar(200), 
  PRIMARY KEY (passenger_id)
);

CREATE TABLE payment_method (
  payment_method_id varchar(100), 
  method_type varchar(50), 
  description varchar(500), 
  passenger_id varchar(100), 
  PRIMARY KEY (payment_method_id), 
  FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
);

CREATE TABLE trips (
  trip_id varchar(100), 
  train_id varchar(100) NOT NULL, 
  route_id varchar(100) NOT NULL, 
  departure_date timestamp NOT NULL, 
  arrival_date timestamp NOT NULL, 
  capacity number, 
  availabile_capacity number, 
  PRIMARY KEY (trip_id), 
  FOREIGN KEY (train_id) REFERENCES trains(train_id), 
  FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Creating a sequence for Transaction table:

CREATE SEQUENCE payment_id
  MINVALUE 1245001
  START WITH 1245001
  INCREMENT BY 1
  NOCACHE;


CREATE TABLE payments (
  payment_id varchar(100), 
  amount Number,
  payment_method_id varchar(500), 
  payment_date timestamp, 
  PRIMARY KEY (payment_id), 
  FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
);

-- Creating a sequence for Tickets :

CREATE SEQUENCE ticket_id
  MINVALUE 300001
  START WITH 300001
  INCREMENT BY 1
  NOCACHE;

CREATE TABLE tickets (
  ticket_id varchar(100), 
  passenger_id varchar(100) NOT NULL, 
  trip_id varchar(100), 
  payment_id varchar(100) Not NULL,
  seat_number varchar(10) NOT NULL, 
  PRIMARY KEY (ticket_id), 
  FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
  FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
);


INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR001', 'Express Train', 'EXP123');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR002', 'Fast Train', 'FST456');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR003', 'Superior Train', 'SUP789');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR004', 'Rapid Train', 'RDP234');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR005', 'Local Train', 'LOC567');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR006', 'Shinkansen Train', 'SHK890');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR007', 'Regional Train', 'REG123');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR008', 'Bullet Train', 'BLT456');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR009', 'High-Speed Train', 'HST789');
INSERT INTO trains (train_id, train_name, train_code) VALUES ('TR010', 'Intercity Train', 'ITC234');

-- Inserting the values in stations table
INSERT INTO stations (station_id, name, address) VALUES ('ST001', 'Kennedy Station', 'Scarborough, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST002', 'Victoria Park Station', 'Scarborough, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST003', 'Woodbine Station', 'Woodbine Street, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST004', 'Greenwood Station', 'East York, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST005', 'Pape Station', 'Toronto Downtown, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST006', 'Broadview Station', 'Toronto Downtown, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST007', 'Sherbourne Station', 'Toronto Downtown, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST008', 'Bay Station', 'Toronto Downtown, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST009', 'Spadina Station', 'Toronto Downtown, ON');
INSERT INTO stations (station_id, name, address) VALUES('ST010', 'Kipling Station', 'Toronto Downtown, ON');

INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R001', 'ST001', 'ST003', 20);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R002', 'ST002', 'ST005', 800);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R003', 'ST003', 'ST001', 20);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R004', 'ST004', 'ST007', 1000);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R005', 'ST005', 'ST002', 800);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R006', 'ST006', 'ST009', 200);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R007', 'ST007', 'ST004', 1000);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R008', 'ST008', 'ST010', 500);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R009', 'ST009', 'ST006', 200);
INSERT INTO routes (route_id, departure_station_id, arrival_station_id, distance) VALUES ('R010', 'ST010', 'ST008', 500);

INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P001', 'john.doe@example.com', 'John Doe', '+1-555-1234', '123 Main St, Anytown, USA');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P002', 'jane.doe@example.com', 'Jane Doe', '+1-555-5678', '456 Elm St, Anytown, USA');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P003', 'bob.smith@example.com', 'Bob Smith', '+44-20-1234567', '123 Oxford St, London, UK');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P004', 'alice.chang@example.com', 'Alice Chang', '+81-3-1234-5678', '456 Shibuya, Tokyo, Japan');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P005', 'mohammed.ahmed@example.com', 'Mohammed Ahmed', '+91-11-12345678', '123 Khan Market, New Delhi, India');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P006', 'maria.garcia@example.com', 'Maria Garcia', '+34-91-1234567', '456 Gran Vía, Madrid, Spain');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P007', 'peter.hansen@example.com', 'Peter Hansen', '+45-33-123456', '123 Strøget, Copenhagen, Denmark');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P008', 'francesca.rossi@example.com', 'Francesca Rossi', '+39-06-1234567', '456 Via del Corso, Rome, Italy');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P009', 'hans.mueller@example.com', 'Hans Müller', '+49-30-1234567', '123 Unter den Linden, Berlin, Germany');
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P010', 'josephine.nguyen@example.com', 'Josephine Nguyen', '+1-415-1234567', '456 Market St, San Francisco, USA');

INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM001', 'Credit Card', 'Visa ending in 1234', 'P001');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM002', 'PayPal', 'johndoe@example.com', 'P002');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM003', 'Bank Transfer', 'IBAN: DE12345678901234567890', 'P003');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM004', 'Credit Card', 'MasterCard ending in 5678', 'P004');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM005', 'PayPal', 'janedoe@example.com', 'P005');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM006', 'Bank Transfer', 'IBAN: GB12345678901234567890', 'P006');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM007', 'Credit Card', 'American Express ending in 9012', 'P007');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM008', 'PayPal', 'johndoe@example.com', 'P008');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM009', 'Bank Transfer', 'IBAN: JP1234567890123456', 'P009');
INSERT INTO payment_method (payment_method_id, method_type, description, passenger_id) VALUES ('PM010', 'Credit Card', 'Discover ending in 3456', 'P010');

INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T001', 'TR001', 'R001', TO_TIMESTAMP('2023-05-16 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-16 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 50);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T002', 'TR002', 'R002', TO_TIMESTAMP('2023-05-17 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 120, 70);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T003', 'TR003', 'R003', TO_TIMESTAMP('2023-05-18 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-18 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 80, 30);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T004', 'TR004', 'R004', TO_TIMESTAMP('2023-05-19 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 150, 100);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T005', 'TR005', 'R005', TO_TIMESTAMP('2023-05-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 200, 120);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T006', 'TR006', 'R006', TO_TIMESTAMP('2023-05-21 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-21 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 60);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T007', 'TR007', 'R007', TO_TIMESTAMP('2023-05-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-22 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 120, 70);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T008', 'TR008', 'R008', TO_TIMESTAMP('2023-05-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 80, 50);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T009', 'TR009', 'R009', TO_TIMESTAMP('2023-05-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-24 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 150, 100);
INSERT INTO trips (trip_id, train_id, route_id, departure_date, arrival_date, capacity, availabile_capacity) VALUES ('T010', 'TR010', 'R010', TO_TIMESTAMP('2023-05-25 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-25 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 60);

INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 10, 'PM001', TO_TIMESTAMP('2023-05-11 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 12, 'PM002', TO_TIMESTAMP('2023-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 15, 'PM003', TO_TIMESTAMP('2023-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 18, 'PM004', TO_TIMESTAMP('2023-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 20, 'PM005', TO_TIMESTAMP('2023-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 24, 'PM006', TO_TIMESTAMP('2023-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 20, 'PM007', TO_TIMESTAMP('2023-05-13 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 12, 'PM008', TO_TIMESTAMP('2023-05-13 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 15, 'PM009', TO_TIMESTAMP('2023-05-13 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 18, 'PM010', TO_TIMESTAMP('2023-05-14 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Using the sequence to create a ticket id

INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P001', 'T001', 1245001,  'A1');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P002', 'T002', 1245002, 'B2');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P003', 'T003', 1245003, 'C3');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P004', 'T004', 1245004, 'D4');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P005', 'T005', 1245005, 'E5');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P006', 'T006', 1245006,  'F6');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P007', 'T007', 1245007,  'G7');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P008', 'T008', 1245008,  'H8');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P009', 'T009', 1245009,  'I9');
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P010', 'T010', 1245010, 'J10');

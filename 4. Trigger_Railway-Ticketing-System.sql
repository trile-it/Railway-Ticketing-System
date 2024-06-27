-- First Trigger : Decrease the available capacity:
CREATE OR REPLACE TRIGGER decrease_available_capacity
AFTER INSERT ON tickets
FOR EACH ROW
BEGIN
  UPDATE trips
  SET availabile_capacity = availabile_capacity - 1
  WHERE trip_id = :NEW.trip_id;
END;

-- TEST FIRST TRIGGER
-- Query for getting the available capacity :
select * 
from trips
where trip_id = 'T001';
 
-- CREATE A PASSENGER : 
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P013', 'khanj.doe@example.com', 'Khanjan Rokad', '+1-655-5768', '450 Amberjack St, Anytown, India');
 
select * 
from passengers
where passenger_id = 'P013';
 
-- CREATE A PAYMENT AND TICKET FROM NEW USER : 
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 25, 'PM010', TO_TIMESTAMP('2023-03-14 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P013', 'T001', payment_id.CURRVAL,  'A10');
 
-- Query for checking final available capacity after firing a trigger :
SELECT * 
FROM TRIPS
where trip_id = 'T001';

-- Second Trigger : Prevent the duplicate reservations :
CREATE OR REPLACE TRIGGER prevent_duplicate_reservations
BEFORE INSERT ON tickets
FOR EACH ROW
DECLARE
  lv_booked_seat NUMBER := 0;
BEGIN
  SELECT COUNT(*)
  INTO lv_booked_seat
  FROM tickets
  WHERE trip_id = :NEW.trip_id AND seat_number = :NEW.seat_number;
 
  IF lv_booked_seat > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Seat ' || :NEW.seat_number || ' is already reserved for this trip.');
  END IF;
END;
/
-- TEST SECOND TRIGGER
-- CREATE A PASSENGER:
INSERT INTO passengers (passenger_id, email, name, phone, address) VALUES ('P014', 'alex.doe@example.com', 'Alex Doe', '+1-555-555-5555', '450 Amberjack St, Anytown, India');
 
-- CREATE A PAYMENT FROM NEW USER : 
INSERT INTO payments (payment_id, amount, payment_method_id, payment_date) VALUES (payment_id.NEXTVAL, 25, 'PM010', TO_TIMESTAMP('2023-04-14 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- THIS INSERT STATEMENT WILL GENERATE ERROR 'DUPLICATE RESERVATION':
INSERT INTO tickets (ticket_id, passenger_id, trip_id, payment_id, seat_number) VALUES (ticket_id.NEXTVAL, 'P014', 'T001', payment_id.CURRVAL,  'A10');

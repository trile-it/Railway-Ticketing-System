CREATE OR REPLACE PACKAGE rail_reserve_pkg IS
  -- GLOBAL VARIABLES
  trip_id VARCHAR2(10) := 'T001';
  trip_details VARCHAR2(500) := '';
 
  -- Type definition
  TYPE trip_info_type IS RECORD (
	trip_id trips.trip_id%TYPE,
	train_code trains.train_code%TYPE,
  departure_station stations.name%TYPE,
	arrival_station stations.name%TYPE,
	distance routes.distance%TYPE,
	departure_date trips.departure_date%TYPE,
	arrival_date trips.arrival_date%TYPE
  );
           
  -- Procedures
  PROCEDURE get_tickets_by_passenger(p_passenger_id IN VARCHAR2);
  
  PROCEDURE get_trips_by_date(p_departure_date IN trips.departure_date%TYPE, p_arrival_date IN trips.arrival_date%TYPE);
 
  -- Functions
  FUNCTION get_trip_details(p_trip_id IN VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION get_upcoming_trips(p_passenger_id IN passengers.passenger_id%TYPE) RETURN SYS_REFCURSOR;
           
  -- TEST EVERYTHING PROCEDURE
  PROCEDURE test_everything;
END rail_reserve_pkg;
/
CREATE OR REPLACE PACKAGE BODY rail_reserve_pkg IS
  -- PRIVATE VARIABLES
  pv_trip_info trip_info_type;
  passenger_id passengers.passenger_id%TYPE := 'P001';
 
  -- PROCEDURE 1:
  PROCEDURE get_tickets_by_passenger(p_passenger_id IN VARCHAR2)
  IS
		is_found_rec BOOLEAN := false;
		CURSOR cur_tickets(p_passenger_id VARCHAR2) IS
  		SELECT ticket_id, trip_id, seat_number
  		FROM tickets
  		WHERE passenger_id = p_passenger_id;
		departure_station stations.name%TYPE;
		arrival_station stations.name%TYPE;
		distance routes.distance%TYPE;
		departure_date trips.departure_date%TYPE;
		arrival_date trips.arrival_date%TYPE;
  BEGIN
		FOR rec_ticket IN cur_tickets(p_passenger_id) LOOP
  		is_found_rec := true;
  		SELECT s1.name AS departure_station, s2.name AS arrival_station, r.distance, t.departure_date, t.arrival_date
  		INTO departure_station, arrival_station, distance, departure_date, arrival_date
  		FROM trips t
  		JOIN routes r ON t.route_id = r.route_id
  		JOIN stations s1 ON r.departure_station_id = s1.station_id
  		JOIN stations s2 ON r.arrival_station_id = s2.station_id
  		WHERE trip_id = rec_ticket.trip_id;

  		DBMS_OUTPUT.PUT_LINE(
  	  	'Ticket ID: ' || rec_ticket.ticket_id
  	  	|| ', Trip ID: ' || rec_ticket.trip_id
  	  	|| ', Departure Station: ' || departure_station
  	  	|| ', Arrival Station: ' || arrival_station
  	  	|| ', Distance: ' || distance
  	  	|| ', Departure Date: ' || departure_date
  	  	|| ', Arrival Date: ' || arrival_date
  	  	|| ', Seat Number: ' || rec_ticket.seat_number
  		);
		END LOOP;
		IF NOT is_found_rec THEN
  		DBMS_OUTPUT.PUT_LINE('No ticket found for passenger: ' || p_passenger_id);
		END IF;
  	EXCEPTION
		WHEN OTHERS THEN
  		DBMS_OUTPUT.PUT_LINE('Error retrieving tickets for passenger: ' || p_passenger_id || ' - ' || SQLERRM);
  END;
           
  -- PROCEDURE 2:
  PROCEDURE get_trips_by_date(
		p_departure_date IN trips.departure_date%TYPE,
		p_arrival_date IN trips.arrival_date%TYPE
  ) IS
		is_found_rec BOOLEAN := false;
		CURSOR cur_trips IS
  		SELECT trip_id, departure_date, arrival_date
  		FROM trips
  		WHERE departure_date >= p_departure_date AND arrival_date <= p_arrival_date;
		departure_station stations.name%TYPE;
		arrival_station stations.name%TYPE;
		distance routes.distance%TYPE;
  BEGIN
		FOR rec_trip IN cur_trips LOOP
  		is_found_rec := true;
  		SELECT s1.name AS departure_station, s2.name AS arrival_station, r.distance
  		INTO departure_station, arrival_station, distance
  		FROM trips t
  		JOIN routes r ON t.route_id = r.route_id
  		JOIN stations s1 ON r.departure_station_id = s1.station_id
  		JOIN stations s2 ON r.arrival_station_id = s2.station_id
  		WHERE trip_id = rec_trip.trip_id;

  		DBMS_OUTPUT.PUT_LINE(
  	  	'Trip ID: ' || rec_trip.trip_id
  	  	|| ', Departure Station: ' || departure_station
  	  	|| ', Arrival Station: ' || arrival_station
  	  	|| ', Distance: ' || distance
  	  	|| ', Departure Date: ' || rec_trip.departure_date
  	  	|| ', Arrival Date: ' || rec_trip.arrival_date
  		);
		END LOOP;
		IF NOT is_found_rec THEN
  		DBMS_OUTPUT.PUT_LINE('No data found for trips within date range: ' || p_departure_date || ' - ' || p_arrival_date);
		END IF;
  	EXCEPTION
		WHEN OTHERS THEN
  		DBMS_OUTPUT.PUT_LINE('Error retrieving trips within date range: ' || p_departure_date || ' - ' || p_arrival_date || ' - ' || SQLERRM);
  END;
 
  -- FUNCTION 1:
  FUNCTION get_trip_details(p_trip_id IN VARCHAR2)
  RETURN VARCHAR2
  IS
		departure_station stations.name%TYPE;
		arrival_station stations.name%TYPE;
		departure_date trips.departure_date%TYPE;
		arrival_date trips.arrival_date%TYPE;
		lv_details VARCHAR2(500);
  BEGIN
		SELECT
  		s1.name, s2.name, t.departure_date, t.arrival_date
		INTO departure_station, arrival_station, departure_date, arrival_date
		FROM trips t
		JOIN trains tr ON t.train_id = tr.train_id
		JOIN routes r ON t.route_id = r.route_id
		JOIN stations s1 ON r.departure_station_id = s1.station_id
		JOIN stations s2 ON r.arrival_station_id = s2.station_id
		WHERE t.trip_id = p_trip_id;
  	         
  	lv_details :=  departure_station || ' to ' || arrival_station || ' (' || to_char(departure_date, 'YYYY-MM-DD HH24:MI:SS')
  	|| ' to ' || to_char(arrival_date, 'YYYY-MM-DD HH24:MI:SS') || ')';
		RETURN lv_details;
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
  		DBMS_OUTPUT.PUT_LINE('Trip NOT FOUND.');
  		RETURN NULL;
		WHEN OTHERS THEN
  		DBMS_OUTPUT.PUT_LINE('Error in get_trip_details function: ' || SQLERRM);
  		RETURN NULL;
  END;
 
  -- FUNCTION 2:
  FUNCTION get_upcoming_trips(p_passenger_id IN passengers.passenger_id%TYPE)
  RETURN SYS_REFCURSOR
  IS
		cur_upcoming_trips SYS_REFCURSOR;
  BEGIN
		OPEN cur_upcoming_trips FOR
  		SELECT t.trip_id, tr.train_code, s1.name AS departure_station, s2.name AS arrival_station, r.distance, t.departure_date, t.arrival_date
  		FROM trips t
  		JOIN trains tr ON t.train_id = tr.train_id
  		JOIN routes r ON t.route_id = r.route_id
  		JOIN stations s1 ON r.departure_station_id = s1.station_id
  		JOIN stations s2 ON r.arrival_station_id = s2.station_id
  		JOIN tickets tk ON t.trip_id = tk.trip_id
  		WHERE tk.passenger_id = p_passenger_id
  	  	AND t.departure_date > SYSTIMESTAMP
  		ORDER BY t.departure_date ASC;
		RETURN cur_upcoming_trips;
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
  		DBMS_OUTPUT.PUT_LINE('No upcoming trips found for passenger ' || p_passenger_id);
  		RETURN NULL;
		WHEN OTHERS THEN
  		DBMS_OUTPUT.PUT_LINE('Error in get_upcoming_trips function: ' || SQLERRM);
  		RETURN NULL;
  END;
 
  PROCEDURE test_everything IS
		cur_upcoming_trips SYS_REFCURSOR;
  BEGIN
		-- TEST PROCEDURES
		get_tickets_by_passenger('P010');
		get_trips_by_date(TO_TIMESTAMP('2023-05-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2023-05-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
 	
		-- TEST FUNCTIONS
		-- TEST get_trip_details
		trip_details := get_trip_details(trip_id);
  	 
		IF trip_details IS NULL THEN
  		DBMS_OUTPUT.PUT_LINE('Trip details NOT FOUND');
		ELSE
  		DBMS_OUTPUT.PUT_LINE('Trip details: ' || trip_details);
		END IF;
 	
		-- TEST get_upcoming_trips
		DBMS_OUTPUT.PUT_LINE('Upcoming trips for passenger: ' || passenger_id);
 	
		cur_upcoming_trips := get_upcoming_trips(passenger_id);
  	 
		LOOP
  		FETCH cur_upcoming_trips INTO pv_trip_info;
  		EXIT WHEN cur_upcoming_trips%NOTFOUND;
  		DBMS_OUTPUT.PUT_LINE(
  	  	'Trip ID: ' || pv_trip_info.trip_id
  	  	|| ', Train Code: ' || pv_trip_info.train_code
  	  	|| ', Departure Station: ' || pv_trip_info.departure_station
  	  	|| ', Arrival Station: ' || pv_trip_info.arrival_station
  	  	|| ', Distance: ' || pv_trip_info.distance
  	  	|| ', Departure Date: ' || pv_trip_info.departure_date
  	  	|| ', Arrival Date: ' || pv_trip_info.arrival_date
  		);
		END LOOP;
  	 
		CLOSE cur_upcoming_trips;
  END;
END rail_reserve_pkg;
/
BEGIN
  rail_reserve_pkg.test_everything;
END;

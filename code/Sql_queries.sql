select top 10 * from bookings
select top 10 * from passengers 
select top 10 * from passenger_ssr
select top 10 * from passenger_fees
select top 10 * from payments
select top 10 * from flights
select top 10* from flight_status
select top 10 * from airlines


--Updating the family number to correct count:

UPDATE Passengers
SET family_number = FLOOR(RAND(CHECKSUM(NEWID())) * 4);

select  * from passengers


--- Updating DiscountCode values form NONE to null:

UPDATE passengers 
SET discount_code =null
where discount_code = 'NONE'

select  * from passengers


--- Updating SSR code & SSR detail:

UPDATE passenger_ssr
SET ssr_detail =
    CASE ssr_code
        WHEN 'BULK' THEN 'Bulkhead'
        WHEN 'SEAT' THEN 'Seat Selection'
        WHEN 'WCHR' THEN 'Wheelchair'
        WHEN 'NVML' THEN 'Non Veg Meal'
        WHEN 'MED' THEN 'Medical'
        WHEN 'EXBG' THEN 'Extra Baggage'
        WHEN 'LOUNGE' THEN 'Lounge Access'
        WHEN 'VGML' THEN 'Veg Meal'
        WHEN 'INS' THEN 'Insurance'
        WHEN 'ENT' THEN 'Entertainment'
        WHEN 'UMNR' THEN 'Unaccompanied Minor'
        WHEN 'WIFI' THEN 'WiFi'
        WHEN 'PET' THEN 'Pet'
        WHEN 'VIP' THEN 'VIP Service'
        WHEN 'XL' THEN 'Extra Legroom'
        WHEN 'PRIO' THEN 'Priority Boarding'
        WHEN 'BASS' THEN 'Bassinet'
        WHEN 'INF' THEN 'Infant'
        WHEN 'FAST' THEN 'Fast Track'
        WHEN 'SPORT' THEN 'Sports Equipment'
        ELSE ssr_detail
    END;

	select * from passenger_ssr



	---- Creating a Stored Procedure for combining columns from all tabels and 
	---- extracting full name from bookings tabel & source & destination from 
	----- flights table:


	alter PROCEDURE proc_booking_info
AS
BEGIN

    SELECT 
        b.booking_id,
        b.createdUTC,
        p.pax_id,p.first_name,p.middle_name,p.last_name,
		    p.DOB,
            s.ssr_code,
            s.ssr_detail,
            y.payment_method_type,
            y.payment_method_code,
            fi.flight_no,
            fi.route,
            fi.airline_code,
            fs.flight_id,
            fs.flight_date,
            fs.delay_minutes,
            fs.cancelled,
            a.airline_name
       
    FROM bookings b
    JOIN passengers p 
        ON b.booking_id = p.booking_id
    JOIN passenger_ssr s 
        ON p.pax_id = s.pax_id
    JOIN passenger_fees f 
        ON p.pax_id = f.pax_id
    JOIN payments y 
        ON f.payment_id = y.payment_id
    JOIN flight_status fs 
        ON p.pax_id = fs.pax_id
    JOIN flights fi 
        ON fs.flight_id = fi.flight_id
    JOIN airlines a 
        ON fi.airline_code = a.airline_code;

END;




----  As there is no column as full name intable 
---- hence creating cte to concatenate names



alter PROCEDURE proc_booking_details
AS
BEGIN

    ;WITH base AS (
        SELECT 
            b.booking_id,
            b.createdUTC,
            p.pax_id,

            -- Build full_name here (since it does NOT exist in table)
            LTRIM(RTRIM(
                ISNULL(p.first_name, '') + ' ' +
                ISNULL(p.middle_name, '') + ' ' +
                ISNULL(p.last_name, '')
            )) AS full_name,

            p.DOB,
            s.ssr_code,
            s.ssr_detail,
            y.payment_method_type,
            y.payment_method_code,
            fi.flight_no,
            fi.route,
            fi.airline_code,
            fs.flight_id,
            fs.flight_date,
            fs.delay_minutes,
            fs.cancelled,
            a.airline_name

        FROM bookings b
        JOIN passengers p 
            ON b.booking_id = p.booking_id
        JOIN passenger_ssr s 
            ON p.pax_id = s.pax_id
        JOIN passenger_fees f 
            ON p.pax_id = f.pax_id
        JOIN payments y 
            ON f.payment_id = y.payment_id
        JOIN flight_status fs 
            ON p.pax_id = fs.pax_id
        JOIN flights fi 
            ON fs.flight_id = fi.flight_id
        JOIN airlines a 
            ON fi.airline_code = a.airline_code
    )

    SELECT 
        booking_id,
        createdUTC,
        pax_id,
        full_name,

        -- First Name
        SUBSTRING(full_name, 1, 
            CASE 
                WHEN PATINDEX('% %', full_name) > 0 
                THEN PATINDEX('% %', full_name) - 1 
                ELSE LEN(full_name)
            END
        ) AS first_name,

        -- Middle Name
        SUBSTRING(
            full_name,
            PATINDEX('% %', full_name) + 1,
            CASE 
                WHEN LEN(full_name) - LEN(REPLACE(full_name, ' ', '')) >= 2
                THEN PATINDEX('% %', SUBSTRING(full_name, PATINDEX('% %', full_name) + 1, LEN(full_name))) - 1
                ELSE 0
            END
        ) AS middle_name,

        -- Last Name
        SUBSTRING(
            full_name,
            LEN(full_name) - PATINDEX('% %', REVERSE(full_name)) + 2,
            LEN(full_name)
        ) AS last_name,

        DOB,
        ssr_code,
        ssr_detail,
        payment_method_type,
        payment_method_code,
        flight_no,
        route,

        -- Route Source
        SUBSTRING(route, 1, PATINDEX('%-%', route) - 1) AS route_source,


		-- Route Destination (last airport)
 SUBSTRING(
    route,
    LEN(route) - PATINDEX('%-%', REVERSE(route)) + 2,
    LEN(route)
) AS route_destination,

        airline_code,
        flight_id,
        flight_date,
        delay_minutes,
        cancelled,
        airline_name



    FROM base


END;
Create table EVENT
(
EVENT_ID number(5) not null primary key,
EVENT_NAME varchar2(100) not null,
EVENT_RATE number(5) not null
);
Create table ARTIST
(
ARTIST_ID varchar2(5) not null primary key,
ARTIST_NAME varchar2(100) not null,
ARTIST_EMAIL varchar2(100) not null
);
Create table BOOKINGS
(
BOOKING_ID number not null primary key,
BOOKING_DATE date not null,
EVENT_ID number(5) not null,
ARTIST_ID varchar2(5) not null,
FOREIGN KEY (EVENT_ID) REFERENCES EVENT(EVENT_ID),
FOREIGN KEY (ARTIST_ID) REFERENCES ARTIST(ARTIST_ID)
);


insert all
into EVENT(EVENT_ID, EVENT_NAME, EVENT_RATE)
values(1001, 'Open Air Comedy Festival', 300)
into EVENT(EVENT_ID, EVENT_NAME, EVENT_RATE)
values(1002, 'Mountain Side Music Festival', 380)
into EVENT(EVENT_ID, EVENT_NAME, EVENT_RATE)
values(1003, 'Beach Music Festival', 195)
Select * from dual;
Commit;

insert all
into ARTIST(ARTIST_ID, ARTIST_NAME, ARTIST_EMAIL)
values('A_101', 'Max Trillion', 'maxt@isat.com')
into ARTIST(ARTIST_ID, ARTIST_NAME, ARTIST_EMAIL)
values('A_102', 'Music Mayhem', 'mayhem@ymail.com')
into ARTIST(ARTIST_ID, ARTIST_NAME, ARTIST_EMAIL)
values('A_103', 'LOL Man', 'lol@isat.com')
Select * from dual;
Commit;
insert all
into BOOKINGS(BOOKING_ID, BOOKING_DATE, EVENT_ID, ARTIST_ID)
values(1, '15 July 2024', 1002, 'A_101')
into BOOKINGS(BOOKING_ID, BOOKING_DATE, EVENT_ID, ARTIST_ID)
values(2, '15 July 2024', 1002, 'A_102')
into BOOKINGS(BOOKING_ID, BOOKING_DATE, EVENT_ID, ARTIST_ID)
values(3, '27 August 2024', 1001, 'A_103')
into BOOKINGS(BOOKING_ID, BOOKING_DATE, EVENT_ID, ARTIST_ID)
values(4, '30 August 2024', 1003, 'A_101')
into BOOKINGS(BOOKING_ID, BOOKING_DATE, EVENT_ID, ARTIST_ID)
values(5, '30 August 2024', 1003, 'A_102')

Select * from dual;
Commit; 
 
SELECT * FROM  EVENT; 
SELECT * FROM ARTIST; 
SELECT * FROM BOOKINGS ; 
 
   
--Question 1 -- 
SELECT B.BOOKING_ID,B.BOOKING_DATE,E.EVENT_NAME,E.EVENT_RATE,A.ARTIST_NAME,A.ARTIST_EMAIL
FROM EVENT E 
JOIN BOOKINGS B 
ON e.event_id=b.event_id 
JOIN  ARTIST A 
ON a.artist_id=b.artist_id; 
 
  
   
--Questionn 2 --
SELECT A.ARTIST_NAME , COUNT(b.event_id) AS PERFORMANCES 
FROM ARTISTS A 
JOIN BOOKINGS B 
ON A.ARTIST_ID=B.ARTIST_ID 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 --Question 3-- 
 SELECT A.ARTIST_NAME,SUM(E.EVENT_RATE) AS Revenue 
 FROM ARTIST A 
 JOIN bookings B 
 ON A.ARTIST_ID=B.ARTIST_ID 
 JOIN EVENT E  
 ON e.event_id=b.event_id 
 GROUP BY A.ARTIST_NAME;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
--QUESTION 4 -- 
DECLARE CURSOR ARTIST_CURSOR IS  
SELECT A.ARTIST_NAME,B.BOOKING_DATE 
FROM ARTIST A 
JOIN BOOKINGS B 
ON A.ARTIST_ID=B.ARTIST_ID 
WHERE B.EVENT_ID =1001;  
--Variable Declaration --
V_ARTIST_NAME ARTIST.ARTIST_NAME%TYPE; 
V_BOOKING_DATE DATE ; 
BEGIN 
OPEN ARTIST_CURSOR; 
LOOP 
FETCH ARTIST_CURSOR INTO V_ARTIST_NAME,V_BOOKING_DATE ; 
EXIT WHEN ARTIST_CURSOR  %NOTFOUND; 
 
 --OUTPUT--
DBMS_OUTPUT.PUT_LINE('Artist Name : '||V_ARTIST_NAME); 
DBMS_OUTPUT.PUT_LINE('Booking Date : '||V_BOOKING_DATE); 
DBMS_OUTPUT.PUT_LINE('----------------------------------'); 
END LOOP ; 
CLOSE ARTIST_CURSOR; 
END; 
 
--Question 5 -- 
DECLARE CURSOR EVENT_DISCOUNT_CURSOR IS 
SELECT E.EVENT_NAME,E.EVENT_RATE 
FROM EVENT E  
WHERE E.EVENT_RATE >250; 
-- DECLARE VARIABLES HERE -- 
V_EVENT_NAME EVENT.EVENT_NAME%TYPE; 
V_EVENT_RATE EVENT.EVENT_RATE%TYPE; 
V_EVENT_DISCOUNT NUMBER(10,2);
V_DISCOUNTED_PRICE NUMBER(10,2); 
BEGIN 
OPEN EVENT_DISCOUNT_CURSOR ; 
LOOP 
FETCH EVENT_DISCOUNT_CURSOR INTO V_EVENT_NAME ,V_EVENT_RATE; 
EXIT WHEN EVENT_DISCOUNT_CURSOR %NOTFOUND; 
 --Calculate Discounts -- 
 V_EVENT_DISCOUNT :=V_EVENT_RATE * 0.10; 
 V_DISCOUNTED_PRICE :=V_EVENT_RATE-V_EVENT_DISCOUNT;
--Output -- 
DBMS_OUTPUT.PUT_LINE('EVENT Name : '||V_EVENT_NAME ); 
DBMS_OUTPUT.PUT_LINE('Pre Discounted Price : R'||V_EVENT_RATE); 
DBMS_OUTPUT.PUT_LINE('Discount Amount : R'||V_EVENT_DISCOUNT); 
DBMS_OUTPUT.PUT_LINE('Discounted Price : R'||V_DISCOUNTED_PRICE ); 
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
END LOOP ; 
CLOSE  EVENT_DISCOUNT_CURSOR; 
END; 
 
--Question 6-- 
CREATE VIEW EVENT_SCHEDULES AS 
SELECT E.EVENT_NAME 
FROM EVENT E   
JOIN BOOKINGS B  
ON E.EVENT_ID=B.EVENT_ID 
WHERE B.BOOKING_DATE BETWEEN '1-JUL-24' AND '28-AUG-24'; 
SELECT * FROM EVENT_SCHEDULES; 
 
  
--Question 7 -- 
CREATE OR REPLACE PROCEDURE ARTIST_CONCERTS(
P_ARTIST_NAME ARTIST.ARTIST_NAME%TYPE) IS 
 CURSOR ARTIST_DETAILS IS 
SELECT A.ARTIST_NAME,B.BOOKING_ID,B.BOOKING_DATE,B.EVENT_ID,B.ARTIST_ID 
FROM ARTIST A 
JOIN BOOKINGS B 
ON A.ARTIST_ID=B.ARTIST_ID 
WHERE P_ARTIST_NAME=A.ARTIST_NAME ;  
V_ARTIST_NAME ARTIST.ARTIST_NAME%TYPE;
V_BOOKING_ID BOOKINGS.BOOKING_ID%TYPE; 
V_BOOKING_DATE BOOKINGS.BOOKING_DATE%TYPE; 
V_EVENT_ID BOOKINGS.EVENT_ID%TYPE; 
V_ARTIST_ID BOOKINGS.ARTIST_ID%TYPE; 
 
 BEGIN 
 OPEN ARTIST_DETAILS; 
 LOOP 
 FETCH ARTIST_DETAILS INTO V_ARTIST_NAME, V_BOOKING_ID,V_BOOKING_DATE,V_EVENT_ID ,V_ARTIST_ID; 
 EXIT WHEN ARTIST_DETAILS %NOTFOUND; 
  DBMS_OUTPUT.PUT_LINE('Artist Name :  '||V_ARTIST_NAME); 
  DBMS_OUTPUT.PUT_LINE('BOOKING ID : '||V_BOOKING_ID);  
  DBMS_OUTPUT.PUT_LINE('BOOKING DATE : '||V_BOOKING_DATE); 
DBMS_OUTPUT.PUT_LINE('EVENT ID : '||V_EVENT_ID); 
 DBMS_OUTPUT.PUT_LINE('ARTIST ID : '||V_ARTIST_ID); 
 DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
  END LOOP ; 
  CLOSE ARTIST_DETAILS; 
  END ; 
  EXEC ARTIST_CONCERTS('Max Trillion');
 DROP PROCEDURE ARTIST_CONCERTS;
 --Question 8-- 
 CREATE OR REPLACE FUNCTION totalConcerts 
 (P_ARTIST_ID IN  BOOKINGS.ARTIST_ID%TYPE )
 return number is 
 TOTAL_CONCERTS NUMBER; 
 BEGIN  
 SELECT COUNT(EVENT_ID)INTO TOTAL_CONCERTS
 FROM BOOKINGS  
 
 
  RETURN TOTAL_concerts; 
  END ; 
   
DECLARE  
P_ARTIST_ID(A_101); 
BEGIN 
P_ARTIST_ID := totalConcerts ()
   
   DROP FUNCTION   totalConcerts   ;
  --QUESTION 9 -- 
  --Question 10 --  
  --Scalar Data types can be describes as a data type that takes one value -- 
  --EXAMPLES INCLUDE iNTERGER WHICH CONTAINS WHOLE NUMBERS -- 
  --Boolee can be represented as either true or false -- 
  -- Char represents a single letter or digit -- 
  -- Date represents on particular day on the calender -- 
   
-- Question 11-- 
CREATE OR REPLACE TRIGGER TRG_PREVENT_INVALID_BOOKING IS 
BEFORE INSERT IN BOOKINGS 
FOR EACH ROW  
V_BOOKING_DATE BOOKINGS.BOOKING_DATE%TYPE;
BEGIN 
IF V_BOOKING_DATE NOT BETWEEN '15-JUL-24' AND '30-JUL-24' 
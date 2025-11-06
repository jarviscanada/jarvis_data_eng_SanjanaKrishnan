# Introduction

This project focuses on building a strong foundation in SQL through hands-on exercises and data modeling tasks. The main goal is to understand how to query and manipulate relational databases using DDL, DML, and DQL commands. As part of the BSA stream, all SQL queries were practiced and tested using an online SQL learning platform (pgexercises.com) rather than a local PostgreSQL setup. Through a series of structured problems, the project covers CRUD operations, joins, aggregations, and subqueries that simulate real-world data analysis scenarios. By completing these exercises, I developed practical SQL skills essential for working with data in business systems and analytics environments.

# SQL Queries

###### Table Setup

```sql
CREATE SCHEMA IF NOT EXISTS cd;

CREATE TABLE IF NOT EXISTS cd.members (
  memid INTEGER NOT NULL PRIMARY KEY, 
  surname VARCHAR(200) NOT NULL, 
  firstname VARCHAR(200) NOT NULL, 
  address VARCHAR(300) NOT NULL, 
  zipcode INTEGER NOT NULL, 
  telephone VARCHAR(20) NOT NULL, 
  recommendedby INTEGER, 
  joindate TIMESTAMP NOT NULL, 
  CONSTRAINT fk_recommendedby FOREIGN KEY (recommendedby) REFERENCES cd.members (memid) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cd.facilities (
  facid INTEGER NOT NULL PRIMARY KEY, 
  name VARCHAR(100) NOT NULL, 
  membercost NUMERIC NOT NULL, 
  guestcost NUMERIC NOT NULL, 
  initialoutlay NUMERIC NOT NULL, 
  monthlymaintenace NUMERIC NOT NULL
);

CREATE TABLE IF NOT EXISTS cd.bookings (
  bookid INTEGER NOT NULL PRIMARY KEY, 
  facid INTEGER NOT NULL REFERENCES cd.facilities (facid), 
  membid INTEGER NOT NULL REFERENCES cd.members (memid), 
  starttime TIMESTAMP NOT NULL, 
  slots INTEGER NOT NULL, 
  );
```

###### Modifying data

###### Question 1: Insert some data into facilities table

```sql
INSERT INTO cd.facilities 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);

```

###### Question 2: Insert calculated data into a table

```sql
INSERT INTO cd.facilities 
VALUES 
  (
    (
      SELECT 
        MAX(facid)+ 1 
      FROM 
        cd.facilities
    ), 
    'Spa', 
    20, 
    30, 
    100000, 
    800
  );
```

###### Question 3: Update some existing data

```sql
UPDATE 
  cd.facilities 
SET 
  initialoutlay = 10000 
WHERE 
  name = 'Tennis Court 2';
```

###### Question 4: Update a row based on the contents of another row

```sql
UPDATE 
  cd.facilities 
SET 
  membercost =(
    SELECT 
      membercost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      name = 'Tennis Court 1'
  ), 
  guestcost =(
    SELECT 
      guestcost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      name = 'Tennis Court 1'
  ) 
WHERE 
  name = 'Tennis Court 2';
```

###### Question 5: Delete all bookings

```sql
DELETE FROM 
  cd.bookings;
```

###### Question 6: Delete a member from the cd.members table

```sql
DELETE FROM 
  cd.members 
WHERE 
  memid = 37
```

###### Question 7: Control which rows are retrieved - part 2

```sql
SELECT 
  facid, 
  name, 
  membercost, 
  monthlymaintenance 
FROM 
  cd.facilities 
WHERE 
  membercost > 0 
  AND membercost <(monthlymaintenance / 50);
```

###### Question 8: Basic string searches

```sql
SELECT 
  * 
FROM 
  cd.facilities 
WHERE 
  name LIKE '%Tennis%'
```

###### Question 9: Matching against multiple values

```sql
SELECT 
  * 
FROM 
  cd.facilities 
WHERE 
  facid IN (1, 5)
```

###### Question 10: Working with dates

```sql
SELECT 
  memid, 
  surname, 
  firstname, 
  joindate 
FROM 
  cd.members 
WHERE 
  joindate >= '2012-09-01';
```

###### Question 11: Combining results from multiple queries

```sql
SELECT 
  surname 
FROM 
  cd.members 
UNION 
SELECT 
  name 
FROM 
  cd.facilities;
```

###### Joins
###### Question 12: Retrieve the start times of members' bookings

```sql
SELECT 
  bks.starttime 
FROM 
  cd.bookings bks 
  INNER JOIN cd.members mems ON bks.memid = mems.memid 
WHERE 
  mems.firstname = 'David' 
  AND mems.surname = 'Farrell';
```

###### Question 13: Start times of bookings for tennis courts
```sql
SELECT 
  bks.starttime AS start, 
  fas.name 
FROM 
  cd.bookings bks 
  INNER JOIN cd.facilities fas ON bks.facid = fas.facid 
WHERE 
  bks.starttime BETWEEN '2012-09-21' 
  AND '2012-09-22' 
  AND fas.name LIKE '%Tennis Court%' 
ORDER BY 
  bks.starttime;
```

###### Question 14: Produce a list of all members, with their recommender
```sql
SELECT 
  mems.firstname AS memfname, 
  mems.surname AS memsname, 
  recs.firstname AS recfname, 
  recs.surname AS recsname 
FROM 
  cd.members mems 
  LEFT JOIN cd.members recs ON mems.recommendedby = recs.memid 
ORDER BY 
  memsname, 
  memfname;
```

###### Question 15: Produce a list of all members who have recommended another member
```sql
SELECT 
  DISTINCT recs.firstname, 
  recs.surname 
FROM 
  cd.members mems 
  INNER JOIN cd.members recs ON mems.recommendedby = recs.memid 
ORDER BY 
  recs.surname, 
  recs.firstname;
```

###### Question 16: Produce a list of all members, along with their recommender, using no joins

```sql
SELECT 
  DISTINCT mems.firstname || ' ' || mems.surname AS member, 
  (
    SELECT 
      recs.firstname || ' ' || recs.surname AS recommender 
    FROM 
      cd.members recs 
    WHERE 
      recs.memid = mems.recommendedby
  ) 
FROM 
  cd.members mems 
ORDER BY 
  member;
```

###### Aggregation
###### Question 17: Count the number of recommendations each member makes.

```sql
select 
  recommendedby, 
  count(*) 
from 
  cd.members 
where 
  recommendedby is not null 
group by 
  recommendedby 
order by 
  recommendedby;
```

###### Question 18: List the total slots booked per facility

```sql
SELECT 
  facid, 
  SUM(slots) AS "Total Slots" 
FROM 
  cd.bookings 
GROUP BY 
  facid 
ORDER by 
  facid;
```

###### Question 19: List the total slots booked per facility in a given month

```sql
SELECT 
  facid, 
  SUM(slots) AS "Total Slots" 
FROM 
  cd.bookings 
WHERE 
  starttime BETWEEN '2012-09-01' 
  AND '2012-10-01' 
GROUP BY 
  facid 
ORDER BY 
  "Total Slots";
```

###### Question 20: List the total slots booked per facility per month

```sql
SELECT 
  facid, 
  extract(
    month 
    FROM 
      starttime
  ) AS month, 
  SUM(slots) AS "Total Slots" 
FROM 
  cd.bookings 
WHERE 
  extract(
    year 
    FROM 
      starttime
  ) = 2012 
GROUP BY 
  facid, 
  month 
ORDER BY 
  facid, 
  month;
```

###### Question 21: Find the count of members who have made at least one booking

```sql
SELECT 
  COUNT(DISTINCT memid) 
FROM 
  cd.bookings;
```

###### Question 22: List each member's first booking after 2012-09-01

```sql
SELECT 
  surname, 
  firstname, 
  m.memid, 
  min(starttime) 
FROM 
  cd.members m 
  JOIN cd.bookings b ON m.memid = b.memid 
WHERE 
  starttime >= '2012-09-01' 
GROUP BY 
  surname, 
  firstname, 
  m.memid 
ORDER BY 
  m.memid;
```

###### Question 23: Produce a list of member names, with each row containing the total member count

```sql
SELECT 
  COUNT(*) over(), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY 
  joindate;
```

###### Question 24: Produce a numbered list of members

```sql
SELECT 
  ROW_NUMBER() OVER(
    ORDER BY 
      joindate
  ), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY 
  joindate;
```

###### Question 25: Output the facility id that has the highest number of slots booked

```sql
SELECT 
  facid, 
  total 
FROM 
  (
    SELECT 
      facid, 
      SUM(slots) total, 
      RANK() over (
        ORDER BY 
          SUM(slots) DESC
      ) rank 
    FROM 
      cd.bookings 
    GROUP BY 
      facid
  ) AS ranked 
WHERE 
  rank = 1
```

###### String
###### Question 26: Format the names of members

```sql
SELECT 
  surname || ', ' || firstname AS name 
FROM 
  cd.members;
```

###### Question 27: Find telephone numbers with parentheses

```sql
SELECT 
  memid, 
  telephone 
FROM 
  cd.members 
WHERE 
  telephone ~ '[()]';
```

###### Question 28: Count the number of members whose surname starts with each letter of the alphabet

```sql
SELECT 
  SUBSTR(mems.surname, 1, 1) AS letter, 
  COUNT(*) AS count 
FROM 
  cd.members mems 
GROUP BY 
  letter 
ORDER BY 
  letter;
```

# References

- [pgexercises.com](https://pgexercises.com)  for testing SQL queries online.
- [SQLBolt](https://sqlbolt.com/)  SQL learning reference.


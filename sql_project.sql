/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * FROM Facilities WHERE membercost > 0

/* Q2: How many facilities do not charge a fee to members? */

SELECT * FROM Facilities WHERE membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, guestcost, monthlymaintenance FROM Facilities WHERE membercost < monthlymaintenance *0.20

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT facid, name, membercost, guestcost, initialoutlay, monthlymaintenance FROM Facilities WHERE facid = 1 OR facid = 5

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT  name,  monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN EXPENSIVE
     ELSE CHEAP END AS facilitytype
FROM Facilities 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT * FROM Members WHERE joindate is not NULL

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CONCAT( M.firstname, ' ', M.surname ) AS fullname, F.name
FROM Members M
INNER JOIN Bookings B ON M.memid = B.memid
INNER JOIN Facilities F ON B.facid = F.facid
WHERE F.name LIKE 'Tennis court %'
ORDER BY fullname DESC

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT B.facid, F.name, CONCAT( M.firstname, ' ', M.surname ) AS name, F.guestcost * B.slots AS cost
FROM Bookings B
INNER JOIN Members M ON M.memid = B.memid
AND B.starttime LIKE '2012-09-14%'
INNER JOIN Facilities F ON F.facid = B.facid
WHERE B.memid =0
AND F.guestcost * B.slots >30
UNION
SELECT B.facid, F.name, CONCAT( M.firstname, ' ', M.surname ) AS name, F.membercost * B.slots AS cost
FROM Bookings B
INNER JOIN Members M ON M.memid = B.memid
AND B.starttime LIKE '2012-09-14%'
INNER JOIN Facilities F ON F.facid = B.facid
WHERE B.memid >0
AND F.membercost * B.slots >30
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT B.facid, F.name, CONCAT( M.firstname, ' ', M.surname ) AS name, F.guestcost * B.slots AS cost
FROM Bookings B
INNER JOIN Members M ON M.memid = B.memid
AND B.starttime LIKE '2012-09-14%'
INNER JOIN Facilities F ON F.facid = B.facid
WHERE B.memid =0
AND F.guestcost * B.slots >30
UNION
SELECT B.facid, F.name, CONCAT( M.firstname, ' ', M.surname ) AS name, F.membercost * B.slots AS cost
FROM Bookings B
INNER JOIN Members M ON M.memid = B.memid
AND B.starttime LIKE '2012-09-14%'
INNER JOIN Facilities F ON F.facid = B.facid
WHERE B.memid >0
AND F.membercost * B.slots >30
ORDER BY cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT F.name,
CASE WHEN SUM( (
F.guestcost * B.slots
) + ( F.membercost * B.slots ) ) <1000
THEN SUM( (
F.guestcost * B.slots
) + ( F.membercost * B.slots ) )
END AS totalrevenue
FROM Bookings B
JOIN Facilities F ON F.facid = B.facid
GROUP BY F.name
ORDER BY totalrevenue DESC
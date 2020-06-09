-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT CustomerId , FirstName || ' ' || LastName as fullName , Country
FROM customer
WHERE NOT country = 'US';

-- 2. Provide a query only showing the Customers from Brazil.
SELECT *
FROM Customer
WHERE Country = "Brazil"

-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT c.FirstName || ' ' || c.LastName AS FullName, i.InvoiceID, i.InvoiceDate, i.BillingCountry
FROM Customer c 
LEFT JOIN Invoice i
ON c.customerID = i.customerId
WHERE c.country = "Brazil"

-- 4. Provide a query showing only the Employees who are Sales Agents.
SELECT *
FROM Employee
WHERE Title = "Sales Support Agent"

-- 5. Provide a query showing a unique list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM Invoice

-- 6. Provide a query showing the invoices of customers who are from Brazil.
SELECT *
FROM customer c 
LEFT JOIN invoice i 
ON c.customerID = i.customerId
WHERE c.country = "Brazil"


-- 7. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT e.FirstName || ' ' || e.LastName AS FullName, i.invoiceid, i.customerid
FROM customer  c
JOIN invoice i
ON c.customerid = i.customerid
JOIN employee e
ON e.employeeid = c.supportrepid

-- 8. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total, c.FirstName, c.FirstName, c.country, e.FIrstname, e.LastName
FROM employee e
JOIN customer c 
ON e.employeeid = c.supportrepid
JOIN invoice i
ON c.customerid = i.customerid

-- 9. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
SELECT count(invoiceid), sum(total) 
FROM Invoice
WHERE InvoiceDate LIKE '2009%' and '2011%'

-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT count(*)
FROM invoiceLine
WHERE invoiceId = 37
-- 11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)
SELECT invoiceId, COUNT(*)
FROM InvoiceLine
GROUP BY invoiceId

-- 12. Provide a query that includes the track name with each invoice line item.
SELECT t.name, i.*
FROM track t 
JOIN invoiceLine i
ON t.trackId = i.trackId

-- 13. Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT i.*, t.name, a.name
FROM invoiceLine i
LEFT JOIN track t ON i.trackId = t.trackId
JOIN album al ON al.albumId = t.albumId
JOIN artist a ON a.artistId = al.artistId

-- 14. Provide a query that shows the # of invoices per country. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)
SELECT billingcountry, count(billingCountry)
FROM invoice
GROUP BY billingCountry
-- 15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
SELECT pl.trackId , count(pl.trackId), p.name
FROM playlistTrack pl
LEFT JOIN playlist p ON p.playlistId = pl.playlistId
GROUP BY pl.playlistId

-- 16. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT t.name as track, t.composer, t.bytes, t.unitPrice, a.title as albumName, m.name as mediaTypeName, g.name as GenreName
FROM album a
LEFT JOIN  track t ON a.albumId = t.albumId
JOIN mediatype m ON m.mediaTypeId = t.mediaTypeId
JOIN genre g ON g.genreId = t. genreId



-- 17. Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.*, count(il.invoiceLineId)
FROM invoice i 
JOIN invoiceLine il ON i.invoiceId = il.invoiceId 
GROUP BY i.invoiceId
-- 18. Provide a query that shows total sales made by each sales agent.
SELECT e.*, count(i.invoiceId) as 'Total Sales'
FROM employee e 
JOIN customer c ON e.employeeId = c.supportRepId
JOIN invoice i ON c.customerId = i.customerId
GROUP BY c.supportRepID


-- 19. Which sales agent made the most in sales in 2009?
SELECT *, max(total) FROM
(SELECT e.*, round(sum(total), 1) as 'total'
FROM employee e 
JOIN customer c ON e.employeeId = c.supportRepId
JOIN invoice i ON c.customerId = i.customerId
WHERE i.invoicedate BETWEEN '2009-01-00' AND '2009-12-31'
GROUP BY e.employeeid)

-- 20. Which sales agent made the most in sales in 2010?
SELECT *, max(total) FROM
(SELECT e.*, round(sum(total), 2) AS 'total'
FROM employee e 
JOIN customer c ON e.employeeId = c.supportRepId
JOIN invoice i ON c.customerId = i.customerId
WHERE i.invoiceDate BETWEEN '2010-01-00' AND '2010-12-31' 
GROUP BY employeeId
)
-- 21. Which sales agent made the most in sales over all?
SELECT *, max(total) FROM
(SELECT e.*, round(sum(total), 2) AS 'total'
FROM employee e 
JOIN customer c ON e.employeeId = c.supportRepId
JOIN invoice i ON c.customerId = i.customerId
GROUP BY employeeId)

-- 22. Provide a query that shows the # of customers assigned to each sales agent.
SELECT e.firstName as 'salesAgentFirstName', e.LastName AS 'salesAgentLastName', count(c.customerId) AS 'Number of Customers'
FROM employee e 
JOIN customer c ON e.employeeId = c.supportRepId
GROUP BY e.employeeId

-- 23. Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT billingCountry, sum(total) AS 'Total'
FROM invoice
GROUP BY billingCountry
ORDER BY Total DESC

-- 24. Provide a query that shows the most purchased track of 2013.
 
SELECT *, count(t.trackId) AS 'purchasedAmount'
FROM invoiceLine il
LEFT  JOIN invoice i ON il.invoiceId = i.invoiceId
LEFT JOIN track t ON il.trackId = t.trackId
WHERE i.InvoiceDate LIKE '2013%'
GROUP BY il.trackId
ORDER BY purchasedAmount DESC
LIMIT 1;

-- 25. Provide a query that shows the top 5 most purchased tracks over all.


SELECT *, count(t.trackId) AS 'purchasedAmount'
FROM track t 
LEFT JOIN invoiceLine il ON t.trackId = il.trackId
GROUP BY t.trackId    
ORDER BY quantity DESC
LIMIT 5;


-- 26. Provide a query that shows the top 3 best selling artists.
SELECT ar.name, count(il.trackId) AS 'count'
FROM artist AS ar
LEFT JOIN album al ON ar.artistId = al.artistId
LEFT JOIN track t ON al.albumId = t.albumId
LEFT JOIN invoiceLine il ON t.trackId = il.trackId
GROUP BY ar.name
ORDER BY count DESC
LIMIT 3;




-- 27. Provide a query that shows the most purchased Media Type.
SELECT m.name as 'mediaTypeName', count(il.trackId) AS 'count'
FROM mediaType m 
LEFT JOIN track t ON m.mediaTypeId = t.mediaTypeId 
LEFT JOIN invoiceLine il ON il.trackId = t.trackId
GROUP BY mediaTypeName
ORDER BY count DESC
LIMIT 1;
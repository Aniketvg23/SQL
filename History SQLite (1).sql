--- 11-04-2025 16:53:37 SQLite.6

-- 1. Top 5 Customers by Total Purchase Amount
SELECT 
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    ROUND(SUM(i.Total), 2) AS TotalSpent
FROM 
    Invoice i
JOIN 
    Customer c ON i.CustomerId = c.CustomerId
GROUP BY 
    c.CustomerId
ORDER BY 
    TotalSpent DESC
LIMIT 5;

-- 2. Most Popular Genre in Terms of Total Tracks Sold
SELECT 
    g.Name AS Genre,
    COUNT(il.TrackId) AS TracksSold
FROM 
    InvoiceLine il
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.GenreId
ORDER BY 
    TracksSold DESC
LIMIT 1;

-- 3. Employees Who Are Managers Along with Their Subordinates
SELECT 
    m.EmployeeId AS ManagerId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateId,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerId;

-- 4. Most Sold Album for Each Artist
WITH AlbumSales AS (
    SELECT 
        ar.Name AS ArtistName,
        al.Title AS AlbumTitle,
        al.AlbumId,
        COUNT(il.InvoiceLineId) AS TotalSales
    FROM 
        InvoiceLine il
    JOIN 
        Track t ON il.TrackId = t.TrackId
    JOIN 
        Album al ON t.AlbumId = al.AlbumId
    JOIN 
        Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY 
        al.AlbumId
),
Ranked AS (
    SELECT *,
           RANK() OVER(PARTITION BY ArtistName ORDER BY TotalSales DESC) AS rnk
    FROM AlbumSales
)
SELECT 
    ArtistName, 
    AlbumTitle, 
    TotalSales
FROM 
    Ranked
WHERE 
    rnk = 1;

-- 5. Monthly Sales Trends in the Year 2013
SELECT 
    STRFTIME('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Total), 2) AS MonthlySales
FROM 
    Invoice
WHERE 
    STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY 
    Month
ORDER BY 
    Month;




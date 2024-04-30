########### DATABASE
USE `prestigecars`;
###########################
#1
SELECT mk.MakeName, md.ModelName
FROM stock AS st
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE st.DateBought = '2015-07-25';

#2
SELECT distinct mk.MakeName, md.ModelName
FROM stock AS st
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE st.DateBought BETWEEN '2018-07-15' AND '2018-08-31';

#3
SELECT m.MakeName, mo.ModelName, DATEDIFF(s.SaleDate, st.DateBought) AS DaysOnLot
FROM stock st
JOIN model mo ON st.ModelID = mo.ModelID
JOIN make m ON mo.MakeID = m.MakeID
JOIN salesdetails sd ON st.StockCode = sd.StockID
JOIN sales s ON sd.SalesID = s.SalesID
ORDER BY DaysOnLot DESC;

#4
SELECT AVG(DailySpend) AS AverageDailySpend
FROM (
    SELECT DATE(DateBought) AS PurchaseDay, SUM(Cost) AS DailySpend
    FROM stock
    WHERE DateBought BETWEEN '2015-07-01' AND '2015-12-31'
    GROUP BY PurchaseDay
) AS DailySpends;

#5
SELECT DISTINCT mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015;

#6
SELECT DISTINCT mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015
AND EXISTS (
    SELECT 1
    FROM sales AS s2
    JOIN salesdetails AS sd2 ON s2.SalesID = sd2.SalesID
    JOIN stock AS st2 ON sd2.StockID = st2.StockCode
    WHERE st2.ModelID = md.ModelID
    AND YEAR(s2.SaleDate) = 2016
)
ORDER BY mk.MakeName, md.ModelName;

#7
SELECT mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015 AND MONTH(s.SaleDate) = 7;

#8
SELECT mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015 AND MONTH(s.SaleDate) BETWEEN 7 AND 9;

#9
SELECT distinct mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2016 AND DAYOFWEEK(s.SaleDate) = 6;

#10
SELECT mk.MakeName, md.ModelName
FROM sales AS s
JOIN salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN stock AS st ON sd.StockID = st.StockCode
JOIN model AS md ON st.ModelID = md.ModelID
JOIN make AS mk ON md.MakeID = mk.MakeID
WHERE s.SaleDate >= '2017-06-26' AND s.SaleDate <= '2017-07-02';

#11
SELECT 
    DAYOFWEEK(s.SaleDate) AS WeekdayNumber,
    COUNT(*) AS SalesCount
FROM sales s
WHERE YEAR(s.SaleDate) = 2015
GROUP BY DAYOFWEEK(s.SaleDate)
ORDER BY SalesCount DESC;

#12
SELECT 
    DAYNAME(s.SaleDate) AS Weekday,
    COUNT(*) AS SalesCount
FROM sales s
WHERE YEAR(s.SaleDate) = 2015
GROUP BY DAYNAME(s.SaleDate)
ORDER BY SalesCount DESC;

#13
SELECT 
    DATE(s.SaleDate) AS SaleDay,
    SUM(s.TotalSalePrice) AS TotalSales,
    AVG(s.TotalSalePrice) AS AverageSale
FROM sales s
GROUP BY DATE(s.SaleDate)
ORDER BY DATE(s.SaleDate);

#14
SELECT 
    DAY(s.SaleDate) AS DayOfMonth,
    SUM(s.TotalSalePrice) AS TotalSales,
    AVG(s.TotalSalePrice) AS AverageSales
FROM sales s
GROUP BY DAY(s.SaleDate)
ORDER BY DAY(s.SaleDate);

#15
SELECT 
    MONTH(s.SaleDate) AS MonthNumber,
    MONTHNAME(s.SaleDate) AS MonthName,
    COUNT(*) AS VehiclesSold
FROM sales s
WHERE YEAR(s.SaleDate) = 2018
GROUP BY MONTH(s.SaleDate), MONTHNAME(s.SaleDate)
ORDER BY MONTH(s.SaleDate);

#16
SELECT SUM(s.TotalSalePrice) AS AccumulatedSales
FROM sales s
JOIN salesdetails sd ON s.SalesID = sd.SalesID
JOIN stock st ON sd.StockID = st.StockCode
JOIN model m ON st.ModelID = m.ModelID
JOIN make mk ON m.MakeID = mk.MakeID
WHERE mk.MakeName = 'Jaguar'
AND s.SaleDate BETWEEN DATE_SUB('2015-07-25', INTERVAL 75 DAY) AND '2015-07-25';

#17
SELECT 
    CustomerID,
    CustomerName,
    CONCAT_WS(' - ', 
        COALESCE(Address1, ''), 
        COALESCE(Address2, ''), 
        COALESCE(Town, ''), 
        COALESCE(Country, ''), 
        COALESCE(PostCode, '')
    ) AS FullAddress
FROM customer;

#18
SELECT 
    CONCAT(mk.MakeName, ' ', mo.ModelName) AS MakeModel,
    SUM(s.TotalSalePrice) AS TotalSales
FROM sales s
JOIN salesdetails sd ON s.SalesID = sd.SalesID
JOIN stock st ON sd.StockID = st.StockCode
JOIN model mo ON st.ModelID = mo.ModelID
JOIN make mk ON mo.MakeID = mk.MakeID
GROUP BY mk.MakeName, mo.ModelName
ORDER BY TotalSales DESC;

#19
SELECT 
    CONCAT(mo.ModelName, ' (', LEFT(mk.MakeName, 3), ')') AS ProductCatalog
FROM model mo
JOIN make mk ON mo.MakeID = mk.MakeID;

#20
SELECT 
    RIGHT(InvoiceNumber, 3) AS InvoiceSuffix
FROM sales;

#21
SELECT 
    SUBSTRING(InvoiceNumber, 4, 2) AS CountryCode
FROM sales;

#22
SELECT *
FROM sales
WHERE InvoiceNumber LIKE 'EUR%';

#23
SELECT DISTINCT ModelName
FROM model md
JOIN make m ON m.MakeID = md.MakeID
JOIN stock st ON md.ModelID = st.ModelID
JOIN salesdetails sd ON st.StockCode = sd.StockID
JOIN sales s ON sd.SalesID = s.SalesID
WHERE MakeCountry = 'ITA' 
AND SUBSTRING(InvoiceNumber, 4, 2) = 'FR';

#24
SELECT DISTINCT ModelName, CountryName AS DestinationCountry
FROM model md
JOIN make m ON m.MakeID = md.MakeID
JOIN stock st ON md.ModelID = st.ModelID
JOIN salesdetails sd ON st.StockCode = sd.StockID
JOIN sales s ON sd.SalesID = s.SalesID
JOIN country ON SUBSTRING(InvoiceNumber, 4, 2) = CountryISO2;

#25
SELECT 
    ModelName,
    MakeName,
    FORMAT(Cost, 2) AS FormattedCost
FROM model
JOIN make ON make.MakeID = model.MakeID
JOIN stock ON model.ModelID = stock.ModelID;

#26
SELECT distinct
    CONCAT(m.MakeName, ' ', mo.ModelName) AS Vehicle,
    CONCAT('£', FORMAT(saleprice, 2)) AS SalePrice
FROM salesdetails sd
JOIN stock s ON sd.StockID = s.StockCode
JOIN model mo ON s.ModelID = mo.ModelID
JOIN make m ON mo.MakeID = m.MakeID;

#27
SELECT distinct
    CONCAT(m.MakeName, ' ', mo.ModelName) AS Vehicle,
    CONCAT('€', REPLACE(FORMAT(saleprice, 2), ',', '.')) AS SalePrice
FROM salesdetails sd
JOIN stock s ON sd.StockID = s.StockCode
JOIN model mo ON s.ModelID = mo.ModelID
JOIN make m ON mo.MakeID = m.MakeID;

#28
SELECT 
    InvoiceNumber,
    DATE_FORMAT(SaleDate, '%d, %b, %Y') AS FormattedSaleDate
FROM sales;

#29
SELECT 
    InvoiceNumber,
    DATE_FORMAT(SaleDate, '%Y-%m-%d') AS FormattedSaleDate
FROM sales;

#30
SELECT 
    InvoiceNumber,
    TIME_FORMAT(SaleDate, '%h:%i:%s %p') AS FormattedSaleTime
FROM sales;

#31
SELECT StockCode, ModelID, 
CASE WHEN PartsCost > RepairsCost 
THEN 'Alert'
ELSE 'Good'
END AS CostAlert
FROM stock
ORDER BY ModelID;

#32
SELECT 
    CASE
        WHEN LENGTH(buyercomments) <= 25 THEN buyercomments
        ELSE CONCAT(LEFT(buyercomments, 25), '...')
    END AS buyercomments
FROM stock
where stock.BuyerComments is not null;

#33
SELECT distinct
  s.SalesID,
  sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost) AS Profit,
  CASE
    WHEN sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost) < (0.10 * st.Cost)
         AND st.RepairsCost >= (2 * COALESCE(st.PartsCost, 0)) THEN 'Warning!'
    ELSE 'OK'
  END AS CostAlert
FROM
  sales AS s
JOIN
  salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN
  stock AS st ON sd.StockID = st.StockCode
WHERE
  s.SaleDate IS NOT NULL;

#34
SELECT
  s.SalesID,
  sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost) AS Profit,
  CASE
    WHEN sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost) < (0.10 * st.Cost)
         AND st.RepairsCost >= (2 * COALESCE(st.PartsCost, 0)) THEN 'Warning!'
    WHEN (sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost)) / sd.SalePrice > 0.10
         AND (sd.SalePrice - (st.Cost + st.RepairsCost + COALESCE(st.PartsCost, 0) + st.TransportInCost)) / sd.SalePrice < 0.50 THEN 'Acceptable'
    ELSE 'OK'
  end AS CostAlert
FROM
  sales AS s
JOIN
  salesdetails AS sd ON s.SalesID = sd.SalesID
JOIN
  stock AS st ON sd.StockID = st.StockCode
WHERE
  s.SaleDate IS NOT NULL;

#35
SELECT distinct
  c.CountryName,
  CASE
    WHEN c.CountryName IN ('Austria', 'Belgium', 'Cyprus', 'Estonia', 'Finland', 'France', 'Switzerland','Germany', 'Greece', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Portugal', 'Slovakia', 'Slovenia', 'Spain') THEN 'Eurozone'
    WHEN c.CountryName IN ('United Kingdom') THEN 'Pound Sterling'
    WHEN c.CountryName IN ('United States') THEN 'Dollar'
    ELSE 'Other'
  END AS CurrencyRegion
FROM
  country AS c;

#36
SELECT
 CASE 
   WHEN MakeCountry IN ('ITA', 'FRA', 'GER') THEN 'European'
   WHEN MakeCountry = 'GBR' THEN 'British'
   WHEN MakeCountry = 'USA' THEN 'American'
   ELSE 'Other'
 END AS Region,
 Count(MakeID) AS MakeCount
FROM make
GROUP BY Region;

#37
SELECT
  CASE
    WHEN TotalSalePrice < 5000 THEN 'Under 5000'
    WHEN TotalSalePrice BETWEEN 5000 AND 50000 THEN '5000-50000'
    WHEN TotalSalePrice BETWEEN 50001 AND 100000 THEN '50001-100000'
    WHEN TotalSalePrice BETWEEN 100001 AND 200000 THEN '100001-200000'
    ELSE 'Over 200000'
  END AS SalesValueBand,
  COUNT(*) AS VehiclesSold
FROM sales
GROUP BY SalesValueBand;

#38
SELECT
  MONTH(SaleDate) AS MonthNumber,
  SaleDate,
  CASE
    WHEN MONTH(SaleDate) IN (11, 12, 1, 2) THEN 'Winter'
    WHEN MONTH(SaleDate) IN (3, 4) THEN 'Spring'
    WHEN MONTH(SaleDate) IN (5, 6, 7, 8) THEN 'Summer'
    ELSE 'Autumn'
  END AS SaleSeason
FROM sales
ORDER BY SaleDate;

#39
SELECT 
    s.SalesID, 
    sd.SalePrice
FROM 
    sales s
JOIN 
    salesdetails sd ON s.SalesID = sd.SalesID
JOIN 
    stock st ON sd.StockID = st.StockCode
JOIN 
    model md ON st.ModelID = md.ModelID
JOIN 
    make mk ON md.MakeID = mk.MakeID
WHERE 
    mk.MakeName IN (
        SELECT 
            MakeName
        FROM (
            SELECT 
                mk.MakeName, 
                SUM(sd.SalePrice) AS TotalSales
            FROM 
                salesdetails sd
            JOIN 
                stock st ON sd.StockID = st.StockCode
            JOIN 
                model md ON st.ModelID = md.ModelID
            JOIN 
                make mk ON md.MakeID = mk.MakeID
            GROUP BY 
                mk.MakeName
            ORDER BY 
                TotalSales DESC
            LIMIT 5
        ) AS TopMakes
    )
ORDER BY 
    sd.SalePrice DESC;

#40
SELECT 
    st.Color, 
    COUNT(*) AS NumberOfSales, 
    SUM(sd.SalePrice) AS TotalSalesValue,
    (SUM(sd.SalePrice) / (SELECT SUM(SalePrice) FROM salesdetails)) * 100 AS PercentageOfTotalSalesValue
FROM 
    salesdetails sd
JOIN 
    stock st ON sd.StockID = st.StockCode
GROUP BY 
    st.Color
ORDER BY 
    NumberOfSales DESC, TotalSalesValue DESC;

#41
SELECT DISTINCT mk.MakeName, md.ModelName 
FROM sales as s1
JOIN salesdetails as sd ON s1.SalesID = sd.SalesID
JOIN stock as st ON sd.StockID = st.StockCode
JOIN model as md ON st.ModelID = md.ModelID
JOIN make as mk ON md.MakeID = mk.MakeID
WHERE YEAR(s1.SaleDate) = 2018
AND NOT EXISTS (
 SELECT 1
 FROM sales as s2 
 JOIN salesdetails as sd2 ON s2.SalesID = sd2.SalesID
 JOIN stock as st2 ON sd2.StockID = st2.StockCode
 JOIN model as md2 ON st2.ModelID = md2.ModelID
 WHERE md2.ModelID = md.ModelID
 AND YEAR(s2.SaleDate) <> 2018
)
ORDER BY mk.MakeName, md.ModelName;

#42
SELECT distinct
    sbc.SalesDetailsID, 
    sbc.SalePrice,
    (sbc.SalePrice / total_sales.TotalSalePrice) * 100 AS PercentageOfTotalSales,
    sbc.SalePrice - avg_sales.AverageSalePrice AS DeviationFromAverage
FROM 
    salesbycountry sbc,
    (SELECT SUM(SalePrice) AS TotalSalePrice FROM salesbycountry WHERE YEAR(SaleDate) = 2017) total_sales,
    (SELECT AVG(SalePrice) AS AverageSalePrice FROM salesbycountry WHERE YEAR(SaleDate) = 2017) avg_sales
WHERE 
    YEAR(sbc.SaleDate) = 2017;

#43
SELECT 
    MakeName,
    SUM(SalePrice) AS TotalSales
FROM 
    salesbycountry
WHERE 
    YEAR(SaleDate) = 2017
GROUP BY 
    MakeName
ORDER BY 
    TotalSales DESC;

#44
SELECT 
    a.MakeName,
    a.Color,
    a.TotalSales
FROM
    (SELECT 
         MakeName,
         Color,
         SUM(SalePrice) as TotalSales
     FROM 
         salesbycountry
     GROUP BY 
         MakeName, Color) a
JOIN
    (SELECT 
         MakeName,
         MAX(TotalSales) as MaxSales
     FROM 
         (SELECT 
              MakeName,
              Color,
              SUM(SalePrice) as TotalSales
          FROM 
              salesbycountry
          GROUP BY 
              MakeName, Color) b
     GROUP BY 
         MakeName) c ON a.MakeName = c.MakeName AND a.TotalSales = c.MaxSales
ORDER BY 
    a.MakeName, a.TotalSales DESC;

#45
SELECT MakeName, SUM(SalePrice) AS TotalSales
FROM (
    SELECT 
        sd.SalePrice, 
        mk.MakeName,
        @running_total := @running_total + sd.SalePrice AS cumulative_sum
    FROM 
        (SELECT @running_total := 0) r,
        salesdetails sd
    JOIN stock st ON sd.StockID = st.StockCode
    JOIN model m ON st.ModelID = m.ModelID
    JOIN make mk ON m.MakeID = mk.MakeID
    ORDER BY sd.SalePrice DESC
) AS RankedSales
WHERE cumulative_sum > (SELECT SUM(SalePrice) * 0.2 FROM salesdetails)
AND cumulative_sum <= (SELECT SUM(SalePrice) * 0.4 FROM salesdetails)
GROUP BY MakeName
ORDER BY TotalSales DESC
LIMIT 3;

#46
SELECT 
    s.SaleDate,
    YEAR(s.SaleDate) AS SaleYear,
    s.TotalSalePrice,
    SUM(s.TotalSalePrice) OVER(PARTITION BY YEAR(s.SaleDate) ORDER BY s.SaleDate) AS RunningTotal
FROM 
    sales s
ORDER BY 
    s.SaleDate;

#47
WITH RankedSales AS (
 SELECT
 s.CustomerID,
 s.TotalSalePrice,
 s.SaleDate,
 ROW_NUMBER() OVER (PARTITION BY CustomerID 
ORDER BY SaleDate ASC) AS rn_asc,
ROW_NUMBER() OVER (PARTITION BY CustomerID 
ORDER BY SaleDate DESC) AS rn_desc
FROM sales s
 )
SELECT rs.CustomerID, rs.TotalSalePrice, rs.SaleDate
FROM RankedSales rs
WHERE rn_asc = 1 OR rn_desc <= 4 
ORDER BY CustomerID, SaleDate;

#48
SELECT DAYNAME(SaleDate) AS day, 
 COUNT(*) AS SaleCount, 
 SUM(SalePrice) AS TotalSales
FROM sales2017
WHERE DAYOFWEEK(SaleDate) BETWEEN 2 AND 6
GROUP BY day
ORDER BY TotalSales DESC;

########## DATABASE
USE `colonial`;
###############################

#1
#use only JOINs and no subqueries:
SELECT r.ReservationID, r.TripID, r.TripDate
FROM reservation r
JOIN trip t ON r.TripID = t.TripID
WHERE t.State = 'ME';

#using a subquery without JOIN:
SELECT ReservationID, TripID, TripDate
FROM reservation
WHERE TripID IN (SELECT TripID FROM trip WHERE State = 'ME');

#using a subquery with JOIN:
SELECT r.ReservationID, r.TripID, r.TripDate
FROM reservation r
JOIN (SELECT TripID FROM trip WHERE State = 'ME') AS subquery
ON r.TripID = subquery.TripID;

#2
SELECT TripID, TripName
FROM trip
WHERE MaxGrpSize > ALL (
    SELECT MaxGrpSize 
    FROM trip 
    WHERE Type = 'Hiking'
);

#3
SELECT t1.TripID, t1.TripName
FROM trip t1
WHERE t1.MaxGrpSize > ANY (
    SELECT t2.MaxGrpSize
    FROM trip t2
    WHERE t2.Type = 'Biking'
);

########## DATABASE
USE `entertainmentagencyexample`;
###############################

#1
SELECT DISTINCT E.EntStageName
FROM ENTERTAINERS AS E
WHERE E.EntertainerID IN (
    SELECT EG.EntertainerID
    FROM ENGAGEMENTS AS EG
    INNER JOIN CUSTOMERS AS C ON EG.CustomerID = C.CustomerID
    WHERE C.CustLastName = 'Berg' OR C.CustLastName = 'Hallmark'
);

SELECT DISTINCT E.EntStageName
FROM ENTERTAINERS AS E
WHERE EXISTS (
    SELECT 1
    FROM ENGAGEMENTS AS EG
    INNER JOIN CUSTOMERS AS C ON EG.CustomerID = C.CustomerID
    WHERE (C.CustLastName = 'Berg' OR C.CustLastName = 'Hallmark') AND EG.EntertainerID = E.EntertainerID
);

#2
SELECT AVG(a.Salary)
FROM agents AS a
LEFT JOIN engagements AS en
ON a.AgentID = en.AgentID
WHERE en.EngagementNumber IS NOT NULL;

#3
SELECT EngagementNumber
FROM engagements
WHERE ContractPrice >= (
    SELECT AVG(ContractPrice)
    FROM engagements
);

#4
SELECT COUNT(*) AS NumberOfEntertainers
FROM ENTERTAINERS
WHERE EntCity = 'Bellevue';

#5
SELECT *
FROM Engagements
WHERE StartDate = (
    SELECT MIN(StartDate)
    FROM ENGAGEMENTS
    WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31'
    ) AND StartTime = (
        SELECT MIN(StartTime)
        FROM ENGAGEMENTS
        WHERE StartDate = (
              SELECT MIN(StartDate)
              FROM ENGAGEMENTS
              WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31')
)
AND StartDate BETWEEN '2017-10-01' AND '2017-10-31';

#6
select en.entertainerid, en.entstagename,
count(eng.engagementnumber) as engagement
from entertainers en
left join engagements eng on en.entertainerid=eng.entertainerid
group by en.entertainerid
order by en.entertainerid;

#7
SELECT cu.* FROM customers AS cu
LEFT JOIN engagements AS eng
ON cu.CustomerID = eng.CustomerID
WHERE eng.EntertainerID IN
(SELECT es.EntertainerID FROM entertainer_styles AS es
LEFT JOIN musical_styles AS ms 
ON ms.StyleID = es.StyleID
WHERE ms.StyleName IN ('Country','Country Rock'))
GROUP BY cu.CustomerID;

#8
SELECT DISTINCT c.*
FROM customers AS c
JOIN engagements AS eng ON c.CustomerID = eng.CustomerID
JOIN entertainer_styles AS es ON eng.EntertainerID = es.EntertainerID
JOIN musical_styles AS ms ON es.StyleID = ms.StyleID
WHERE ms.StyleName IN ('Country', 'Country Rock');

#9
SELECT EntertainerID
FROM engagements AS eng
WHERE CustomerID IN 
(SELECT CustomerID
FROM customers as cu
WHERE CustLastName IN ('Berg', 'Hallmark'))
GROUP BY EntertainerID;

#10
SELECT DISTINCT ent.EntStageName
FROM entertainers ent
LEFT JOIN engagements eng 
ON ent.EntertainerID = eng.EntertainerID
LEFT JOIN customers c ON eng.CustomerID = c.CustomerID
WHERE c.CustLastName IN ('Berg', 'Hallmark');

#11
#Using NOT IN
SELECT a.*
FROM AGENTS a
WHERE a.AgentID NOT IN (
    SELECT DISTINCT e.AgentID
    FROM ENGAGEMENTS e
    WHERE e.AgentID IS NOT NULL
);
#Using NOT EXISTS
SELECT a.*
FROM AGENTS a
WHERE NOT EXISTS (
    SELECT 1
    FROM ENGAGEMENTS e
    WHERE a.AgentID = e.AgentID
);

#12
SELECT a.*
FROM AGENTS a
LEFT JOIN ENGAGEMENTS e ON a.AgentID = e.AgentID
WHERE e.AgentID IS NULL;

#13
SELECT
    C.CustomerID,
    C.CustFirstName,
    C.CustLastName,
    (SELECT MAX(ENG.`StartDate`)
     FROM ENGAGEMENTS ENG
     WHERE ENG.CustomerID = C.CustomerID
    ) AS LastBookingDate
FROM
    CUSTOMERS C;

#14
SELECT DISTINCT ent.EntStageName
FROM entertainers ent
WHERE EntertainerID IN 
(SELECT eng.EntertainerID FROM engagements AS eng
LEFT JOIN customers cu ON eng.CustomerID = cu.CustomerID
WHERE cu.CustLastName IN ('Berg') )
ORDER BY ent.EntStageName;

SELECT DISTINCT ent.EntStageName
FROM entertainers ent
LEFT JOIN engagements eng 
ON ent.EntertainerID = eng.EntertainerID
WHERE eng.CustomerID IN (
SELECT CustomerID FROM customers WHERE CustLastName = 'Berg')
ORDER BY ent.EntStageName;

#15
SELECT DISTINCT ent.EntStageName
FROM entertainers ent
LEFT JOIN engagements eng 
ON ent.EntertainerID = eng.EntertainerID
LEFT JOIN customers cu ON eng.CustomerID = cu.CustomerID
WHERE cu.CustLastName IN ('Berg')
ORDER BY ent.EntStageName;

#16
SELECT e.EngagementNumber, e.ContractPrice
FROM ENGAGEMENTS e
WHERE e.ContractPrice > (
    SELECT SUM(e2.ContractPrice)
    FROM ENGAGEMENTS e2
    WHERE e2.StartDate BETWEEN '2017-11-01' AND '2017-11-30'
);

#17
SELECT e.EngagementNumber, e.ContractPrice
FROM ENGAGEMENTS e
WHERE e.StartDate = (
    SELECT MIN(e2.StartDate)
    FROM ENGAGEMENTS e2
);

#18
SELECT SUM(ContractPrice) AS TotalValue
FROM ENGAGEMENTS
WHERE SUBSTR(`StartDate`,1,7) = '2017-10'
AND SUBSTR(`EndDate`,1,7) = '2017-10';

#19
SELECT c.*
FROM CUSTOMERS c
LEFT JOIN ENGAGEMENTS e ON c.CustomerID = e.CustomerID
WHERE e.CustomerID IS NULL;

#20
#Using NOT IN with a Subquery
SELECT c.*
FROM CUSTOMERS c
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT e.CustomerID
    FROM ENGAGEMENTS e
);
#Using NOT EXISTS with a Correlated Subquery
SELECT c.*
FROM CUSTOMERS c
WHERE NOT EXISTS (
    SELECT 1
    FROM ENGAGEMENTS e
    WHERE c.CustomerID = e.CustomerID
);

#21
SELECT EntCity, COUNT(DISTINCT StyleID) AS StyleCount
FROM ENTERTAINERS
JOIN ENTERTAINER_STYLES ON ENTERTAINERS.EntertainerID = ENTERTAINER_STYLES.EntertainerID
GROUP BY EntCity WITH ROLLUP;

#22
SELECT 
    a.AgentID, 
    a.AgtFirstName, 
    a.AgtLastName, 
    SUM(e.ContractPrice) AS TotalBusiness
FROM 
    AGENTS a
JOIN 
    ENGAGEMENTS e ON a.AgentID = e.AgentID
WHERE 
    e.StartDate BETWEEN '2017-12-01' AND '2017-12-31'
GROUP BY 
    a.AgentID
HAVING 
    SUM(e.ContractPrice) > 3000;

#23
SELECT 
    En.EntertainerID,
    En.EntStageName,
    COUNT(DISTINCT Eng1.EngagementNumber) AS Overlap
FROM 
    Engagements Eng1
JOIN 
    Engagements Eng2 ON Eng1.EntertainerID = Eng2.EntertainerID 
    AND Eng1.EngagementNumber != Eng2.EngagementNumber
    AND NOT (Eng1.EndDate < Eng2.StartDate OR Eng1.StartDate > Eng2.EndDate 
    OR (Eng1.EndDate = Eng2.StartDate AND Eng1.StopTime <= Eng2.StartTime)
    OR (Eng1.StartDate = Eng2.EndDate AND Eng1.StartTime >= Eng2.StopTime))
JOIN 
    Entertainers En ON Eng1.EntertainerID = En.EntertainerID
GROUP BY 
    En.EntertainerID, En.EntStageName
HAVING 
    Overlap > 2;

#24
SELECT 
    a.AgtFirstName,
    a.AgtLastName,
    TotalContractPrice,
    (TotalContractPrice * a.CommissionRate) AS commission
FROM 
    (SELECT 
         AgentID,
         SUM(ContractPrice) AS TotalContractPrice
     FROM 
         engagements
     GROUP BY 
         AgentID) AS eng
LEFT JOIN 
    agents AS a ON eng.AgentID = a.AgentID
WHERE 
    (TotalContractPrice * a.CommissionRate) > 1000;


#25
SELECT Ag.AgentId, agtFirstname, agtlastname
FROM Agents as Ag
WHERE Ag.AGentID NOT IN(
SELECT Eng.agentid FROM Engagements Eng
JOIN Entertainers as E ON Eng.EntertainerId= E.Entertainerid
JOIN Entertainer_Styles ES ON E.Entertainerid= ES.Entertainerid
JOIN Musical_styles MS ON ES.Styleid = MS.Styleid
WHERE Stylename IN ('Country', 'country Rock'));

#26
select en.entertainerid, entstagename
from entertainers en
where not exists(
select eng.entertainerid
from engagements as eng
where eng.entertainerid = en.entertainerid
and eng.startdate between'2018-01-31' and  2018-04-30);

#27
#method1
select distinct en.entertainerid, entstagename
from entertainers en 
inner join entertainer_styles as es on en.entertainerid = es.entertainerid
inner join musical_styles as ms on es.styleid = ms.styleid
where stylename in ('jazz', 'rhythm and blues' ,'salsa')
group by en.entertainerid, entstagename
having count(distinct stylename)=3
order by en.entertainerid;

#method2
SELECT E.EntertainerID, E.EntStageName
FROM ENTERTAINERS E
JOIN ENTERTAINER_STYLES ES1 ON E.EntertainerID = ES1.EntertainerID
JOIN MUSICAL_STYLES MS1 ON ES1.StyleID = MS1.StyleID AND MS1.StyleName = 'Jazz'
JOIN ENTERTAINER_STYLES ES2 ON E.EntertainerID = ES2.EntertainerID
JOIN MUSICAL_STYLES MS2 ON ES2.StyleID = MS2.StyleID AND MS2.StyleName = 'Rhythm and Blues'
JOIN ENTERTAINER_STYLES ES3 ON E.EntertainerID = ES3.EntertainerID
JOIN MUSICAL_STYLES MS3 ON ES3.StyleID = MS3.StyleID AND MS3.StyleName = 'Salsa'
GROUP BY E.EntertainerID, E.EntStageName;

#28
#using IN with Subqueries
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
WHERE c.CustomerID IN (
    SELECT e.CustomerID
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Carol Peacock Trio'
) AND c.CustomerID IN (
    SELECT e.CustomerID
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Caroline Coie Cuartet'
) AND c.CustomerID IN (
    SELECT e.CustomerID
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Jazz Persuasion'
);

#Using EXISTS with Correlated Subqueries
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
WHERE EXISTS (
    SELECT 1
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Carol Peacock Trio' AND e.CustomerID = c.CustomerID
) AND EXISTS (
    SELECT 1
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Caroline Coie Cuartet' AND e.CustomerID = c.CustomerID
) AND EXISTS (
    SELECT 1
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName = 'Jazz Persuasion' AND e.CustomerID = c.CustomerID
);

#Using JOINs with a Subquery
SELECT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
JOIN (
    SELECT e.CustomerID
    FROM ENGAGEMENTS e
    JOIN ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
    WHERE en.EntStageName IN ('Carol Peacock Trio', 'Caroline Coie Cuartet', 'Jazz Persuasion')
    GROUP BY e.CustomerID
    HAVING COUNT(DISTINCT en.EntStageName) = 3
) AS booked ON c.CustomerID = booked.CustomerID;

#29
SELECT cu.*
FROM customers AS cu
LEFT JOIN engagements eng
ON cu.CustomerID = eng.CustomerID
LEFT JOIN entertainers AS en 
ON eng.EntertainerID = en.EntertainerID
WHERE cu.CustomerID NOT  IN
(SELECT CustomerID
FROM musical_preferences mp
WHERE NOT EXISTS (SELECT EntertainerID FROM entertainer_styles es
WHERE es.EntertainerID = en.EntertainerID AND es.StyleID = mp.StyleID));

#30
SELECT ent.*
FROM entertainers AS ent
JOIN entertainer_styles AS es ON ent.EntertainerID = es.EntertainerID
JOIN musical_styles AS ms ON ms.StyleID = es.StyleID
WHERE ms.StyleName = 'Jazz' 
AND (
    SELECT COUNT(*) 
    FROM entertainer_members AS em
    WHERE em.EntertainerID = ent.EntertainerID
) > 3;


#31
SELECT 
    c.CustFirstName, 
    c.CustLastName, 
    CASE 
        WHEN ms.StyleName IN ('50’s', '60’s', '70’s', '80’s') THEN 'Oldies'
        ELSE ms.StyleName 
    END AS StyleName
FROM 
    CUSTOMERS c
JOIN 
    MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
JOIN 
    MUSICAL_STYLES ms ON mp.StyleID = ms.StyleID;

#32
SELECT *
FROM ENGAGEMENTS
WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31'
AND StartTime BETWEEN '12:00:00' AND '17:00:00';

#33
SELECT 
    Ent.EntertainerID, 
    Ent.EntStageName, 
    CASE 
        WHEN Eng.StartDate = '2017-12-25' THEN 'Booked on Christmas'
        ELSE 'Not Booked on Christmas' 
    END AS ChristmasBookingStatus
FROM 
    ENTERTAINERS Ent
LEFT JOIN 
    ENGAGEMENTS Eng ON Ent.EntertainerID = Eng.EntertainerID
    AND Eng.StartDate = '2017-12-25';

#34
-- Outer query to filter the results based on PreferenceStatus
SELECT *
FROM (
    -- Subquery to get customer preferences
    SELECT
        c.CustomerID,
        c.CustFirstName,
        c.CustLastName,
        -- Case statement to check if the customer likes 'Jazz' but not 'Standards'
        CASE
            -- Subquery to check for 'Jazz' preference
            WHEN 'Jazz' IN (
                SELECT `StyleName`
                FROM `musical_styles` AS ms
                -- Join musical preferences with musical styles
                LEFT JOIN `musical_preferences` AS mp USING (`StyleID`)
                WHERE mp.CustomerID = c.CustomerID
            )
            -- Subquery to ensure 'Standards' is not preferred
            AND 'Standards' NOT IN (
                SELECT `StyleName`
                FROM `musical_styles` AS ms
                -- Join musical preferences with musical styles
                LEFT JOIN `musical_preferences` AS mp USING (`StyleID`)
                WHERE mp.CustomerID = c.CustomerID
            )
            THEN 'Likes Jazz but not Standards'
            ELSE 'Does not meet criteria'
        END AS PreferenceStatus
    FROM
        CUSTOMERS c
) AS t
-- Filter condition for the outer query
WHERE PreferenceStatus = 'Likes Jazz but not Standards';

#35
SELECT 
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName, 
    ms.StyleName,
    (SELECT COUNT(*) FROM musical_preferences mp WHERE mp.CustomerID = c.CustomerID) AS TotalPreferences
FROM 
    customers c
JOIN 
    musical_preferences mp ON c.CustomerID = mp.CustomerID
JOIN 
    musical_styles ms ON mp.StyleID = ms.StyleID;

#36
SELECT cu.CustomerID, CONCAT(`CustFirstName`,'',`CustLastName`) ,
ms.StyleName, COUNT(*) over(PARTITION BY cu.CustomerID)  total_number_of_preferences ,
SUM(COUNT(*)) over(ORDER BY cu.CustFirstName,CustLastName ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM customers cu
LEFT JOIN musical_preferences AS mp USING(CustomerID)
LEFT JOIN musical_styles AS ms USING(StyleID)
GROUP BY customerID,CustFirstName,CustLastName,StyleName,StyleID;

#37
SELECT 
    c.CustCity AS CustomerCity, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
    COUNT(mp.StyleID) AS NumberOfPreferences,
    SUM(COUNT(mp.StyleID)) OVER (PARTITION BY c.CustCity ORDER BY c.CustCity, c.CustFirstName, c.CustLastName) AS RunningTotalPreferences
FROM 
    customers c
JOIN 
    musical_preferences mp ON c.CustomerID = mp.CustomerID
GROUP BY 
    c.CustCity, c.CustomerID
ORDER BY 
    c.CustCity, CustomerName;

#38
SELECT 
    ROW_NUMBER() OVER (ORDER BY c.CustFirstName, c.CustLastName) AS RowNumber,
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
    c.CustState
FROM 
    customers c
ORDER BY 
    CustomerName;

#39
SELECT 
    ROW_NUMBER() OVER (PARTITION BY c.CustState, c.CustCity ORDER BY c.CustFirstName, c.CustLastName) AS CustomerNumber,
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
    c.CustCity,
    c.CustState
FROM 
    CUSTOMERS c
ORDER BY 
    c.CustState, c.CustCity, CustomerName;

#40
SELECT 
    e.StartDate, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName, 
    en.EntStageName,
    ROW_NUMBER() OVER (ORDER BY en.EntStageName) AS EntertainerNumber,
    ROW_NUMBER() OVER (PARTITION BY e.StartDate ORDER BY e.EngagementNumber) AS EngagementNumberWithinDate
FROM 
    ENGAGEMENTS e
JOIN 
    CUSTOMERS c ON e.CustomerID = c.CustomerID
JOIN 
    ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
ORDER BY 
    e.StartDate, CustomerName, en.EntStageName;

#41
SELECT 
    en.EntertainerID, 
    en.EntStageName, 
    COUNT(e.EngagementNumber) AS NumberOfEngagements,
    NTILE(3) OVER (ORDER BY COUNT(e.EngagementNumber) DESC) AS RankGroup
FROM 
    ENTERTAINERS en
LEFT JOIN 
    ENGAGEMENTS e ON en.EntertainerID = e.EntertainerID
GROUP BY 
    en.EntertainerID
ORDER BY 
    NumberOfEngagements DESC;

#42
SELECT 
    a.AgentID, 
    CONCAT(a.AgtFirstName, ' ', a.AgtLastName) AS AgentName, 
    IFNULL(SUM(e.ContractPrice), 0) AS TotalBookings
FROM 
    AGENTS a
LEFT JOIN 
    ENGAGEMENTS e ON a.AgentID = e.AgentID
GROUP BY 
    a.AgentID
ORDER BY 
    TotalBookings DESC;

#43
SELECT 
    en.EntStageName, 
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName, 
    e.StartDate,
    COUNT(e.EngagementNumber) OVER (PARTITION BY en.EntertainerID) AS TotalEngagements
FROM 
    ENGAGEMENTS e
JOIN 
    CUSTOMERS c ON e.CustomerID = c.CustomerID
JOIN 
    ENTERTAINERS en ON e.EntertainerID = en.EntertainerID
ORDER BY 
    en.EntStageName, StartDate;

#44
SELECT 
    en.EntertainerID, 
    en.EntStageName, 
    em.MemberID,
    ROW_NUMBER() OVER (PARTITION BY en.EntertainerID ORDER BY em.MemberID) AS MemberNumber
FROM 
    ENTERTAINERS en
JOIN 
    ENTERTAINER_MEMBERS em ON en.EntertainerID = em.EntertainerID
ORDER BY 
    en.EntertainerID, MemberNumber;












########## DATABASE
USE `accountspayable`;
###############################

#1
SELECT 
  COUNT(*) AS UnpaidInvoiceCount,
  SUM(invoice_total - payment_total - credit_total) AS TotalAmountDue
FROM 
  invoices
WHERE 
  invoice_total - payment_total - credit_total > 0;


#2
SELECT 
  v.vendor_id,
  v.vendor_name,
  i.invoice_id,
  i.invoice_number,
  i.invoice_date,
  i.invoice_total,
  ili.line_item_amount,
  ili.line_item_description
FROM 
  vendors v
JOIN 
  invoices i ON v.vendor_id = i.vendor_id
LEFT JOIN 
  invoice_line_items ili ON i.invoice_id = ili.invoice_id
WHERE 
  v.vendor_state = 'CA';


#3
SELECT 
  i.invoice_id,
  i.invoice_number,
  i.invoice_date,
  i.invoice_total,
  (SELECT vendor_name FROM vendors WHERE vendor_id = i.vendor_id) AS vendor_name,
  ili.line_item_amount,
  ili.line_item_description
FROM 
  invoices i,
  invoice_line_items ili
WHERE 
  i.invoice_id = ili.invoice_id
  AND i.vendor_id IN (SELECT vendor_id FROM vendors WHERE vendor_state = 'CA');

#4
SELECT 
  v.vendor_id,
  v.vendor_name,
  v.vendor_address1,
  v.vendor_address2,
  v.vendor_city,
  v.vendor_state,
  v.vendor_zip_code,
  v.vendor_phone,
  v.vendor_contact_last_name,
  v.vendor_contact_first_name
FROM 
  vendors v
LEFT JOIN 
  invoices i ON v.vendor_id = i.vendor_id
WHERE 
  i.invoice_id IS NULL;

#5
SELECT 
  v.vendor_id,
  v.vendor_name,
  v.vendor_address1,
  v.vendor_address2,
  v.vendor_city,
  v.vendor_state,
  v.vendor_zip_code,
  v.vendor_phone,
  v.vendor_contact_last_name,
  v.vendor_contact_first_name
FROM 
  vendors v
WHERE 
  v.vendor_id NOT IN (
    SELECT DISTINCT i.vendor_id 
    FROM invoices i
  );

#6
select *from invoices
where (invoice_total - payment_total - credit_total) <
(select avg(invoice_total - payment_total - credit_total) from invoices);

#7
#First Query using a Subquery in the WHERE Clause:
SELECT 
  v.vendor_name,
  i.invoice_number,
  i.invoice_total
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id
WHERE 
  i.invoice_total > (
    SELECT MAX(invoice_total) 
    FROM invoices 
    WHERE vendor_id = 34
  );

#Second Query using a Subquery with JOIN:
SELECT 
  v.vendor_name,
  i.invoice_number,
  i.invoice_total
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id
JOIN (
  SELECT MAX(invoice_total) as max_invoice_total
  FROM invoices 
  WHERE vendor_id = 34
) as max_invoice ON i.invoice_total > max_invoice.max_invoice_total;

#8
#First Query using a Subquery in the WHERE Clause:
SELECT 
  v.vendor_name,
  i.invoice_number,
  i.invoice_total
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id
WHERE 
  i.invoice_total < (
    SELECT MAX(invoice_total) 
    FROM invoices 
    WHERE vendor_id = 115
  );

#Second Query using a Subquery in the FROM Clause:
SELECT 
  v.vendor_name,
  i.invoice_number,
  i.invoice_total
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id,
  (SELECT MAX(invoice_total) as max_invoice_total FROM invoices WHERE vendor_id = 115) as max_invoice
WHERE 
  i.invoice_total < max_invoice.max_invoice_total;

#9
SELECT distinct vendor_id,invoice_number,
	(SELECT MAX(invoice_date)
		FROM invoices i2
        WHERE i2.vendor_id = inv.vendor_id) 
	AS latest_invoice_date
FROM invoices inv
order by vendor_id;

#10
SELECT 
  v.vendor_name,
  i.invoice_number,
  MAX(i.invoice_date) as Latest_Invoice_Date
FROM 
  vendors v
JOIN 
  invoices i ON v.vendor_id = i.vendor_id
GROUP BY 
  v.vendor_name, i.invoice_number
ORDER BY 
  v.vendor_name, Latest_Invoice_Date DESC;

#11
SELECT 
  i.invoice_id,
  i.vendor_id,
  i.invoice_number,
  i.invoice_total,
  v.vendor_name
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id
WHERE 
  i.invoice_total > (
    SELECT AVG(invoice_total) 
    FROM invoices 
    WHERE vendor_id = i.vendor_id
  );

#12
WITH StateTopVendors AS (
    SELECT
        v.vendor_id,
        v.vendor_state,
        SUM(i.invoice_total) AS TotalInvoiceAmount,
        ROW_NUMBER() OVER (PARTITION BY v.vendor_state ORDER BY SUM(i.invoice_total) DESC) AS rn
    FROM
        vendors v
    JOIN invoices i ON v.vendor_id = i.vendor_id
    GROUP BY
        v.vendor_id, v.vendor_state
),
StateLargestInvoices AS (
    SELECT
        v.vendor_state,
        i.invoice_total,
        ROW_NUMBER() OVER (PARTITION BY v.vendor_state ORDER BY i.invoice_total DESC) AS rn
    FROM
        invoices i
    JOIN vendors v ON i.vendor_id = v.vendor_id
    WHERE
        i.vendor_id IN (SELECT vendor_id FROM StateTopVendors WHERE rn = 1)
)
SELECT 
    vendor_state,
    invoice_total AS LargestInvoiceTotal
FROM 
    StateLargestInvoices
WHERE 
    rn = 1;

#13
SELECT 
  gla.account_description,
  COUNT(ili.line_item_amount) AS NumberOfLineItems,
  SUM(ili.line_item_amount) AS TotalLineItemAmount
FROM 
  general_ledger_accounts gla
JOIN 
  invoice_line_items ili ON gla.account_number = ili.account_number
GROUP BY 
  gla.account_description
HAVING 
  COUNT(ili.line_item_amount) > 1;

#14
select gla.account_number , gla.account_description,
	sum(inv.invoice_total) over (partition by gla.account_number) as total,
	sum(inv.invoice_total) over () as grand
from general_ledger_accounts gla
inner join invoice_line_items ili
on gla.account_number = ili.account_number
inner join invoices inv
on ili.invoice_id = inv.invoice_id;

#15
SELECT 
  v.vendor_id,
  v.vendor_name,
  COUNT(DISTINCT ili.account_number) AS NumberOfDistinctAccounts
FROM 
  vendors v
JOIN 
  invoices i ON v.vendor_id = i.vendor_id
JOIN 
  invoice_line_items ili ON i.invoice_id = ili.invoice_id
GROUP BY 
  v.vendor_id, v.vendor_name
HAVING 
  COUNT(DISTINCT ili.account_number) > 1;

#16
SELECT 
  IF(GROUPING(i.terms_id) = 1 AND GROUPING(v.vendor_name) = 1, 'Grand Total', 
    IF(GROUPING(v.vendor_name) = 1, CONCAT('Subtotal for Terms ID: ', i.terms_id), v.vendor_name)) AS VendorOrTotal,
  i.terms_id,
  MAX(i.payment_date) AS LastPaymentDate,
  SUM(i.invoice_total - i.payment_total-i.credit_total) AS TotalAmountDue
FROM 
  invoices i
JOIN 
  vendors v ON i.vendor_id = v.vendor_id
GROUP BY 
  i.terms_id, v.vendor_name WITH ROLLUP;

#17
SELECT 
  CONCAT('$', FORMAT(i.invoice_total, 2)) AS InvoiceTotalWithCurrency
FROM 
  invoices i;

#18
SELECT 
  DATE_FORMAT(i.invoice_date, '%Y-%m-%d') AS InvoiceDateChar,  -- Converts date to a string in the format 'YYYY-MM-DD'
  FLOOR(i.invoice_total) AS InvoiceTotalInt  -- Converts total to an integer (removing decimals)
FROM 
  invoices i;

#19
SELECT 
  LPAD(invoice_id, 3, '0') AS PaddedInvoiceNumber
FROM 
  invoices;

#20
SELECT 
  ROUND(invoice_total, 1) AS InvoiceTotalOneDecimal,
  CAST(invoice_total AS UNSIGNED) AS InvoiceTotalNoDecimal
FROM 
  invoices;

#21
SELECT 
  start_date, 
  DATE_FORMAT(start_date, '%b/%d/%y') AS Format1,   
  DATE_FORMAT(start_date, '%c/%e/%y') AS Format2,   
  DATE_FORMAT(start_date, '%l:%i %p') AS Format3   
FROM 
  date_sample;

#22
SELECT 
  vendor_name,
  UPPER(vendor_name) AS VendorNameUpperCase,
  vendor_phone,
  RIGHT(vendor_phone, 4) AS LastFourDigitsOfPhone
FROM 
  vendors;

SELECT 
  vendor_name,
  UPPER(vendor_name) AS VendorNameUpperCase,
  vendor_phone,
  RIGHT(vendor_phone, 4) AS LastFourDigitsOfPhone,
  REPLACE(REPLACE(vendor_phone, ' ', ''), '-', '.') AS PhoneWithDots,
  CASE 
    WHEN LOCATE(' ', vendor_name) > 0 
    THEN SUBSTRING_INDEX(SUBSTRING_INDEX(vendor_name, ' ', 2), ' ', -1)
    ELSE '' 
  END AS SecondWordOfVendorName
FROM 
  vendors;

#23
SELECT 
  invoice_number,
  invoice_date,
  DATE_ADD(invoice_date, INTERVAL 30 DAY) AS InvoiceDatePlus30Days,
  payment_date,
  DATEDIFF(payment_date, invoice_date) AS DaysToPay,
  MONTH(invoice_date) AS InvoiceMonthNumber,
  YEAR(invoice_date) AS InvoiceYear
FROM 
  invoices;

SELECT 
  invoice_number,
  invoice_date,
  DATE_ADD(invoice_date, INTERVAL 30 DAY) AS InvoiceDatePlus30Days,
  payment_date,
  DATEDIFF(payment_date, invoice_date) AS DaysToPay,
  MONTH(invoice_date) AS InvoiceMonthNumber,
  YEAR(invoice_date) AS InvoiceYear
FROM 
  invoices
WHERE 
  MONTH(invoice_date) = 5;

#24
SELECT 
  emp_name,
  REGEXP_SUBSTR(emp_name, '^[^ ]+') AS FirstName,
  REGEXP_SUBSTR(emp_name, '[^ ]+$') AS LastName
FROM 
  string_sample;

#25
select distinct vendor_id, invoice_id, (invoice_total - payment_total - credit_total) as balance_due,
sum(invoice_total - payment_total - credit_total) over (partition by vendor_id) as balance_due,
sum(invoice_total - payment_total - credit_total) over () as total_balance_due
from invoices inv
where (invoice_total - payment_total - credit_total) > 0
order by vendor_id;

#26
SELECT 
  vendor_id,
  balance_due,
  SUM(balance_due) OVER () AS TotalBalanceDueAllVendors,
  SUM(balance_due) OVER (PARTITION BY vendor_id ORDER BY balance_due) AS CumulativeBalanceDuePerVendor,
  AVG(balance_due) OVER (PARTITION BY vendor_id) AS AverageBalanceDuePerVendor
FROM 
  (SELECT 
     vendor_id, 
     (invoice_total - payment_total) AS balance_due
   FROM 
     invoices
   WHERE 
     (invoice_total - payment_total) != 0) AS subquery
ORDER BY 
  vendor_id, balance_due;

#27
SELECT 
  EXTRACT(YEAR_MONTH FROM invoice_date) AS InvoiceYearMonth,
  SUM(invoice_total) AS MonthlyTotal,
  AVG(SUM(invoice_total)) OVER (
    ORDER BY EXTRACT(YEAR_MONTH FROM invoice_date)
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
  ) AS FourMonthMovingAvg
FROM 
  invoices
GROUP BY 
  InvoiceYearMonth
ORDER BY 
  InvoiceYearMonth;

















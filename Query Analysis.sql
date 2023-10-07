--1. 
SELECT
  category,
  COUNT(*) AS Total
FROM
  pet_supplies
GROUP BY category;

--2.
SELECT
  category,
  size,
  COUNT(*) AS total
FROM
  pet_supplies
GROUP BY category, size
ORDER BY total DESC, category DESC;

--3.
SELECT
  FLOOR(sales / 250) * 250 AS bin_floor,
  COUNT(*) AS count
FROM
  pet_supplies
GROUP BY bin_floor
ORDER BY bin_floor;

--4.
SELECT
  repeat_purchase,
  FLOOR(sales / 250) * 250 AS bin_floor,
  COUNT(*) AS count
FROM
pet_supplies
GROUP BY repeat_purchase, bin_floor
ORDER BY bin_floor, repeat_purchase;

--5.
SELECT
  CASE
    WHEN repeat_purchase = 1 THEN 'No Repeeat'
    ELSE 'Repeat'
  END AS repeat_purchase,
  AVG(sales)
FROM
  pet_supplies
GROUP BY repeat_purchase

--6.
WITH sort AS (
  SELECT 
    sales,
    ROW_NUMBER() OVER(ORDER BY sales ASC) AS row_num,
    COUNT(*) OVER() AS total
  FROM 
    pet_supplies
),
  
median AS (
  SELECT
    ROUND(SUM(sales) / 2, 2) AS median_sales
  FROM
    sort
  WHERE
    row_num IN (total / 2 , (total / 2) + 1)
),
  
q1 AS (
  SELECT
    sales
  FROM
    sort
  WHERE 
    row_num IN (ceil(total/4) )
),
  
q3 AS (
  SELECT
    sales
  FROM
    sort
  WHERE 
    row_num IN (ceil(total * 3 / 4) )
)
  
SELECT
  sort.sales, 
  max(sort.sales) OVER() AS high,
  AVG(q1.sales) AS q1,
  AVG(median_sales) AS median,
  AVG(q3.sales) AS q3, min(sort.sales) OVER() AS low
FROM sort, median, q1, q3
GROUP BY sort.sales
LIMIT 1

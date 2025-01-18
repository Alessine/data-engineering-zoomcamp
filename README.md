# Data Engineering Zoomcamp Cohort 2025

## Description

## Curriculum

### Module 1: Docker, SQL, Terraform

<details>
<summary><h2>Homework</h2></summary>


<b>Question 1. Understanding docker first run</b>

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash. What's the version of pip in the image?

<b>Answer:</b>
In bash: `docker run -it --entrypoint bash python:3.12.8` 
The image will run locally. To check the version of pip: `pip --version`. It is version `24.3.1`.


<b>Question 2. Understanding Docker networking and docker-compose</b>

Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

<b>Answer:</b>
The container name with the postgres database is `postgres`, located at port `5432`, so the answer is `postgres:5432`.


<b>Question 3. Trip Segmentation Count</b>

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

- Up to 1 mile
- In between 1 (exclusive) and 3 miles (inclusive),
- In between 3 (exclusive) and 7 miles (inclusive),
- In between 7 (exclusive) and 10 miles (inclusive),
- Over 10 miles

<b>Answer:</b>
Query:
```SQL
SELECT
	CASE
		WHEN TRIP_DISTANCE <= 1 THEN '1: <1'
		WHEN TRIP_DISTANCE > 1
		AND TRIP_DISTANCE <= 3 THEN '2: 1-3'
		WHEN TRIP_DISTANCE > 3
		AND TRIP_DISTANCE <= 7 THEN '3: 3-7'
		WHEN TRIP_DISTANCE > 7
		AND TRIP_DISTANCE <= 10 THEN '4: 7-10'
		WHEN TRIP_DISTANCE > 10 THEN '5: 10+'
		ELSE 'unknown'
	END AS TRIP_DISTANCE_GROUP,
	COUNT(*) AS TRIP_COUNT
FROM
	GREEN_TAXI_TRIPS
WHERE
	DATE_TRUNC('day', LPEP_DROPOFF_DATETIME) BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY
	TRIP_DISTANCE_GROUP;
```
Result:

![query result for question 3](./module_1/homework/hw1_q3.png)


<b>Question 4. Longest trip for each day</b>

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.


<b>Answer:</b>
Query:
```SQL
SELECT
	DATE_TRUNC('day', LPEP_PICKUP_DATETIME) AS DATE,
	MAX(TRIP_DISTANCE) AS MAX_DISTANCE
FROM
	GREEN_TAXI_TRIPS
WHERE
	DATE_TRUNC('day', LPEP_PICKUP_DATETIME) BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY
	DATE_TRUNC('day', LPEP_PICKUP_DATETIME)
ORDER BY
	MAX_DISTANCE DESC
LIMIT
	1;
```

Result:

![query result for question 4](./module_1/homework/hw1_q4.png)


<b>Question 5. Three biggest pickup zones</b>

Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

Query:
```SQL
SELECT
	ZONES."Zone",
	ROUND(CAST(TOTAL_AMOUNT_PER_ZONE AS NUMERIC), 2) AS TOTAL_AMOUNT_PER_ZONE
FROM
	(
		SELECT
			"PULocationID",
			SUM(TOTAL_AMOUNT) AS TOTAL_AMOUNT_PER_ZONE
		FROM
			GREEN_TAXI_TRIPS
		WHERE
			DATE_TRUNC('day', LPEP_PICKUP_DATETIME) = '2019-10-18'
		GROUP BY
			"PULocationID"
	) AS TOTAL_AMOUNT_AGG
	JOIN ZONES ON "PULocationID" = "LocationID"
WHERE
	TOTAL_AMOUNT_PER_ZONE > 13000;
```

Result:

![query result for question 5](./module_1/homework/hw1_q5.png)


<b>Question 6. Largest tip</b>

For the passengers picked up in October 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

Query:
```SQL
SELECT
	DZ."Zone" AS "DOZone",
	MAX(TRIPS.TIP_AMOUNT) AS MAX_TIP
FROM
	GREEN_TAXI_TRIPS AS TRIPS
	LEFT JOIN ZONES AS PZ ON TRIPS."PULocationID" = PZ."LocationID"
	LEFT JOIN ZONES AS DZ ON TRIPS."DOLocationID" = DZ."LocationID"
WHERE
	DATE_TRUNC('day', LPEP_PICKUP_DATETIME) BETWEEN '2019-10-01' AND '2019-10-31'
	AND PZ."Zone" = 'East Harlem North'
GROUP BY
	DZ."Zone"
ORDER BY
	MAX_TIP DESC
LIMIT
	1;
```

Result:

![query result for question 6](./module_1/homework/hw1_q6.png)

</details>

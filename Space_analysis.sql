--to see the amount of companies involved in space missions and there are 62 of them
SELECT Company,
COUNT (Company) AS count_of_company
FROM `my-maven-projects.space_missions.missions_data` 
GROUP BY Company
ORDER BY count_of_company DESC 

--to see the number of rockets that have been to space
SELECT Rocket,
COUNT (Rocket) AS count_of_rockets
FROM `my-maven-projects.space_missions.missions_data`
GROUP BY Rocket
ORDER BY count_of_rockets DESC

--to find the percentage of rocket status that is active and the percentage that is retired
SELECT RocketStatus,
COUNT (RocketStatus) AS active_rockets,
(
  SELECT COUNT(RocketStatus)
  FROM `my-maven-projects.space_missions.missions_data`
) AS total_rocketststus,
ROUND(COUNT (RocketStatus)/(SELECT COUNT(RocketStatus) FROM `my-maven-projects.space_missions.missions_data`) *100,0) AS percentage_of_active_rockets
FROM `my-maven-projects.space_missions.missions_data`
WHERE RocketStatus = "Active"
GROUP BY RocketStatus

--to group the rocket launches by year and see which year the space exploration wAS more popular
WITH count_of_exploration_by_year AS(
  SELECT EXTRACT (Year FROM Date) AS year_of_exploration,
  COUNT (EXTRACT (Year FROM Date)) AS count_of_exploration
  FROM `my-maven-projects.space_missions.missions_data`
  GROUP BY EXTRACT (Year FROM Date) 
) 
SELECT *
FROM count_of_exploration_by_year
ORDER BY year_of_exploration DESC

--percentage of Mission status that were successful
SELECT MissionStatus,
COUNT (MissionStatus) AS count_of_missionstatus,
(
  SELECT COUNT (MissionStatus)
  FROM `my-maven-projects.space_missions.missions_data` 
) AS total_count_of_missions,
ROUND(COUNT (MissionStatus)/( SELECT COUNT (MissionStatus) FROM `my-maven-projects.space_missions.missions_data`)*100, 2) AS percentage_of_missions
FROM `my-maven-projects.space_missions.missions_data`
--WHERE MissionStatus = "Success"
GROUP BY MissionStatus

SELECT *
FROM `my-maven-projects.space_missions.missions_data`
WHERE RocketStatus = "Active"
ORDER BY Price DESC 

--to separate the location by country, then check to see how many missions they went on and how many of these missions were actually successful
WITH Main_location AS 
(
  SELECT  array_reverse(split(Location,','))[OFFSET(0)] AS location
  FROM `my-maven-projects.space_missions.missions_data`
),
 succesful_countries AS 
 (
  SELECT  array_reverse(split(Location,','))[OFFSET(0)] AS location,
  COUNT (MissionStatus) AS succces_missions
  FROM `my-maven-projects.space_missions.missions_data`
  WHERE MissionStatus = "Success"
  GROUP BY location
)
SELECT  Main_location.location,
succesful_countries.succces_missions,
COUNT (Main_location.location) AS count_of_location,
--the next line of code helps to compare the total succesful missions by the total missions to see how succesful each country hAS been in space exploration
ROUND ((succesful_countries.succces_missions/COUNT (Main_location.location))*100, 2) AS percentage_of_successful_missions
FROM Main_location FULL OUTER JOIN succesful_countries
ON Main_location.location = succesful_countries.location
GROUP BY Main_location.location, succesful_countries.succces_missions
ORDER BY COUNT (Main_location.location) DESC 

--to see which companies involved in space missions since 1957
SELECT  Company,
COUNT (Company) AS count_of_company
FROM `my-maven-projects.space_missions.missions_data`
GROUP BY Company
ORDER BY COUNT (Company) DESC 
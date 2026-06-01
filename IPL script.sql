create database IPL;
use IPl;
alter table `ipl matches 2008-2020` rename to matches;
alter table matches add season int;
select year(str_to_date(date,'%d-%m-%Y')) as season from matches;
update matches set season=YEAR(STR_TO_DATE(date, '%m/%d/%Y')); 
desc matches;
select * from matches;
--- 1 How many IPL matches have been played?---
SELECT COUNT(*) AS Total_Matches
FROM matches;

--- 2 How many IPL seasons are present?---
SELECT COUNT(DISTINCT season) AS Total_Seasons
FROM matches;
---- 3 Top 5 performance teams in ipl?

SELECT winner,
       COUNT(*) AS Wins
FROM matches
GROUP BY winner
ORDER BY Wins DESC
LIMIT 5;
--- 4 how many matches played by venues?

SELECT venue,
       COUNT(*) AS Matches_Played
FROM matches
GROUP BY venue
ORDER BY Matches_Played DESC
LIMIT 5;
--- 5 Toss descions take by teams ---
SELECT toss_decision,
       COUNT(*) AS Total
FROM matches
GROUP BY toss_decision;
---- 6 number of matches win by each team --
SELECT COUNT(*) AS Toss_and_Match_Win
FROM matches
WHERE toss_winner = winner;
--- 7 Toss percentage by each team ----
SELECT
ROUND(
COUNT(CASE WHEN toss_winner = winner THEN 1 END)
*100.0/COUNT(*),2
) AS Toss_Success_Percentage
FROM matches;
---- 8 Top 10 POTM awards by players ---
SELECT player_of_match,
       COUNT(*) AS Awards
FROM matches
GROUP BY player_of_match
ORDER BY Awards DESC
LIMIT 10;

---- 9 Toss wins by each team ---
SELECT toss_winner,
       COUNT(*) AS Toss_Wins
FROM matches
GROUP BY toss_winner
ORDER BY Toss_Wins DESC;
--- 10 Percentage of toss wins ---
SELECT winner,
       COUNT(*) AS Wins,
       ROUND(
       COUNT(*)*100.0/
       (SELECT COUNT(*) FROM matches),
       2
       ) AS Win_Percentage
FROM matches
GROUP BY winner
ORDER BY Win_Percentage DESC;
---- 11 Number of matches by each season----
SELECT season,
       COUNT(*) AS Matches
FROM matches
GROUP BY season
ORDER BY Matches DESC
LIMIT 13;
 --- 12 Top player each season ---
 SELECT season,
       player_of_match,
       COUNT(*) AS Awards
FROM matches
GROUP BY season, player_of_match
ORDER BY season, Awards DESC;
--- 13 Team won by chase and defends ---
SELECT result,
       COUNT(*) AS matches
FROM matches
GROUP BY result;
---- 14  team wins by  runs >50 ---
SELECT winner,
       COUNT(*) AS big_wins
FROM matches
WHERE result='runs'
AND result_margin > 50
GROUP BY winner
ORDER BY big_wins DESC;
---- 15 team wins by wickets >8 ---
SELECT winner,
       COUNT(*) AS dominant_chases
FROM matches
WHERE result='wickets'
AND result_margin >= 8
GROUP BY winner
ORDER BY dominant_chases DESC;
--- 16 Top 4 teams every season ---
SELECT *
FROM (
    SELECT season,
           winner,
           COUNT(*) wins,
           DENSE_RANK() OVER(
           PARTITION BY season
           ORDER BY COUNT(*) DESC
           ) rnk
    FROM matches
    GROUP BY season,winner
) x
WHERE rnk <= 4;

------PIG-------------
vgsales = LOAD 'Vgsales.csv' USING PigStorage(',') AS(ID:int, Name:chararray, Platform:chararray, Year:int, Genre:chararray, Publisher:chararray, NA_Sales:int, EU_Sales:int, JP_Sales:int, Other_Sales:int, Global_Sales:int);
--DUMP vgsales;

vgrating = LOAD 'VgsalesRating.csv' USING PigStorage(',') AS(ID:int, Name:chararray, Critic_Score:int, Critic_Count:int, User_Score:int, User_Count:int, Developer:chararray, Rating:chararray);
--DUMP vgrating;

sentiment = LOAD 'Sentiment.csv' USING PigStorage(',') AS(ID:int, Name:chararray, GameAbbr:chararray, PositiveSentiments:int, NegativeSentiments:int, Total:int);
--DUMP sentiment;

select = FOREACH vgsales GENERATE ID,Name,Genre;
globalsale = FILTER vgsales by Global_Sales>10;
--dump globalsale;
critic = FILTER vgrating by Critic_Score>70;
--dump critic;
positive = FILTER sentiment by PositiveSentiments!=0;
--dump positive;
playerdata = JOIN select by ID, critic by ID, positive by ID;

club_group = GROUP playerdata by Genre;
dump club_group;
STORE club_group into 'Pigout2' USING PigStorage(',');


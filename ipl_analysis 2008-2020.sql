use projects

select * from [ipl analysis sql]


---categorised the city according to no. of matches played there grouped it like(a,b,c,d)
---'a' for when cnt>61 then 'a'
---'b' for when cnt between 41 and 60 then 'b'
---'c' for when cnt between 16 and 40 then 'c'
---'d' for when cnt<=15 then 'd'



select *,row_number() over (partition by groups order by cnt desc)row_no from
(select * ,
case when cnt<=15 then 'd'
 when cnt between 16 and 40 then 'c'
 when cnt between 41 and 60 then 'b'
 when cnt>61 then 'a' end groups
 from
 (select city,count(city)cnt from [ipl analysis sql]
group by city
)k)h 



---no. of matches playey in perticular ground


select venue,count(venue)cnt
from [ipl analysis sql]
group by venue
order by cnt desc



---percentage of value according no. of matches played in perticular ground


select * from
(select *,cnt*100/816 percentage_value from
(select venue,count(venue)cnt
from [ipl analysis sql]
group by venue
)a)b order by percentage_value desc



---no. of matches played in march 2010


select count(mnth)total_matches from
(select [date] ,datepart(mm,[date])mnth from
(select *
from [ipl analysis sql]
where year([date])='2010')a)b
where mnth=3



---no. of matches played in march 2010 on perticular dates


select *, count(mnth)matches_on_perticular_date from
(select [date] ,datepart(mm,[date])mnth from
(select *
from [ipl analysis sql]
where year([date])='2010')a)b
where mnth=3
group by date,mnth




---who got the maximum number of player of the match title in 2011


select player_of_match,cnt from
(select player_of_match,cnt,row_number() over (order by cnt desc)rnk from
(select player_of_match,count(player_of_match)cnt
from [ipl analysis sql]
where year([date])=2011
group by player_of_match)a)b
where rnk=1




---who won the title of ipl from 2008-2012 



select winner,2008 as ipl_title_year from
(select  winner,count(winner)cnt from [ipl analysis sql]
where year([date])=2008
group by winner)a where cnt=13

union all

select winner,2009 as ipl_title_year from
(select  winner,count(winner)cnt from [ipl analysis sql]
where year([date])=2009
group by winner)a where cnt=10

union all
select winner,2010 as ipl_title_year from
(select  winner,count(winner)cnt from [ipl analysis sql]
where year([date])=2010
group by winner)a where cnt=11

union all
select winner,2011 as ipl_title_year from
(select  winner,count(winner)cnt from [ipl analysis sql]
where year([date])=2011
group by winner)a where cnt>=11

union all
select winner,2012 as ipl_title_year from
(select  winner,count(winner)cnt from [ipl analysis sql]
where year([date])=2012
group by winner)a where cnt>=12



---which team won the most no. of toss in year 2020


select * from
(select toss_winner,count(toss_winner)toss_cnt
from [ipl analysis sql]
where year(date)=2020
group by toss_winner
)a
where toss_cnt=11



---show the team who win the toss and also win the match in 2020


select o.team,o.win_matches_on_toss,p.total_toss_win from

(select winner as team,count(condition) win_matches_on_toss from
(select toss_winner,winner,
case when toss_winner=winner then 1 else 0 end condition
from [ipl analysis sql]
where year(date)=2020)a 
where condition=1
group by winner)o

join

---total no. of toss win by any team in year 2020


(select toss_winner as team,count(toss_winner)total_toss_win
from [ipl analysis sql]
where year([date])=2020
group by toss_winner)p

on o.team=p.team





---total no. of matches played by the teams in 2020



select Team,count(Team)total_matches from
(select team1 as Team from [ipl analysis sql] where year([date])=2020

union all

select team2 as Team from [ipl analysis sql] where year([date])=2020)a
group by Team



---points table before the final match

select * from [ipl analysis sql]


select *,no_of_matches_won*2 points from
(select winner, count(winner)no_of_matches_won from  [ipl analysis sql] 
where year(date)=2020  and date !=

(select max(date)from
(select date from [ipl analysis sql] where year(date)=2020)a)group by winner)b
order by points desc


---teams what do after winning the toss count it according to bat and ball in 2020



select toss_winner, toss_decision,count(toss_decision)decision from [ipl analysis sql] 
where year(date)=2020
group by toss_decision,toss_winner



---which team has the best winning records on dr dy patil sports academy accross the years



select winner,count(winner)win_count from
(select * from [ipl analysis sql] where venue='dr dy patil sports academy')a
group by winner order by win_count desc



---which team won with the max. runs margin in year 2016 and show all the info.



select * from [ipl analysis sql] where year(date)=2016
and result_margin=(select max(result_margin)from [ipl analysis sql] where year(date)=2016)
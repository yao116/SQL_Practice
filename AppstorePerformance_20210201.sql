-- Tutorial I used: https://www.bilibili.com/video/BV1pT4y1E7NC?from=search&seid=8720837779161223551

use app_performance;
select * from appstore;
# DELETE FROM appstore;
delete from appstore where prime_genre like '_';


-- 1、本数据的APP共有多少种类型，每个类型有多少种APP？
-- (How many distinct genre of App are there in the dataset? Each genere has how many apps?)

# a. app有几种类型/// Number of genres 
select count(distinct prime_genre)
from appstore;

# b. 每种类型下有多少app/// Number of apps under each genere
select prime_genre,count(1) as total_num
from appstore
group by prime_genre
order by total_Num desc;

# combine a,b///结合a、b,一条语句输出结果a
select temp1.*, @row_number:=@row_number+1 as 'rank'
from(select prime_genre, count(1) as total_num
    from appstore
    group by prime_genre
    order by total_num desc)temp1,
    (select @row_number :=0)temp2;
    

-- 2、那种app用户的评价最多，其平均评价为多少？
-- (Which app has the most number of ratings? What's the average number of rating of it?)

select prime_genre,sum(rating_count_tot) as comment_total_num,
	               avg(rating_count_tot) as comment_avg_num
from appstore
group by prime_genre
order by comment_total_num desc,comment_avg_num desc


-- 3、APPSSTORE种各种类型app评价数目最多的APP是哪些？
-- (Which app has the most number of ratings under each genre?)
select prime_genre, track_name, rating_count_tot
from appstore a
where rating_count_tot >= ALL(
	select rating_count_tot
    from appstore b
    where a.prime_genre=b.prime_genre)
order by rating_count_tot DESC;

-- 4、不同价位不同类型的APP所占百分比是多少？
-- (Distribution of apps of different genre & price level)

select prime_genre, sum(case when price=0 then 1 end)/count(prime_genre) as '0',
					sum(case when price>0 and price<=1 then 1 end)/count(prime_genre) as '0-1',
                    sum(case when price>1 and price<=2 then 1 end)/count(prime_genre) as '1-2',
                    sum(case when price>2 and price<=3 then 1 end)/count(prime_genre) as '2-3',
                    sum(case when price>3 and price<=4 then 1 end)/count(prime_genre) as '3-4',
                    sum(case when price>4 and price<=5 then 1 end)/count(prime_genre) as '4-5',
                    sum(case when price>5 and price<=10 then 1 end)/count(prime_genre) as '5-10',
                    sum(case when price>10 then 1 end)/count(prime_genre) as '>10'
from appstore
group by prime_genre


-- 5、类型如Games、Health、Social networking、Utilities、Productivity的评论数目在前三的app分别是？
-- （What's the top 3 app (based on number of ratings) 
-- in genres like Games、Health、Social networking、Utilities、Productivity?）

(select prime_genre,track_name,rating_count_tot,user_rating
from appstore
where prime_genre='Games'
order by rating_count_tot desc
limit 3)
union all
(select prime_genre,track_name,rating_count_tot,user_rating
from appstore
where prime_genre='Health'   
order by rating_count_tot desc
limit 3)
union all
(select prime_genre,track_name,rating_count_tot,user_rating
from appstore
where prime_genre='Social networking'
order by rating_count_tot desc
limit 3)
union all
(select prime_genre,track_name,rating_count_tot,user_rating
from appstore
where prime_genre='Utilities'
order by rating_count_tot desc
limit 3)
union all
(select prime_genre,track_name,rating_count_tot,user_rating
from appstore
where prime_genre='Productivity'
order by rating_count_tot desc
limit 3);


-- 6、鹅厂的APP表现如何？
-- (What's the performance of Tencent's apps?)

select track_name,rating_count_tot,user_rating
from appstore 
where track_name like '%QQ%' or track_name like '%wechat%' or track_name like '%腾讯%'
order by rating_count_tot desc, user_rating desc;


-- 7、直播类的APP都有哪些？
-- (What's the performance of streaming apps?)
select track_name,rating_count_tot,user_rating
from appstore 
where track_name like '%直播%' or track_name like '%LIVE%'
order by rating_count_tot desc, user_rating desc;
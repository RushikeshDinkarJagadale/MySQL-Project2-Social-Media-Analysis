# WEDNESDAY
#11 SEP 2024

#Project-2
#Social Media Analysis


-- Designed and implemented a MySQL-based social media analysis project, 
-- leveraging relational database capabilities to efficiently 
-- store, retrieve, and analyze extensive social media data. 
-- Developed features including user profiles, post storage, s
-- entiment analysis, and trend tracking to provide 
-- aluable insights into user behavior and trending topics. 
-- Demonstrated proficiency in database management for 
-- effective data organization and retrieval, showcasing 
-- a keen understanding of scalable and well-structured MySQL systems



#Task-1 Data Collection
USE social_media;
SHOW tables;

-- total 13 tables are present in database

-- bookmarks
-- comment_likes
-- comments
-- follows
-- hashtag_follow
-- hashtags
-- login
-- photos
-- post
-- post_likes
-- post_tags
-- users
-- videos

-- ER diagram

#Task-2 Check and Explore ER diagram


#Task-3 Total Users
SELECT count(*) FROM users;

#total 50 users data available

#Task-4 Total post
SELECT count(post_id) FROM post;

-- Total 100 Post are available in our database

#Task-5 User location
SELECT location FROM Post;

-- location is not mentioned in proper way

#Task-6 average post per user
SELECT DISTINCT user_id FROM post;

SELECT count(post_id)/(SELECT count(DISTINCT user_id) FROM post)
FROM post;

--  on an average 2 post are done by each user

#Task-7 find users who have not posted yet
SELECT * FROM users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM post);

SELECT * 
FROM users u1 LEFT JOIN post p1
ON u1.user_id = p1.user_id
WHERE p1.post_id IS NULL;

-- 5 users out of 50 have not posted yet

#Task-8 Display users who have posted 5 or more than 5 post

SELECT u1.user_id,u1.username, count(p1.post_id) total_post
FROM users u1 INNER JOIN post p1
ON u1.user_id = p1.user_id
GROUP BY u1.user_id,u1.username
HAVING total_post>=5;

-- 4 users have posted 5 or more than 5 post

#Task-9 dispaly users with 0 comment
SELECT * FROM comments;

SELECT * FROM Users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM comments);

SELECT * 
FROM users u1 LEFT JOIN comments c1
ON u1.user_id = c1.user_id
WHERE c1.comment_id IS NULL;

-- Just 1 user Raj Gupta has not commented yet

#Task-10 people who have been using the platform for the longest time

SELECT * FROM Users
ORDER BY created_at ASC
LIMIT 10;

#Task-11 Find Longest Captions In Post
SELECT Caption, length(caption) lengthOfCaption
FROM Post
ORDER BY lengthOfCaption DESC
LIMIT 1;

#Task-12 Find  post which has beauty and beautifull
SELECT post_id,caption FROM post WHERE caption regexp'beauty|beautiful';

-- there are 3 post which has beauty and beautiful in their caption

#Task-13 dispaly comments len>=12 char
SELECT * FROM comments
WHERE length(comment_text)>=12;
-- there are 172 comment which has length >=12

#Task-14 find user who has followers >=40

SELECT followee_id,count(follower_id) follower_count 
FROM follows
GROUP BY followee_id
HAVING follower_count>=40;

-- 14 users have followers >=40 

#Task-15 display most liked post
SELECT post_id,count(*) total 
FROM post_likes
GROUP BY post_id
ORDER BY total DESC
LIMIT 1;

SELECT p1.post_id,p2.caption,p2.user_id,count(*) total
FROM post_likes p1 INNER JOIN post p2
ON p1.post_id=p2.post_id
GROUP BY p1.post_id
ORDER BY total DESC
LIMIT 1;

-- post_id 42 is most liked post

SELECT 
    p1.post_id,
    p2.caption,
    p3.username,
    COUNT(*) AS total
FROM 
    post_likes p1
INNER JOIN 
    post p2 ON p1.post_id = p2.post_id
INNER JOIN
    users p3 ON p2.user_id = p3.user_id
GROUP BY 
    p1.post_id, p2.caption, p3.username
ORDER BY 
    total DESC
    
    LIMIT 1;


#Task-16  list users who have not received any colmments or likes on their post

-- comment
SELECT post_id,caption,user_id FROM post
WHERE post_id NOT IN (SELECT DISTINCT post_id FROM comments);
--  10 posts are in the data on which there is no any comment

-- likes
SELECT post_id,caption,user_id FROM post
WHERE post_id NOT IN (SELECT DISTINCT post_id FROM post_likes);
-- no any post

#Task-17 Find most commonly used hashtags

SELECT h1.hashtag_name,
Count(h1.hashtag_name) AS 'tags_count'
FROM hashtags h1
inner JOIN post_tags p1
ON h1.hashtag_id = p1.hashtag_id
GROUP BY h1.hashtag_name
ORDER BY tags_count DESC;

-- '#beautiful' is most commonly used hashtag.

#Task-18 Find most followed hashtags

SELECT h1.hashtag_name,
Count(h1.hashtag_name) AS total
FROM hashtags h1 inner JOIN hashtag_follow p1
ON h1.hashtag_id = p1.hashtag_id
GROUP BY h1.hashtag_name
ORDER BY total desc
LIMIT 5;

-- '#festive sale is most followed hashtag in data

#Task-19 Display Users who don't follow anybody

SELECT * FROM users WHERE 
user_id NOT IN (SELECT follower_id FROM follows);

#Task-20 Most inactive user ..(post concept)

SELECT user_id,username FROM users WHERE
user_id NOT IN (SELECT DISTINCT user_id FROM post);

# Most inactive user
-- 46	Cameron
-- 48	George
-- 49	Jamie
-- 33	Joshua
-- 41	Ollie

#Task-21 most inactive user ...(comment concept)
SELECT * FROM users where user_id
NOT IN (SELECT user_id FROM comments);

-- Just 1 user Raj Gupta has not commented yet

#Task-22 most inactive user ....(post likes)
SELECT user_id,username FROM users 
where user_id NOT IN (SELECT DISTINCT user_id FROM post_likes);

#Task-23 CHECK FOR BOT,
-- users who commented on every post

SELECT username,count(*) num_comment
FROM users u1 INNER JOIN comments c1
ON u1.user_id=c1.user_id
GROUP BY u1.user_id 
HAVING num_comment >=(SELECT count(distinct post_id) FROM comments);

#Task-24 CHECK FOR BOT
-- Users who like every post

SELECT p1.user_id,count(*) total
FROM Post p1 INNER JOIN post_likes p2
ON p1.post_id=p2.post_id
GROUP BY p1.user_id
HAVING total>=(SELECT count(DISTINCT post_id)FROM post_likes);

-- user_id 37(Ethan) may be bot
SELECT * FROM users
WHERE user_id=37;

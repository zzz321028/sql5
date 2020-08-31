
CREATE DATABASE student_examination_sys;
USE student_examination_sys;
drop table if exists student;
create table  student  
( id     varchar(5)  not null,
 name   varchar(10),
age    int ,
sex    varchar(1)
);
insert into student(id,name,age,sex)
values( '001','张三',18,'男'),('002','李四',20,'女');
-- 
drop table if exists subject;
create table  subject  
(id           int  not null,
subject      varchar(10),
teacher      varchar(10),
description  varchar(20)
);
insert into subject(id,subject,teacher,description)
values( 1001,'语文','王老师','本次考试比较简单'),(1002,'数学','刘老师','本次考试比较难');
-- 
drop table if exists score;
create table  score  
( id    int  not null,
student_id   varchar(5),
subject_id   int,
score     float
);
insert into score(id,student_id,subject_id,score)
values( 1,'001',1001,80),(2,'002',1001,75),(3,'001',1002,70),(4,'002',1002,60.5);
-- /*展示结果*/
select * from student;
select * from subject;
select * from score;
show tables;

DROP PROCEDURE IF EXISTS calc_student_stat;
create procedure calc_student_stat()

BEGIN
 DROP TEMPORARY TABLE IF EXISTS student_stat_1temp;
 CREATE TEMPORARY TABLE student_stat_1temp  AS
 SELECT t1.student_id, t1.subject_id,t1.score, t2.total_score,t3.avg_score,t1.score/t2.total_score as score_rate 
   FROM score  AS  t1
   LEFT JOIN  (SELECT student_id,sum(score) AS total_score 
                FROM score 
               GROUP BY student_id)  AS  t2 
	   ON t1.student_id	=	t2.student_id
   LEFT JOIN (SELECT subject_id,avg(score) AS avg_score
               FROM score 
              GROUP BY subject_id)   AS t3
     ON t1.subject_id	=	t3.subject_id;

 DROP TABLE IF EXISTS student_stat;
 CREATE TABLE student_stat AS
 SELECT b.name,c.subject,c.teacher,a.score, a.total_score,a.avg_score,a.score_rate
   FROM student_stat_1temp  AS  a
   LEFT JOIN	 student  as b
		 ON 	a.student_id	=	b.id		
	 LEFT JOIN	 subject  as c
		 ON  a.subject_id = c.id;
END;

CALL calc_student_stat();





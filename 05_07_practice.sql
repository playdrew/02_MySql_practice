use chundb;

-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른순으로 표시하는 SQL 문장을 작성하시오.

select
	STUDENT_NO as 학번
	,STUDENT_NAME as 이름
    ,ENTRANCE_DATE as 입학년도
from
	tb_student
order by
	ENTRANCE_DATE asc;
    
-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 두 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 

select
	 PROFESSOR_NAME 교수이름
    ,PROFESSOR_SSN 주민번호
from
	tb_professor
where
    CHAR_LENGTH(PROFESSOR_NAME) <> 3;
    
-- CHAR_LENGTH(STRING)길이를 반환하는 함수
-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. 
-- (단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)

select
	 PROFESSOR_NAME AS 교수이름,
    CASE
		WHEN MONTH(CURDATE()) >= SUBSTRING(PROFESSOR_SSN, 3,2) 
        AND DAY(CURDATE()) >= SUBSTRING(PROFESSOR_SSN, 5, 2)
        THEN YEAR(NOW()) - (1900 + SUBSTRING(PROFESSOR_SSN, 1, 2))
        ELSE YEAR(NOW()) - (1900 + SUBSTRING(PROFESSOR_SSN, 1, 2)) - 1
        END AS 나이
from
	tb_professor
WHERE
	PROFESSOR_SSN LIKE '______-1%'
order by
	나이 ASC;

 
 -- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는’이름’ 이 찍히도록 핚다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
 
select
	substring(PROFESSOR_NAME,2,2)
from
	tb_professor;
    
-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 만 19살이 되는 해에 입학하면 재수를 하지 않은 것으로 간주한다.

select 
    student_no,
    student_name,
    extract(year from entrance_date),
    (substr(student_ssn,1,2)+1900)
from TB_Student
where extract(year from entrance_date)-(substr(student_ssn,1,2)+1900) > 19;

-- 입학년도에서 나이를 뺐는데 19살이상이면 재수생
-- 6. 2020년 크리스마스는 무슨 요일이었는가?

SELECT 
    DAYNAME('2020-12-25') AS 요일;
    
-- 7. STR_TO_DATE('99/10/11', '%y/%m/%d') STR_TO_DATE('49/10/11', '%y/%m/%d')은 각각 몇 년 몇 월 몇 일을 의미할까? 

select
	STR_TO_DATE('99/10/11', '%y/%m/%d') as 날짜1,
	STR_TO_DATE('49/10/11', '%y/%m/%d') as 날짜2;
    
-- 8.학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.

select
	round(avg(round(POINT,1)),1) as 평점
from
	tb_grade
where
	STUDENT_NO = 'A517178';

-- 9번) 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오

select
    DEPARTMENT_NO as 학과번호,
    COUNT(STUDENT_NO) as 학생수
from
	tb_student
group by
	DEPARTMENT_NO;

-- 10.지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오

select
	COUNT(STUDENT_NO)
from
	tb_student
where
	COACH_PROFESSOR_NO is null;
    
-- 11.학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.

SELECT
SUBSTRING(TERM_NO,1,4) AS '년도' ,
ROUND(AVG(POINT),1) AS '평점'
FROM tb_grade
GROUP BY
SUBSTRING(TERM_NO,1,4);

-- 12.학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.

select
	DEPARTMENT_NO as '학과' ,
    COUNT(STUDENT_NO) as '휴학생수'
from
	tb_student
where
	ABSENCE_YN = 'Y'
group by
	DEPARTMENT_NO;

-- 13.춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤 SQL 문장을 사용하면 가능하겠는가?

SELECT STUDENT_NAME AS "동일이름",
		COUNT(*) AS "동명인 수"
FROM tb_student
GROUP BY STUDENT_NAME
HAVING COUNT(*) != 1
ORDER BY 1;

-- 14. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총평점을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.

SELECT SUBSTRING(TERM_NO,1,4) AS "년도",
	   SUBSTRING(TERM_NO,5,2) AS "학기",
       ROUND(AVG(POINT), 1) AS "평점"
FROM tb_grade
WHERE STUDENT_NO = 'A112113'
GROUP BY
	SUBSTRING(TERM_NO,1,4) ,SUBSTRING(TERM_NO,5,2)

union all

SELECT SUBSTRING(TERM_NO,1,4) AS "년도",
	   null AS "학기" ,
       ROUND(AVG(POINT), 1) AS "평점"
FROM tb_grade
WHERE STUDENT_NO = 'A112113'
GROUP BY
	SUBSTRING(TERM_NO,1,4)
order by
	년도;


	
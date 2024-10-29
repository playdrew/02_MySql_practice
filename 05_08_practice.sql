USE CHUNDB;

-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다

select
	STUDENT_NAME AS 학생이름,
    STUDENT_ADDRESS AS 주소지
FROM
	tb_student
order by
	STUDENT_NAME ASC;
    
-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.

select
	STUDENT_NAME AS 학생이름,
    STUDENT_SSN AS 주민번호
FROM 
	tb_student
where
	ABSENCE_YN = 'Y'
order by
	YEAR(NOW()) - IF(substring(STUDENT_SSN,1,2) between 50 AND 99, 1900 + substring(STUDENT_SSN,1,2), 2000 + substring(STUDENT_SSN,1,2));
    
use chundb;
    
-- 3. 주소지가 강원도나 경기도인 학생들 중 2020년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번", "거주지 주소" 가 출력되도록 한다

select
	STUDENT_NO AS 학번,
    STUDENT_NAME AS 이름,
    STUDENT_ADDRESS AS 주소
from 
	tb_student s
where
	year(ENTRANCE_DATE) >= 2020 and
	STUDENT_ADDRESS LIKE '강원%' or STUDENT_ADDRESS LIKE '경기%'
order by
	이름;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오. (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
-- PROFESSOR_NAME PROFESSOR_SSN
-- -------------------- --------------
-- 홍남수 540304-1112251
-- 김선희 551030-2159000
-- 임진숙 640125-1143548
-- 이미경 741016-2103506
SELECT
	PROFESSOR_NAME AS 교수이름
    ,PROFESSOR_SSN AS 주민번호
FROM
	TB_PROFESSOR
WHERE 
	DEPARTMENT_NO = ( SELECT 
						DEPARTMENT_NO
					 FROM
                     TB_DEPARTMENT
                     WHERE
                     DEPARTMENT_NAME = '법학과'
                     )
ORDER BY
	주민번호;
    
-- 5. 2022 년 2학기에 C3118100 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
-- STUDENT_NO POINT
-- ---------- -----
-- A331076	4.50
-- A213128	4.00
-- A219089	1.50
-- -----------------
-- 3 rows selected

select 
 student_no,
 POINT
from
TB_GRADE
WHERE
substring(TERM_NO,1,6) = 202202 AND CLASS_NO = 'C3118100' 
ORDER BY
 POINT DESC; 
 
-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오
-- STUDENT_NO STUDENT_NAME         DEPARTMENT_NAME
-- ---------- -------------------- --------------------
-- A411001 감현제 치의학과
-- A131004 강동연 디자인학과
-- ...
-- ...
-- A411335 황형철 사회학과
-- A511332 황효종 컴퓨터공학과
-- ----------------------------------------------------
-- 588 rows selected

SELECT
	s.STUDENT_NO,
	s.STUDENT_NAME,
    d.DEPARTMENT_NAME
FROM
	TB_STUDENT s JOIN tb_department d on s.department_no = d.department_no
where
	s.department_no = d.department_no
order by
	s.student_name;
    
-- 7. 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오
-- CLASS_NAME                     DEPARTMENT_NAME
-- ------------------------------ --------------------
-- 가족상담과 정신간호             간호학과
-- 가족상담실습                    간호학과
-- ...
-- ...
-- 자본시장회계연구                회계학과
-- 회계학연구방법론1               회계학과
-- ---------------------------------------------------
--  882 rows selected

select
	c.class_name
    ,d. department_name
from
	tb_class c join tb_department d using (DEPARTMENT_NO)
order by
	d.department_name;

-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
-- CLASS_NAME PROFESSOR_NAME
-- ------------------------------ --------------------
-- 19C미국소설 제상철
-- 19C미국소설 이지현
-- ...
-- ...
-- 환경생리학연구 유용석
-- 회계학연구방법론1 김봉건
-- --------------------------------------------------
-- 776 rows selected

select
	c.class_name
    ,p.professor_name
from
	tb_class c join tb_professor p using (DEPARTMENT_NO)
order by
	class_name;
    
-- 9. 8 번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
-- CLASS_NAME PROFESSOR_NAME
-- ------------------------------ --------------------
-- 고전시가론특강 김선정
-- 국어어휘론특강 김선정
-- ...
-- ...
-- --------------------------------------------------
-- 197 rows selected

select
	c.class_name
    ,p.professor_name
from
	tb_class c join tb_professor p using (DEPARTMENT_NO),
    tb_class c join tb_department d using (DEPARTMENT_NO)
where
	d.CATEGORY = '인문사회';
    
-- 10.‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.)  
-- 학번 학생 이름 전체 평점
-- ---------- -------------------- ----------
-- A612052 신광현 4.1
-- A9931310 조기현 4.1
-- A431021 구병훈 3.9
-- A431358 조상진 3.7
-- A411116 박현화 3.6
-- A354020 양재영 3.5
-- A557031 이정범 3.3
-- A415245 조지선 3.2
-- --------------------------------------------
-- 8 rows selected

select
	s.STUDENT_NO 학번 ,
    s.STUDENT_NAME 학생이름,
    ROUND(AVG(g.POINT),1) 전체평점
from
	tb_student s join tb_department d on s.DEPARTMENT_NO = d.DEPARTMENT_NO
    join tb_grade g on s.STUDENT_NO = g.STUDENT_NO
where
	d.DEPARTMENT_NAME = '음악학과'
group by
	s.STUDENT_NO , s.STUDENT_NAME
ORDER BY
	ROUND(AVG(g.POINT),1) DESC;
    
--  11. 학번이 `A313047` 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을 작성하시오 
--  단, 출력헤더는 ‚’학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로 출력되도록 한다.
-- 학과이름 학생이름 지도교수이름
-- -------------------- -------------------- --------------------
-- 경제학과 손건영 박태환

select
	d.DEPARTMENT_NAME 학과이름,
    s.STUDENT_NAME 학생이름,
    p.PROFESSOR_NAME 지도교수이름
from
	tb_student s join tb_department d on s.DEPARTMENT_NO = d.DEPARTMENT_NO
    join tb_professor p on s.COACH_PROFESSOR_NO = p.PROFESSOR_NO
where
	s.STUDENT_NAME = '손건영';
    
-- 12. 2022년도에 인간관계론 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오
-- STUDENT_NAME TERM_NAME
-- -------------------- --------------------
-- 최지현	202201

select
	s.STUDENT_NAME,
    g.TERM_NO TERM_NAME
from
	tb_student s join tb_class c on s.DEPARTMENT_NO = c.DEPARTMENT_NO
    join tb_grade g on s.STUDENT_NO = g.STUDENT_NO
where
	c.CLASS_NAME='인간관계론' and g.TERM_NO LIKE '2022%';
    
-- 13. 예체능 계열 과목 중 과목 담당교수를 한명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
-- CLASS_NAME DEPARTMENT_NAME
-- ------------------------------ --------------------
-- CELLO실기2 음악학과
-- FLUTE실기2 음악학과B
-- ...
-- ...
-- 환경디자인특론 디자인학과
-- 회화재료연습 미술학과
-- --------------------------------------------------
-- 44 rows selected

SELECT CLASS_NAME, DEPARTMENT_NAME FROM TB_CLASS 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO) 
WHERE CATEGORY = '예체능' AND PROFESSOR_NO IS NULL;

-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 지도교수 이름을 찾고 맡길 지도 교수가 없는 학생일 경우 "지도교수 미지정”으로 표시하도록 하는 SQL 문을 작성하시오. 
-- 단, 출력헤더는 “학생이름”, “지도교수”로 표시하며 고학번 학생이 먼저 표시되도록 한다
-- 학생이름 지도교수
-- -------------------- --------------------
-- 주하나 허문표
-- 이희진 남명길
-- ...
-- ...
-- 최철현 백양임
-- -----------------------------------------
-- 14 rows selected

SELECT STUDENT_NAME 학생이름, 
IFNULL(PROFESSOR_NAME, '지도교수 미지정') 지도교수 
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO) 
WHERE DEPARTMENT_NAME = '서반아어학과' ORDER BY STUDENT_NO;

-- 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.
-- 학번 이름 학과이름 평점
-- ---------- -------------------- -------------------- ----------
-- A071041 인정성 지리학과 4.1
-- A098008 김동민 의학과 4.0
-- A131231 이동인 생물학과4.0
-- ...
-- ...
-- 19 rows selected

SELECT 
STUDENT_NO 학번,
STUDENT_NAME 이름,
DEPARTMENT_NAME "학과 이름", 
ROUND(AVG(POINT), 2) 평점
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N' 
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME 
HAVING ROUND(AVG(POINT), 8) >= 4.0 ORDER BY STUDENT_NO;

-- 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오  
-- CLASS_NO   CLASS_NAME                     AVG(POINT)
-- ---------- ------------------------------ ----------
-- C3016200 전통계승방법론 3.678571
-- C3081300 조경계획방법론 3.692307
-- C3087400 조경세미나 3.909090
-- C4139300 환경보전및관리특론 3.027777
-- C4477600 조경시학 3.176470
-- C5009300 단지계획및설계스튜디오 3.375000
-- 6 rows selected

select
	c.CLASS_NO,
    c.CLASS_NAME,
    ROUND(AVG(g.POINT),8)
from
	tb_class c join tb_department d on c.DEPARTMENT_NO = d.DEPARTMENT_NO
    join tb_grade g on c.CLASS_NO = g.CLASS_NO
where
	d.DEPARTMENT_NAME='환경조경학과' and c.CLASS_TYPE like '전공%'
group by
	c.CLASS_NO,c.CLASS_NAME;
    
SELECT CLASS_NO, CLASS_NAME, ROUND(AVG(POINT), 8) "AVG(POINT)" FROM TB_CLASS 
JOIN TB_GRADE USING(CLASS_NO) 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
WHERE DEPARTMENT_NAME = '환경조경학과' AND CLASS_TYPE LIKE '전공%' 
GROUP BY CLASS_NO, CLASS_NAME ORDER BY CLASS_NO;

-- 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오 
-- STUDENT_NAME STUDENT_ADDRESS
-- -------------------- ----------------------------------------------------------
-- 기혜미 대전시 유성구 덕진동 한국원자력안전기술원 행정부장 
-- 김석민 경기도안산시상록구2동664번지투루지오2차@205/601
-- ...
-- ...
-- 17 rows selected

SELECT STUDENT_NAME, STUDENT_ADDRESS FROM TB_STUDENT 
WHERE DEPARTMENT_NO = (
    SELECT DEPARTMENT_NO FROM TB_STUDENT 
    WHERE STUDENT_NAME = '최경희');
    
-- 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오
-- STUDENT_NO STUDENT_NAME
-- ---------- --------------------
-- A9931165 송근우 
SELECT STUDENT_NO, STUDENT_NAME FROM (
    SELECT STUDENT_NO, STUDENT_NAME FROM TB_STUDENT 
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
    JOIN TB_GRADE USING(STUDENT_NO) 
    WHERE DEPARTMENT_NAME = '국어국문학과' 
    GROUP BY STUDENT_NO, STUDENT_NAME 
    ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;

-- 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
-- 계열 학과명 전공평점
-- -------------------- --------
-- 간호학과 3.2
-- 물리학과 3.3
-- ...
-- ...
-- 환경조경학과 3.3
-- 20 rows selected

SELECT DEPARTMENT_NAME "계열 학과명", 
ROUND(AVG(POINT), 1) 전공평점 FROM TB_DEPARTMENT 
JOIN TB_CLASS USING(DEPARTMENT_NO) 
JOIN TB_GRADE USING(CLASS_NO) 
WHERE CATEGORY = (
    SELECT CATEGORY FROM TB_DEPARTMENT 
    WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%' 
GROUP BY DEPARTMENT_NAME ORDER BY DEPARTMENT_NAME;
	
	




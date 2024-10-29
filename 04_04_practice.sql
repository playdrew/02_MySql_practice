use employee;

-- 1.부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회

select * from employee where DEPT_CODE = (
										  select
                                          DEPT_CODE
                                          from 
                                          employee
                                          where
                                          EMP_NAME = '노옹철'
                                          );

	-- 2.전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
	-- 사번, 이름, 직급코드, 급여를 조회하세요
    
select avg(SALARY) from employee;

select  EMP_ID as '사번'
	   ,EMP_NAME as '이름'
	   ,JOB_CODE as'직급코드' 
       ,SALARY as '급여'
       from employee where SALARY > ( 
									 select
                                     avg(SALARY)
                                     from
                                     employee
                                     );
-- 3.노옹철 사원의 급여보다 많이 받는 직원의
-- 사번, 이름, 부서, 직급, 급여를 조회하세요

select   e.EMP_ID as '사번'
		,e.EMP_NAME as '이름'
        ,d.DEPT_TITLE as '부서'
        ,j.JOB_NAME as '직급'
        ,e.SALARY as '급여'
        from 
        employee e
        join
        department d on e.DEPT_CODE = d.DEPT_ID
        join
        job j on j.JOB_CODE = e.JOB_CODE
        where
        SALARY >  ( select
					SALARY
                    from 
                    employee
                    where
                    EMP_NAME = '노옹철'
						);
        

-- 4.가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급, 부서, 급여, 입사일을 조회하세요 (MIN)

select   e.EMP_ID as '사번'
		,e.EMP_NAME as '이름'
        ,d.DEPT_TITLE as '부서'
        ,j.JOB_NAME as '직급'
        ,e.SALARY as '급여'
        ,e.HIRE_DATE as '입사일'
        from 
        employee e
        join
        department d on e.DEPT_CODE = d.DEPT_ID
        join
        job j on j.JOB_CODE = e.JOB_CODE
        where
        SALARY = (
					select
					min(SALARY)
					from
					employee
					 );

-- 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY절에도 사용할 수 있다.


-- 5.부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
-- 힌트 : where 절에 subquery

select   e.EMP_ID as '사번'
		,e.EMP_NAME as '이름'
        ,d.DEPT_TITLE as '부서'
        ,j.JOB_NAME as '직급'
        ,e.SALARY as '급여'
        from 
        employee e
        join
        department d on e.DEPT_CODE = d.DEPT_ID
        join
        job j on j.JOB_CODE = e.JOB_CODE
        where
        SALARY = (
					select
					max(SALARY)
					from
					employee
					 );

-- 여기서부터 난이도 극상

-- 6.관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의 
-- 정보를 추출하여 조회
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분
-- 힌트 : is not null, union(혹은 then, else), distinct

SELECT 
    E.EMP_ID AS 사번,
    E.EMP_NAME AS 이름,
    D.DEPT_TITLE AS 부서명,
    J.JOB_NAME AS 직급,
    '관리자' AS 구분
FROM 
    EMPLOYEE E
JOIN 
    DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN 
    JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE 
    E.EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)

UNION

SELECT 
    E.EMP_ID AS 사번,
    E.EMP_NAME AS 이름,
    D.DEPT_TITLE AS 부서명,
    J.JOB_NAME AS 직급,
    '직원' AS 구분
FROM 
    EMPLOYEE E
JOIN 
    DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN 
    JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE 
    E.MANAGER_ID IS NULL OR E.MANAGER_ID NOT IN (SELECT DISTINCT EMP_ID FROM EMPLOYEE);


-- 7.자기 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요
-- 힌트 : round(컬럼명, -5)

USE EMPLOYEE;

SELECT 
    E.EMP_ID AS 사번,
    E.EMP_NAME AS 이름,
    E.JOB_CODE AS 직급코드,
    E.SALARY AS 급여
FROM 
    EMPLOYEE E
WHERE 
    ROUND(E.SALARY, -5) = (
        SELECT 
            ROUND(AVG(SALARY), -5) 
        FROM 
            EMPLOYEE 
        WHERE 
            JOB_CODE = E.JOB_CODE
    );

-- 8.퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회

SELECT
	EMP_NAME AS 사원이름
    ,JOB_NAME AS 직급
    ,DEPT_TITLE AS 부서
    ,HIRE_DATE AS 입사일
FROM
	employee e join department d on (e.DEPT_CODE=d.DEPT_ID)
    join job j on (e.JOB_CODE = j.JOB_CODE)
    WHERE 
    E.DEPT_CODE = (
					SELECT
                    DEPT_CODE
                    FROM
                    EMPLOYEE
                    WHERE EMP_NO = (SELECT
									EMP_NO
                                    FROM
                                    EMPLOYEE
                                    WHERE ENT_YN = 'Y' AND EMP_NO LIKE '%-%' LIMIT 1)
                                    )
    AND E.JOB_CODE = (SELECT
					  JOB_CODE
					  FROM
                      EMPLOYEE
                      WHERE
                      EMP_NO = (SELECT
								EMP_NO
                                FROM
                                EMPLOYEE
                                WHERE ENT_YN = 'Y' AND EMP_NO LIKE '%-%' LIMIT 1))
    AND E.ENT_YN = 'N';
    
-- 8.퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회
    
SELECT 
    E.EMP_NAME AS 이름,
    J.JOB_NAME AS 직급,
    D.DEPT_TITLE AS 부서,
    E.HIRE_DATE AS 입사일
FROM 
    EMPLOYEE E
JOIN 
    DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN 
    JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE 
    (E.DEPT_CODE, E.JOB_CODE) IN (
        SELECT 
            DEPT_CODE, JOB_CODE 
        FROM 
            EMPLOYEE 
        WHERE 
            ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2'  -- 주민등록번호 앞자리에서 성별 확인
    );

    


-- 9.급여 평균 3위 안에 드는 부서의 
-- 부서 코드와 부서명, 평균급여를 조회하세요
-- limit 사용

SELECT 
    D.DEPT_ID AS 부서코드,
    D.DEPT_TITLE AS 부서명,
    AVG(E.SALARY) AS 평균급여
FROM 
    EMPLOYEE E
JOIN 
    DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY 
    D.DEPT_ID, D.DEPT_TITLE
ORDER BY 
    평균급여 DESC
LIMIT 3;


-- 10.직원 정보에서 급여를 가장 많이 받는 순으로 이름, 급여, 순위 조회
-- 힌트 : DENSE_RANK() OVER or RANK() OVER

SELECT 
    EMP_NAME AS 이름,
    SALARY AS 급여,
    DENSE_RANK() OVER (ORDER BY SALARY DESC) AS 순위
FROM 
    EMPLOYEE
ORDER BY 
    SALARY DESC;



-- 11.부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은
-- 부서의 부서명과, 부서별 급여 합계 조회
-- 힌트 : SUM(E2.SALARY) * 0.2

SELECT 
    D.DEPT_TITLE AS 부서명,
    SUM(E.SALARY) AS 부서별급여합계
FROM 
    EMPLOYEE E
JOIN 
    DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY 
    D.DEPT_TITLE
HAVING 
    SUM(E.SALARY) > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);
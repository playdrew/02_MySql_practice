use employee;

-- 1. 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하세요
-- (조회시에는 모든 컬럼에 테이블 별칭을 사용하는 것이 좋다.)
-- (사용 테이블 : job, department, location, employee)

select 
	  e.EMP_ID
     ,e.EMP_NAME
     ,e.SALARY
     ,j.JOB_NAME
     ,d.DEPT_TITLE
     ,l.LOCAL_NAME
from
	employee  as  e
    join
    department as d on d.DEPT_ID = e.DEPT_CODE
    join
    job as j on e.JOB_CODE = j.JOB_CODE
    join
    location  as l on d.LOCATION_ID = l.LOCAL_CODE
where
	JOB_NAME = '대리' and LOCAL_NAME = 'ASIA1';
    
-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
--    (사용 테이블 : employee, department, job)

select
     e.EMP_NAME
	,e.EMP_NO
    ,d.DEPT_TITLE
    ,j.JOB_NAME
from
	employee e 
    join
    department d on d.DEPT_ID = e.DEPT_CODE
    join
    job j on e.JOB_CODE = j.JOB_CODE
where
	e.EMP_NO like '7______2%' and e.EMP_NAME like '전%';

-- 3. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 직급명을 조회하시오.
-- (사용 테이블 : employee, job)

select
	 e.EMP_ID
    ,e.EMP_NAME
    ,j.JOB_NAME
from
	employee e
    join
    job j on e.JOB_CODE = j.JOB_CODE
where
	e.EMP_NAME like '%형%';

-- 4. 해외영업팀에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하시오.
-- (사용 테이블 : employee, department, job)

select 
	e.EMP_NAME
    ,j.JOB_NAME
    ,e.DEPT_CODE
    ,d.DEPT_TITLE
from
	employee e
    join
    department as d on d.DEPT_ID = e.DEPT_CODE
    join
    job as j on e.JOB_CODE = j.JOB_CODE
where
	d.DEPT_TITLE like '해외영업%';
    
-- 5. 보너스포인트를 받는 직원들의 사원명, 
--    보너스포인트, 부서명, 근무지역명을 조회하시오.
-- (사용 테이블 : employee, department, location)

select
	e.EMP_NAME
    ,e.bonus
    ,d.DEPT_TITLE
    ,l.LOCAL_NAME
from
	employee  as  e
    join
    department as d on d.DEPT_ID = e.DEPT_CODE
    join
    location  as l on d.LOCATION_ID = l.LOCAL_CODE
where
	e.bonus is not null;
    
-- 6. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
-- (사용 테이블 : employee, job, department, location)

select
	e.EMP_NAME
     ,j.JOB_NAME
     ,d.DEPT_TITLE
     ,l.LOCAL_NAME
from
	employee as e
    join
    department as d on d.DEPT_ID = e.DEPT_CODE
    join
    job as j on e.JOB_CODE = j.JOB_CODE
    join
    location as l on d.LOCATION_ID = l.LOCAL_CODE
where
	e.DEPT_CODE like 'D2';
    
-- 7. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하시오.
--    연봉에 보너스포인트를 적용하시오.
-- (사용 테이블 : employee, job, sal_grade)

select
	b.EMP_NAME,	  -- 사원명    /  employee  b
	c.JOB_NAME,	  -- 직급명    / 	job  c
	b.SALARY,		  -- 급여 	 /  employee  b
	ifnull((SALARY * 12) + (SALARY * BONUS), SALARY * 12) as '보너스포함 연봉'	  -- 최소급여   / sal_grade  a

from
	employee b
    
join sal_grade a on a.SAL_LEVEL = b.SAL_LEVEL
join job c on b.JOB_CODE = c.JOB_CODE

where
	b.SALARY > a.MIN_SAL;
	



-- 8. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하시오.

select
	e.EMP_NAME
    ,d.DEPT_TITLE
    ,l.LOCAL_NAME
    ,NATIONAL_NAME
from
	employee  as  e
    join
    department as d on d.DEPT_ID = e.DEPT_CODE
    join
    location  as l on d.LOCATION_ID = l.LOCAL_CODE
    join
    nation as n on l.NATIONAL_CODE = n.NATIONAL_CODE
where
	n.NATIONAL_NAME like '한국'or n.NATIONAL_NAME ='일본';
    
    


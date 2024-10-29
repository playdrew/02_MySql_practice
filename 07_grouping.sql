use menudb;

-- group by 절
-- 결과 집합을 특정 열(가로/컬럼)의 값에 따라 그룹화 하는 것에 사용한다.
-- having 절은 group by 절과 함께 사용이 되며 
-- 그룹에 대한 조건을 정의할 때 사용이 된다.

-- where 조건절 / having 조건절의 차이

-- where 조건절의 경우 
-- 그룹화를 하기 전 개별 행에 대한 조건을 적용하는 것

-- having 조건절의 경우
-- 생성된 그룹에 대한 조건을 적용하는 것

-- 메뉴가 존재하는 카테고리 그룹 조회
select 
	category_code
from
	tbl_menu;
    
-- 4 5 8 등등 동일한 코드를 가진 것들을 하나로 묶고 싶어요 

select 
	category_code
from
	tbl_menu
group by
	category_code;
    
-- 4 5 6 8 9 10 11 12 까지 중복을 제거한것 처럼 보인다 마치 distinct 처럼
-- 하지만 이것은 4 5 6 ... 그룹을 만든 것입니다.
-- 위에서 만들어둔 카테고리 코드를 기준으로 그룹에 포함된 행의 수 조회
-- count() : 갯수 세주는 내장함수

select 
	category_code as '카테고리 코드',
    count(*) as '그룹에 포함된 행의 수' -- *이라는 것은 여기서 해당하는 행의 자체라는 것을 의미한다
from
	tbl_menu
group by
	category_code;
    
-- sum() : 합계
-- 메뉴테이블에서 카테고리 코드를 기준으로 그룹화 한 후, 그룹의 메뉴가격 합계 조회

select 
	*
from 
	tbl_menu;

select
	category_code,
    sum(menu_price) -- 행자체를 고려하는게 아니라 메뉴가격의 합계
from 
	tbl_menu
group by
	category_code;
    
-- avg() 활용
-- 카테고리 메뉴 가격의 평균 조회

select
	category_code,
    avg(menu_price)
from
	tbl_menu
group by
	category_code;
    
-- 2개 이상의 그룹 생성하기
-- 가격과 카테고리코드가 동일한 것들이 하나의 그룹이 된다.

select
	menu_price,
    category_code
from
	tbl_menu
group by
	menu_price,
	category_code;
    
-- having 절을 사용해서 5번 카테고리 부터 8번 카테고리까지의
-- 메뉴카테고리 번호 조회

select
	category_code
from
	tbl_menu
group by
	category_code
having
	category_code between 5 and 8;
    
-- having 절을 사용해서 5번 카테고리 부터 8번 카테고리가 아닌
-- 메뉴카테고리 번호 조회
    
select
	category_code
from
	tbl_menu
group by
	category_code
having
	category_code not between 5 and 8;
    
-- with rollup
-- 가장 아랫쪽에 총합이 생겼어요 그룹별로 총합을 구해주었습니다. 
-- 위의 있는 식을 말아가지고 라는 식으로 말이에요

select
	category_code,
    sum(menu_price)
from
	tbl_menu
group by
	category_code
with rollup;

-- 컬럼 2 개를 활용한 rollup(같은 메뉴 가격별 총합 및 해당 메뉴 가격 별 같은 카테고리 총합) 
-- category_code null 인것은 menu_price의 합
-- rollup 을 통해 먼저 나온 컬럼의 총합을 구하고 이후 나오는 컬럼의 총합도 구하는 방식이다.
-- rollup 은 그룹별 총합계를 만들어서 집어넣어준다라고 생각하면 편할 거에요 

select
	menu_price,
	category_code,
	sum(menu_price)
from
	tbl_menu
group by
	menu_price,
	category_code
with rollup;


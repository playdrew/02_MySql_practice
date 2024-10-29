use menudb;

select
	*
from
	tbl_menu;

-- select 라고 시작해서 ;로 끝내는 것을 쿼리문이라고 해요
-- 이것은 메인쿼리문이라고 합니다.

-- 메뉴테이블에서 민트미역국과 같은 카테고리 코드를 가지고 있는 메뉴 조회
-- 민트미역국의 카테고리 코드를 검색
-- 1. 

select
	category_code
from
	tbl_menu
where
	menu_name='민트미역국';
    
select 
	*
from
	tbl_menu
where 
	category_code = 4;
    
-- 여러분이 반칙을 쓰지 않는 이상 1개의 쿼리문으로 절대 할 수 없다.
-- 민트미역국의 카테고리코드를 알 수 없기 때문에

-- subquery 란? 
-- main 쿼리에서 수행되는(다른 쿼리문에서 실행되는) 쿼리문이다.
-- 위의 두가지 쿼리를 하나로 합쳐봅니다.

select
	*
from
	tbl_menu
where
	category_code = (
					select
						category_code
					from
						tbl_menu
					where
						menu_name = '민트미역국'
					);

-- 가장 많은 메뉴가 포함 된 카테고리 조회
-- 서브쿼리를 from 절에도 작성할 수 있습니다
-- 1. 서브쿼리 작성

select
	category_code,
	count(*) as 'count'
from 
	tbl_menu
group by
	category_code;

-- 위의 결과값 중 하나인 6의 값을 위의 쿼리실행결과를 도출시키고 싶다.
-- 위의 결과값을 또 하나의 테이블로서 사용하는 것입니다.
-- max() 함수 : 최대값 , min() 함수 : 최소값
-- 우리가 from 절에 사용하는 서브쿼리는 (derived table, 파생테이블)이라고 불리우며
-- 파생 테이블은 반드시 별칭을 가지고 있어야 한다.
-- 쿼리문의 결과값을 마치 테이블처럼 사용할 수 있으며 임시적으로 생겼다가 실행되면 사라지는 서브쿼리문이다.

select
	max(count)
from
	(
    select
	count(*) as 'count'
	from 
	tbl_menu
	group by
	category_code
    )  as countmenu;
    
-- 조회를 할때는 from (테이블)절이 뭔저 동작을 합니다. 

select
	*
from
	tbl_menu;

select 
	category_code,
	count(*) as count
from
	tbl_menu
group by
	category_code;

-- 위의 코드들은 count(*)의 이해를 돕기 위한 쿼리 입니다.

-- 상관 서브쿼리
-- 메인 쿼리문이 서브쿼리의 결과에 영향을 주는 경우를 상관 서브쿼리라고 한다.
-- 카테고리 별 평균 가격보다 높은 가격의 메뉴 조회하기
-- 우리가 카테고리별 평균가격을 몰라서 조건절을 지정

select
	avg(menu_price)
from
	tbl_menu
where 
	category_code;


select
	a.menu_code,
    a.menu_name,
    a.menu_price,
    a.category_code,
    a.orderable_status
from
	tbl_menu a
where
	menu_price > (
					select
						avg(menu_price)
					from
						tbl_menu
					where
						category_code = a.category_code 
				 );
                 
-- CTE (Common Table Expression)
-- 파생 테이블과 비슷한 개념이며, 코드의 가독성과 재사용성을 위해 파생 테이블 대신 사용하게 된다.
-- from 절에서만 사용이된다 (join 일 시 join 구문에도 사용 가능)
-- 파생테이블이란 조회한 결과로 가상의 테이블을 만드는 것이에요

select
	menu_name
from
	tbl_menu;

select
	category_name
from
	tbl_category;

with menucte as (
				 select
					menu_name,
                    category_name
				 from
					tbl_menu a
                    join
                    tbl_category b
                    -- 두가지의 테이블을 엮을 것인데 어떠한 컬럼으로 연관을 맺을지 on
                    on a.category_code = b.category_code
				)

select
	*
from
	menucte
order by
	menu_name;
    
-- 우리가 만든 가상의 테이블(파생테이블)을 사용하는 것
-- 조회된 결과를 마치 테이블인 것처럼 사용할 수 있다.

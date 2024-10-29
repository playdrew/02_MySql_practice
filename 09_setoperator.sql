-- set 연산자는 두 개 이상의 select 문 결과 질합을
-- 결합하는데 사용을 하게 된다
-- 주의해야 할 점은 결합하는 결과 집합의 컬럼이 '일치'해야 한다.

-- union
-- 두 개 이상의 select 문의 결과를 결합하여 중복된 레코드는 제거한 후 
-- 반환을 해준다.

use menudb;

select
	*
from
	tbl_menu
where
	category_code = 10;

select
	*
from
	tbl_menu
where
	menu_price < 9000;
    
-- @@@@@@@@@@@@@@구분선@@@@@@@@@@@@@@
-- 1 번째 쿼리

select
	*
from
	tbl_menu
where
	category_code = 10

union 
-- 2번째 쿼리

select
	*
from
	tbl_menu
where
	menu_price < 9000;

-- 중복된 값은 날려보린다. 그림으로 그렸을때 전체를 출력하데 교집합부분은 1개만 처리해준셈

-- union all
-- 두 개 이상의 select 문의 결과를 결합하며
-- 중복된 레코드는 제거하지 않고 반환하는 sql 연산자이다.

-- 1 번째 쿼리

select
	*
from
	tbl_menu
where
	category_code = 10

union all
-- 2번째 쿼리

select
	*
from
	tbl_menu
where
	menu_price < 9000; 
    
-- 교집합만 출력하고 싶으면 join innerjoin 이였죠
-- intersect
-- 두 쿼리문의 결과 중 공통되는 레코드만 반환하는 연산자이다
-- 하지만 MySQL 에서는 제공하지 않는다
-- 그러면 어떻게 하냐
-- inner join 또는 in 연산자를 통해서 intersect 를 대체 할 수 있다.

select 
	*
from 
	tbl_menu a
    inner join
    (
		select
			*
		from
			tbl_menu -- 이 친구 자체가 테이블이 때문에 소괄호 밖에다가 별칭을 지어주어야 합니다.
		where
			menu_price < 9000
    ) b
    -- 조인을 수행하기 위해선 공통된 컬럼이 무엇인지 알려야 하기에
    on (a.menu_code = b.menu_code)
where
	a.category_code=10;
    
-- (,)는 컬럼명앞에 쓰는게 좋습니다
-- 한 줄을 지웠을때 오류발생하지 않기 때문에요 

-- in 연산자를 사용한 intersect
-- 쿼리의 결과집합(in내부) 조건에 필요한 값을 가상의 테이블로 사용할 수 있다.
select
	*
from
	tbl_menu 
where
	category_code = 10
    and
    menu_code in (
					select
						menu_code
					from
						tbl_menu
                    where
						menu_price < 9000
				 );

-- 차집합을 하고 싶어요
-- left/right join 하고 null 값을 빼버리면 끝나요

-- MINUS
-- 첫 번째 select 문의 결과에서 두 번째 select 문의 결과가 포함 된 
-- 레코드를 제외한 레코드를 반환하는 연산자
-- 하지만, MySQL에서는 MINUS 를 지원하지 않는다.
-- 그래도 우리는 left join 을 이용해서 구현할 수 있다.

select
	*
from
 tbl_menu
 where
	category_code=10;


select
	*
from
	tbl_menu a
    left join 	(
				select
					*
				from 
					tbl_menu
				where
					menu_price < 9000
				) b
                -- join 이라서 서로가 공유하고 있는 컬럼 작성
                on a.menu_code = b.menu_code
-- main 쿼리에 대한 조건문
where
	a.category_code = 10;
    
select
	*
from
	tbl_menu a
    left join 	(
				select
					*
				from 
					tbl_menu
				where
					menu_price < 9000
				) b
                on a.menu_code = b.menu_code
where
	a.category_code = 10
    and
    b.menu_code is null;
    
-- 그림적으로 한 원은 category_code = 10 다른 원은 menu_price < 9000
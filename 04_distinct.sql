-- use : 스키마에 볼드체적용되면서 사용할 수 있게 된다.
use menudb;
-- distinct 
-- 중복 된 값을 제거하는 것에 사용된다.
-- 컬럼에 있는 컬럼 값들의 종류 쉽게 파악 가능

-- 단일 열(컬럼) 중복 제거 
-- 메뉴가 19가지 정도 되는데 -개를 한개 아니라 삭제한 것이 아니라 뭉쳐 준 뒤에 통계낼때 사용
select
	distinct category_code
from 
	tbl_menu
order by
	category_code;


-- 다중 열(컬럼) 
-- 다중열의 값들이 모두 동일하면 중복된 것으로 판단한다
select
	category_code,
    orderable_status
from
	tbl_menu;
    
-- 예를 들어 4N 4N인 경우면 뭉쳐주고 둘 중 하나라도 다르면 다르게 한다.
-- 다중 열의 값이 모두 동일해야 중복된 것으로 판단한다.

select distinct
	category_code,
    orderable_status
from
	tbl_menu;
    

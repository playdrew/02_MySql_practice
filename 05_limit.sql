-- use : 스키마에 볼드체적용되면서 사용할 수 있게 된다.
use menudb;
-- limit 
-- 영문 번역 그대로 제한(한계) 하는 것에 사용이 된다.
-- 예를 들어 select 조회 결과에 반환할 행 갯수 제한

select
	*
from
	tbl_menu;
    
-- 모든 데이터가 아닌 상위 N개 정도만 보고 싶어요
-- N개의 행만 출력해준다 
    
select
	*
from
	tbl_menu
order by
	menu_price desc
limit
	-- 반환 받을 행의 수 입력
    -- 전달인자 1개만 했는데 전달인자 2개도 가능
	5; 
    
-- where -> order by -> limit

-- 위에 작성한 식은 반환 받을 행의 수

-- [] <- 내부에 작성하는 것은 생략이 가능하다
-- limit[offset] row_count 
-- offset : 시작 할 행의 번호(인덱스 체계)
-- row_count : 이후 행 부터 반환 받을 행의 개수

select
	menu_code,
    menu_name,
    menu_price
from
	tbl_menu
order by 
	menu_price desc  
-- 2번째 행부터 5번째 행까지만 결과를 보고싶다.
-- 아래 부분을 지워서 확인해봐요
limit
	1,4;

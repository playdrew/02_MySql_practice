-- DML (Data Manipulation Language)
-- Manipulation : 조작
-- 테이블의 값을 삽입, 수정, 삭제하는 SQL 의 한 부분을 의미한다.
-- 삽입 수정 수정의 경우에는 행의 늘린다던가 값을 변경하던가

-- 삽입(INSERT)
-- 새로운 행을 추가하는 구문이다.
-- 테이블의 행(세로)의 수가 증가한다.
-- into 삽입을 어디(어느 테이블)에다 할지 지정

-- tbl_menu 테이블의 값을 insert
-- values() 값을 집어넣는 것
-- 1 row(s) affected

insert into tbl_menu values (null,'바나나해장국',8500,4,'Y');

-- not null 제약조건이 붙은 컬럼은 반드시 값을 넣어주어야 한다
-- Column 'menu_price' 라는 값은 cannot be null 입니다.
-- insert into tbl_menu values (null,'바나나해장국',null,4,'Y'); 


-- tbl_menu 가 어떤 식으로 되어있는지 설명
-- key PRI(PK Primary key) 한 행을 식별하기 위한 열쇠
-- Extra : auto_increment 자동증가 > 우리가 값을 집어넣지 않더라도 마지막행에서 번호를 집어넣어준다는 것입니다.
describe tbl_menu;

-- null 을 집어넣는데 알아서 22번으로 처리되었습니다. 
-- 자동으로 번호를 매겨주고 있습니다.
-- menu 코드에 제약조건이 걸려있는 것입니다.
-- dml 동작 확인용 select 구문
select * from tbl_menu; 

-- 컬럼을 명시하게 된다면, insert 시 데이터 입력 순서를 바꿔도 상관없다
-- 아까는 반드시 순서를 일치시켜주었어야했는데
-- 이렇게 만들면 순서를 바꿀 수 있어여
insert into tbl_menu 
(orderable_status, menu_name, menu_code, menu_price, category_code)
values
('Y', '파인애플탕', null, 5500, 4);

-- menu_code
-- insert 시 auto_increment 가 있는 컬럼이나, null 값을 허용하는 컬럼은
-- 데이터를 집어넣지 않아도 된다.
insert into tbl_menu 
(orderable_status, menu_name, menu_price, category_code)
values
('Y', '초콜렛밥', 1000, 4);

insert into
	   tbl_menu
	   values
	   (null,'참치맛아이스크림',1600,12,	'Y'),
       (null,'해장국맛아이스크림',1900,12,'Y'),
       (null,'멸치맛아이스크림',1200,12,'Y');
       
-- UPDATE
-- 테이블에 기록된 컬럼들의 값을 수정하는 구문이다
-- 테이블의 행 갯수 에는 영향이 없다 

select
	menu_code,
    category_code
from
	tbl_menu
where 
	menu_name = '파인애플탕';

-- 파인애플탕을 update 해요
update tbl_menu
set
	category_code = 7
where
	menu_code = 23;
    
-- delete나 update는 조건을 설정하는 것이에요 조건안정하면 다 바꿔버림

-- subquery를 사용해서 update
-- 주의점. update 나 delete 시에 자기 자신의 테이블의 데이터를 
-- 사용하게 되면 1093 error 발생

-- 문제.
-- 메뉴의 이름이 파인애플탕인 메뉴의 카테고리코드를 6으로 수정
-- where menu_name = '파인애플탕' x
-- where menu_code 를 통해 파인애플탕 추론하기
-- 확인없이 파인애플탕의 menu_code를 알수가 없어요
update tbl_menu
set
	category_code = 6
where 
	menu_code = (
				 select
					menu_code
				 from
					tbl_menu
				 where
					menu_name = '파인애플탕'
				);
                
-- 1093 error 문제해결 : subquery의 from 절에서 tbl_menu 를 사용한게 문제 -> cte 를 사용해 해결

update tbl_menu
set
	category_code = 6
where 
	menu_code = (
				 select
					cte.menu_code
				 from
					(
					 select
						menu_code
					 from
						tbl_menu
					 where
						menu_name = '파인애플탕'
                    ) cte
				);

-- delete
-- 테이블의 행을 삭제하는 구문이다.
-- 테이블의 행의 갯수가 줄어든다.

-- limit
delete from tbl_menu
order by menu_price -- 아무것도 안적혀있으면 asc 가 디폴트값
limit 2;

select * from tbl_menu;

-- where 사용으로 단일 행 삭제
delete 
from
	tbl_menu
where
	menu_code = 26;
    
delete from tbl_menu; -- 해당하는 테이블 자체가 날라간게 아닌 테이블안의 데이터가 날라간 것 입니다. 복구못합니다. 

-- 슬레이브db 와 마스터db가 있는데 슬레이브 복제본을 떠서 유지하는 경우가 많다고 합니다.
-- 조회라는 것 join 이 조금 위험해요 테이블을 얽고 얽는데 시간이 오래 걸려요 나중에는 테이블이 얽히고 섫혀있어서 시간이 오래걸려요 테이블에 대한 정보를 읽기때문입니다.
-- 나중엔 조회용 db 하나와 dml 수정/삭제/삽입 을 위한 db 를 하는 경우도 있습니다.
-- 쿼리문을 마치 객체처럼 호출해요. 메뉴코드만 전달인자로 쿼리객체를 변수로 전달을 하면은 삭제하는 식으로 동작합니다?
-- 단일 행을 삭제할때 반드시 한 행을 삭제할 수 있는 유일한 값으로 삭제를 해야합니다.그것을 pk라고 합니다.
-- 게시글 삭제했는데 게시글 5개가 삭제되는 경우 삭제를 할때 내가 가진 이름으로 삭제해야한다라고 할 경우 문제생김?

-- replace
-- insert 시 primary key 또는 unique key 가 충돌이 발생핝다면
-- replace 를 통해 중복 된 데이터를 덮어 쓸 수 있다.

insert into tbl_menu values (15,'소주',6000,10,'Y');
-- insert into tbl_menu values (15,'소주',6000,10,'Y'); pk 값이 중복되면서 오류가 발생하는데요
replace into tbl_menu values (15,'소주',8000,10,'Y'); -- replace는 중복되면 덮어씁니다 pk의 하위 unique key 제약조건을 id같은 것에 많이 걸어둡니다 replace 를 하면 조금 더 안전하게 실행을 시킬 수 있다. 삭제라기보단 업데이트 2rows affected 기존의 것 새로운 것2번
select * from tbl_menu;


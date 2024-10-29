
-- 14, 15 -> 개선방안
-- view
-- select 쿼리문을 저장한 개겣로 가상 테이블 이라고 불리운다.
-- 실질적인 데이터를 물리적으로 저장하고 있지 않고, 쿼리만 저장을 했지만
-- 테이블을 쓰는 것과 동일하게 사용을 할 수 있다.


-- cte -> 파생테이블 (해당하는 쿼리의 결과 / 가상의 조회한 결과) -> 한계 : 일회성  
-- 구지 적용하지 않아도 되지만 반복학습을 하면서 적응이 되었다 그러면 적응하면 좋은 것
-- 실질적으로 저장하는 개념이 아니라 만들면 언제든지 가져다 쓸 수 있게끔 테이블을 쓰는 것과 동일하게 사용할 수 있는 view

select * from tbl_menu;

-- view 생성 표현식
-- create view 사용할이름 as 쿼리문;

create view hansik as
select
	*
from 
	tbl_menu
where
	category_code=4;

-- 만들어진 view 조회
select * from hansik;

-- from에서  어디서 동작할지 찾아요 조건을 검색했을때 21행이 있다고 하면 한 21가지 행을 다 조회를 한다음에 4번에 해당하는 것만 추리는것
-- hansik 한식 카테고리를 가상의 테이블로 만들어 두었는데 한식카타고리를 사이트에 누르면 한식이 나오겠죠 그때 다른 것들은 고려할 필요가 없죠
-- 메뉴한개를 삭제할건데 delete from tbl_menu where menu_code=5 라고 해요 한식만의 카테고리내에서 메뉴테이블에 검색을 하니까 21번 동작을 해서 메뉴코드 5인에를 삭제해줘요
-- delete hansik 을 하면 일을 4번해요 . view인데도 원본데이터에 영향이 가요 . 검색의 범위를 줄였다. 데이터베이스가 한 일을 줄였다라고 생각

-- 한식이라고 하는 view는 원본인 tbl_menu 에서 만든 가상의 테이블
insert into tbl_menu values (null,'해장국',5500,4,'Y');

-- 베이스 테이블의 정보가 변경이 되면, view 도 같이 반영이 된다.
select * from hansik;

-- view 에서의 dml 수행
-- 주의점!! 베이스테이블에서는 auto-increment가 설정이 되어있으나
-- view에서는 설정하지 않았기 때문에 제약조건 위반여부 고려
insert into hansik values (99,'뼈다구해장국',8000,4,'Y');

-- view 실행여부 확인 
select * from hansik;
-- view 에서 실행한 dml 구문이 원본에도 영향을 미쳤는 지 확인
select * from tbl_menu;

-- 원본에도 영향을 미치는 것은 얕은 복사 ,자바
-- 주소를 복사해서 공유하는 것 같은 곳을 바라고게 끔

update hansik 
set menu_name = '우거지해장국', 
	menu_price = 9000
where
	menu_code=99;
    
select * from tbl_menu;

describe hansik;

-- primary 키나 not null 설정이 안되있는 것을 확인할수있습니다.

-- view 사용 시 dml 주의점
-- 1. 뷰 정의할 때 포함되지 않는 컬럼을 사용하려는 경우
-- 2. 뷰에 포함되지 앟는 컬럼 중 콜롬 즁 베이스가 되는 데이터 컬럼이 not null 제약조건이 지정된 경우
-- 3. 산술 표현식이 정의 된 경우
-- 4. join 을 이용해 여러 테이블을 연결한 경우
-- 5. 그룹함수나 group by 절을 포함한 경우 
-- 6. distinct 를 포함한 경우 

-- 생성한 view 삭제
drop view hansik;

select * from hansik;

-- or replace 옵션
-- 테이블을 drop 하지 않고 기존의 view 를 새로운 view 로 대체
-- 만들거나 있으면 replace(덮어쓰겠다)라는 것입니다.

create or replace view hansik as
select
	menu_name as 메뉴명,
    category_name as 카테고리명
from
	tbl_menu a
    join
    tbl_category b on a.category_code = b.category_code
where
	b.category_name = '한식';
    
select * from hansik;
-- use : 스키마에 볼드체적용되면서 사용할 수 있게 된다.
use menudb;
-- 테이블을 분리하면 한 행을 특정할 수 있는 번호들이 있는데
-- 그 번호들이 식별자가 되어 다른테이블이지만 두 가지 값을 엮을 수 있다.
-- 메뉴테이블에서 카테고리테이블에 있는 것도 같이 하고 싶은셈 
-- 메뉴테이블과 카테고리테이블 둘 다 가지고 있는 (DB수업용 SCRIPT_MENU 논리모델) 카테고리코드키를 건네줍니다.
-- FK(Foregin Key) 카테고리코드는 해당 키를 넘겨받았다라는 것입니다. 
-- 서로 다른 테이블이지만 카테고리코드라는 것으로 연결이 되어있다.
-- 메뉴와 카테고리는 카테고리컬럼으로 연관 메뉴와 주문메뉴는 메뉴코드로 연관
-- 반드시 공유하고 있는 컬럼이 있어야만 한다.

-- *join*
-- 두 개 이상의 테이블을 관련 있는 컬럼을 통해 결합(관계를 맺는)하는데 사용된다.
-- 두 개 이상의 테이블은 결합을 하기 위해서는 반드시!!! 연관 있는 컬럼이 존재해야 하며
-- 연관 있는 컬럼을 통해서 join 이 된 테이블 들의 컬럼을 모두 사용할 수 있다.

-- join 시작 전 별칭 정리
-- as(alias) 별칭 
-- sql 문(쿼리문)의 컬럼 또는 테이블에 별칭을 달 수 있다.
-- 만약 별칭에 특수기호나, 띄어쓰기가 없다면 as와 ''는 생략이 가능하다.

-- 아래는 별칭의 예시입니다.
-- 특수기호나 띄어쓰기를 하고 싶으면 as '' 로 감싸서 나는 칭호다라고 분명히 해주어야 합니다.

select
	menu_code as '코 드!!!',
    menu_name '이름',
    menu_price 가격
from
	tbl_menu menu;

-- 아래와 위는 같다.

select
	menu.menu_code as '코 드!!!',
    menu.menu_name '이름',
    menu.menu_price 가격
from
	tbl_menu menu;
    
-- join의 종류

-- inner join 
-- 두 테이블의 교집합을 반환하는 join의 유형
-- inner join 에서 inner 는 생략가능하다.

-- 메뉴의 이름과 카테고리의 이름을 조회
-- tbl_menu 에는 카테고리이름이 없고 tbl_category에 카테고리이름이 있다. 
-- tbl_menu 와 tbl_category를 엮어야 하는데 categorycode라는 공통된 컬럼을 가지고 있어서 이것을 이용

-- on 키워드를 사용한 join의 방법
-- 컬럼명이 같거나 , 다를 경우 on 으로 서로 연관 있는 컬럼에 대한 조건 작성

select
	a.menu_name,
	b.category_name
from
	tbl_menu a
    join -- tbl_menu 와 tbl_category 컬럼을 가지고 연결을 할건데 어떤 컬럼을 가지고 할거냐 on 이라는 기호를 사용해서 처리 
    tbl_category b on a.category_code = b.category_code;
    
-- using 을 사용한 join
-- 서로 다른 두 테이블에서 공유하고 있는 컬럼명이 동일한 경우
-- using 을 사용해서 연관있는 컬럼을 join 할 수 있다.
-- 아래와 위는 동일하다. 
-- on 과 using 을 사용해서 join을 한다.
-- using 은 컬럼명이 동일해야 쓸 수 있음 on 은 컬럼명이 달라도 사용가능 그래서 on이 더 잘 쓰임

select
	a.menu_name,
	b.category_name
from
	tbl_menu a
    join 
    tbl_category b 
    using
    (category_code);
    
-- join 이라는 것은 교집합입니다.
-- left join
-- 첫 번째 테이블의 모든 레코드와 두 번째 테이블에서 일치하는
-- 레코드를 반환하는 join 유형
-- 갑과 을관계를 생기는 셈 : 첫번째 테이블은 '모든' 두번째 테이블은 '일치'

select 
	a.category_name,
    b.menu_name
from
    tbl_category a left join tbl_menu b -- 왼쪽것을 기준으로 모두 출력하고 오른쪽값은 왼쪽 것에 맞춰서 존재하는 값을 넣어줌 그래서 null 이 있음
	on a.category_code = b.category_code;
    
-- inner join과 null 값은 교집합에 포함이 안되었다고 해서 존재하지 않는 것입니다.
-- right join 
-- 두 번째(오른쪽) 테이블의 모든 레코드와 첫 번째(왼쪽) 테이블에서 
-- 일치하는 레코드를 반환하는 sql join 유형

select
	a.menu_name,
    b.category_name
from
	tbl_menu a right join tbl_category b -- 오른쪽에 있는 category 값에 기준으로 menu 값이 일치되어서 나온다
    using 
    (category_code);

-- cross join
-- inner join 이 교집합 이였다고 하면
-- cross join 은 가능한 모든 조합을 반환하는 합집합의 개념이다.
-- 가능한 모든 조합을 다 사용했다.

select
	a.menu_name,
    b.category_name
from
	tbl_menu a cross join tbl_category b;
    

-- self join
-- 같은 테이블 내에서 행과 행 사이의 관계를 찾기 위해 사용되는 join 유형 
-- 논리모델(DB 수업용 SCRIPT_MENU)를 보면 논리모델에 자기자신방향표가 있는데요
-- self join 이라는 키워드는 없고 join 이라 해요
-- using 이라는 컬럼을 사용할 수 없어요 이름이 다르기 때문에요 

select
	a.category_name,
    b.category_name
from
	tbl_category a join tbl_category b
    on
    a.ref_category_code = b.category_code;

-- 서로 다른 테이블 간의 데이터를 조회하고 싶을 때는 join을 사용한다.
-- join을 수행하는 단계를 고려 할 때는
-- 1. 테이블과 테이블이 연관이 되어 있는지 확인
-- 2. 연관이 되어 있다고 하면, 어떤 컬럼으로 연결이 되어 있는 지 확인
-- 3. 어떤 테이블을 기준으로 join 을 수행할 것인지 ( inner , left , right , cross , self ) 

  
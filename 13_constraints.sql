-- constraints (제약 조건)
-- 테이블에 데이터가 입력 되거나 변경될 때 규칙을 정의한다.
-- 데이터의 무결성!! ( 이상한 데이터가 아니게끔 들어오지 못하게끔 우리 서버에 ) 

use menudb;

-- not null
-- null 값 즉 비어있는 값을 허용하지 않는다. 라는 제약 조건

drop table if exists user_notnull; -- 안전성을 위해서 미리 읽힐 것을 대비하기 위해서
create table if not exists user_notnull(

	user_no int not null,
    user_id varchar(30) not null,
    user_pwd varchar(40) not null,
    user_name varchar(30) not null,
    gender varchar(3),
    phone varchar(30) not null,
    email varchar(50)
    
) engine = innodb;

describe user_notnull;

insert into user_notnull values 
( 1, 'user01',null,'조평훈','남','010-5518-2290','raccon@gmail.com'),
( 2, 'user02','pass02','조평순','여','010-5518-2299','racong@gmail.com');

select * from user_notnull;

-- 값을 넣은 것 같은데 안된다 제약조건을 위배한 경우가 많다

insert into user_notnull values 
( 1, 'user01',null,'조평훈','남','010-5518-2290','raccon@gmail.com'),
( 2, 'user02','pass02','조평순','여','010-5518-2299','racong@gmail.com');

select * from user_notnull;

-- unique 제약 조건
-- 중복된 값을 허용하지 않는 제약조건

drop table if exists user_unique;
create table if not exists user_unique(

	user_no int not null unique, 		-- null 허용 안하면서 유일한 값
    user_id varchar(30) not null ,		
    user_pwd varchar(40) not null,
    user_name varchar(30) not null,
    gender varchar(3),
    phone varchar(30) not null,
    email varchar(50),
    unique(phone) -- 이런 식으로도 설정할 수 있다. unique(phone,email)은 안된다.
    
) engine = innodb;

describe user_unique;

-- not null + unique => primary key가 되었네?
-- email phone user_no <- unique

insert into user_unique values 
( 1, 'user01','pass01','조평훈','남','010-5518-2290','raccon@gmail.com'),
( 2, 'user02','pass02','조평순','여','010-5518-2290','raccon@gmail.com');
-- unique 제약 조건 에러 발생(전화번호 중복됨) unique 

-- ( 2, 'user01','pass01','조평훈','남','010-5518-2290','raccon@gmail.com'),
-- ( 2, 'user02','pass02','조평순','여','010-5518-2299','racong@gmail.com'); 중복되게 하면 에러 2는 key래요

-- primary key **
-- 테이블에서 한 행의 정보를 찾기 위해 사용할 컬럼을 의미한다.
-- 테이블에 대한 식별자 역할  -> 한 행을 식별할 수 있는 값을 의미한다.
-- unique + not null -> primary key 
-- 한 테이블당 한개만 설정을 할 수 있음
-- 한 개의 컬럼에 설정 할 수 있고, 여러 개의 컬럼을 묶어서 설정할 수도 있다.
-- 복합키


-- 한 행만 가지고 있어야 합니다. 유일한 값이 어야합니다.
-- category_code price orderable_status menu_name 등등 중복될 수 있으면 피하는게 좋고 menu_code 같은 유일한 값을 하는게 좋습니다.
-- user_no phone 을 unique 이면서 not null 이에요 1번회원이 010-5 1번회원이 010-6번호를 가지고 있어요 이러면 된다는데 왠지 모른다.. 
-- 프라이머리 키가 한 행을 식별하는데 프라이머리 1,1 1,2 2,1 2,2 복합키는 유일한 값을 2개로 묶어서 관리한다. 유일한 값이 하나라고 치면은 유일한 값을 셋트로 관리한다.

drop table if exists user_pk;
create table if not exists user_pk(
	
    -- user_no int primary key
	user_no int, 	   	  	
    user_id varchar(30) not null ,		
    user_pwd varchar(40) not null,
    user_name varchar(30) not null,
    gender varchar(3),
    phone varchar(30) not null,
    email varchar(50),
    primary key(user_no) 
    
) engine = innodb;

describe user_pk;

-- join 할때 연관된 컬럼을 찾으라고 했죠. 
-- foreign key (외래키)
-- 참조(연관) 된 다른 테이블에서 제공하는 값만 사용할 수 있음
-- foreign key 제약조건에 의해 테이블 간의 관계가 형성이 될 수 있다.
-- 부모테이블 , 자식테이블
-- 메뉴테이블에서 메뉴가 부모일까요 카테고리가 부모일까요
-- 카테고리는 자식에게 코드를 줘요 그래서 카테고리가 부모 
-- 메뉴테이블은 카테고리 코드없이 생성될 수 없습니다.
-- 테이블간의 관계에서 자식을 먼저 create 하면 안되요 부모에서 받은 카테고리코드가 존재하지 않으니까
-- 카테고리코드라는게 메뉴코드에서 직접 만드는게 아니라 카테고리에서 끌고오는거에요 
-- 그래서 create 할땐 부모를 읽히고 자식을 잃혀야해요
-- 관계가 형성되면 관계가 형성되어있는 것의 외래키로서 들어가는 거에요

-- 부모 테이블 , 자식테이블

drop table if exists user_grade;
create table if not exists user_grade(
	
    -- user_no int primary key
	grade_code int primary key, 	   	  	
    grade_name varchar(30) not null 		

    
) engine = innodb;

insert into user_grade values
(10,'일반회원'),
(20,'우수회원'),
(30,'특별회원');

select * from user_grade;

drop table if exists user_fk1;
create table if not exists user_fk1(
	
	user_no int primary key, 	   	  	
    user_id varchar(30) not null ,		
    user_pwd varchar(40) not null,
    user_name varchar(30) not null,
    gender varchar(3),
    phone varchar(30) not null,
    email varchar(50),
    grade_no int, 
    foreign key(grade_no) -- grade_no 가 어떤 테이블에서 받는지 적어주어야해요
    references user_grade (grade_code)
    
) engine = innodb;

describe user_fk1;

insert into user_fk1 values 
-- error 1062 : 참조하고 있는 테이블(부모 테이블)에는 존재하지 않는 값을 집어넣을 때
-- 발생하는 에러 => foreign key 제약 조건 위반
( 1, 'user01','pass01','조평훈','남','010-5518-2290','raccon@gmail.com',10),
( 2, 'user02','pass02','조평순','여','010-5518-2290','raccon@gmail.com',20);

-- user_fk1 회원정보테이블 grade 에 대한 정보는 회원은 컬럼하나를 생성해서 이 그래이드 코드를 하나 가지고 있으면 알아서 일반회원 특별회원 우수회원인지 알수있게 끔 만들어 볼꺼에요

insert into user_fk1 values 
( 3, 'user02','pass02','조평순','여','010-5518-2290','raccon@gmail.com',25); 
-- 안들어가져요 참조하는 게 없기 때문입니다. 부모의 값을 땡겨오는 것뿐이지 직접 값을 insert 할 수 업습니다.
-- 부모의 값을 자식이 끌어다 쓴 것이기 때문에

-- 회원이라는 테이블이 있다고 하고 게시글이라는 테이블이 있다고 해요 게시글에 있는 댓글이 있다고 해요
-- 관계를 어떻게 맺는게 쳐요 1명의 회원은 게시글을 여러개 쓸 수 있어요 회원1 게시글N 1대 다의 관계에요
-- 하나의 게시글에 여러개의 댓글을 달수있어요 게시글1 댓글N 
-- 하나의 메뉴는 하나의 카타고리를 가지고 있어요 . 하나의 카테고리는 여러가지 메뉴를 가질 수 있어요 
-- 일대 다관계 그리고 화살표는 일대 다에서 항상 다인 방향으로 향가게 되어 있어요 
-- 하나의 메뉴는 주문을 여러번 할 수 있죠. 생수 2번주문같이
-- 하나의 주문에는 여러 메뉴를 가질 수 있는데 이게 다대 다관계입니다.

-- 기준을 메뉴로 두었을때 카테고리 입장 카테고리입장에서 메뉴를 생각하면서 관계를 형성하는 거에요
-- 부모는 여러개의 자식을 가질 수 있죠. 부모는 여러명의 자식에게 무언가를 나눠줘요.
-- 부모는 많은애한테 무언가를 줘요 메뉴의 부모는 카테고리
-- create 순서도 중요해요 자식을 먼저 create 하면 당연히 안되요

-- check 제약조건 
-- 조건을 위반할 시 허용하지 않는 제약조건
drop table if exists user_check;

-- 술을 파는 사이트, 미성년자 들어오면 안된다. 19살 미만이면 데이터베이스에 접근조차 못하게 해요
-- 사이트에서 성별 남성 여성 하나는 누르면 다른건 못누르게 둘중하나의 값도 check 제약조건을 받는 경우가 있어요 성별은 2가지 값만 받을 것이다 남 or 여
create table if not exists user_check(
	
	user_no int auto_increment primary key, 	   	  	
    user_name varchar(30) not null,
    gender varchar(3) check(gender in ('남','여')),
    age int check(age>=19) 

) engine = innodb;

describe user_check;


insert into user_check values
(null,'홍길동','남',25);
-- (null,'하츄핑','여',7); 체크제약조건을 위반하였으므로 안된다.

-- default
-- nullable 한 컬럼에 비어있는 값 대신 우리가 설정한 기본 값 적용

-- country_name 과 population 을 null 대신 default 로 넣고 싶은 거에요
drop table if exists tbl_country;
create table if not exists tbl_country(
	
	country_code int auto_increment primary key, 	   	  	
    country_name varchar(255) default '한국',
    population varchar(255) default '0명',
	add_time datetime default(current_time()),
    add_day date default (current_date())

) engine = innodb;

insert into tbl_country
values
(null ,default , default, default, default);

select * from tbl_country;








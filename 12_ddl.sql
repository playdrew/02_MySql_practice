
-- DML (Data Manipulation Language) 수정, 삭제, 삽입하여 데이터베이스의 값을 조작하는 것을 의미한다.

use menudb;

-- DDL (Data Definition Language) 
-- 데이터를 정의하는 언어
-- 데이터베이스의 스키마를 정의하거나 수정하는 데 사용되는 SQL 의 부분이다.
-- 데이터베이스의 구조를 변경

-- CREATE 
-- 테이블을 생성하기 위한 구문 ( tbl_menu 처럼 테이블을 만들 수 있게 됩니다 )
-- IF NOT EXIST <- 만약 존재하지 않는다면 ( 기존 테이블이 있는데 똑같은 테이블을 만들면 에러가 생기기에 )
-- 위에 구문을 적용하면 기존에 존재하는 테이블이 있더라도 에러가 발생하지 않는다.

-- 테이블의 컬럼 설정 표현식
-- column_name(category_code처럼의 이름)
-- data_type(length) (어떤 데이터타입을 넣을지)
-- [NOT NULL] [DEFAULT VALUE] [AUTO_INCREMENT] []는 생략가능이고 colunm_constraint 컬럼제약조건들입니다.
-- column_name / data_type(length) [NOT NULL] [DEFAULT VALUE] [AUTO_INCREMENT] column_constraint

-- tb1 테이블 생성
-- tb1 컬럼의 정의는 () 소괄호 내부에다가 작성
-- pk 란 컬럼 데이터타입은 int 컬럼의 제약조건은 primary key
-- col1 에 데이터타입은 문자열 varchar() 소괄호안에 길이지정
-- check 예약어 : 체크제약조건이라고하는데 col1 이 Y N 을 가지고있는지 확인해라라는 뜻 col1 에 'Z' 하면 에러

create table if not exists tb1 (
	pk int primary key, -- primary key로 설정을 했다면 not null 이라는 제약조건이 알아서 걸림
    fk int,				-- 제약조건을 뒤쪽에 작성하지 않으면 null able 널값을 허용하게 됩니다.
    col1 varchar(255)   -- 문자열 길이 지정
    check(col1 in ('Y','N'))
                                
) engine = innodb;

describe tb1;

-- engine = innodb
-- 해당하는 테이블을 innodb 라는 스토리지 엔진으로 만든다는 의미를 가지고 있다
-- MySQL 에서 가장 많이 사용하는 엔진으로서
-- 데이터의 무결성, 안정성, 동시성 제어를 하는 것에 적합하다.

-- 만든 테이블에 값 insert 테스트
-- insert into tb1 values (null, 10 , 'Y'); 'pk' cannot be null pk컬럼은 null을 허용하지 않음
-- insert into tb1 values (1, null, 'G'); check 제약조건상에 check(col1 in ('Y','N') 걸리므로 안됩니다. Y 와 N 빼고는 허용하지 않는다는 필터링 col1 컬럼은 'Y'나 'N' 값 외에는 허용하지 않음 
insert into tb1 values ( 1, 10 , 'Y');

select * from tb1;

-- tb2 생성
create table if not exists tb2 (
	pk int auto_increment  key, -- auto_increment 조건추가
    fk int,					    
    col1 varchar(255)           
    check(col1 in ('Y','N'))
                                
) engine = innodb;

-- 잘못 생성한 테이블 삭제하는 구문 drop table tb2
drop table if exists tb2;

-- Extra 라는 공간에 auto_increment 가 추가된 것을 확인 할 수 있다.
describe tb2;

-- auto_increment
-- insert 시에 pk 라고 하는 컬럼에 자동으로 번호를 발생시킨다.
-- 중복되지 않는 값을 발생시킨다.

insert into tb2 values (null, 10 , 'Y'); -- auto_increment 속성을 적용하지 않았을때는 오류를 발생했어요 insert 시에 지정한 컬럼에 자동으로 번호를 지정시켜서 알아서 넣어줍니다.
insert into tb2 values (null, 20 , 'Y'); 

select * from tb2;

-- alter
-- 테이블에 추가/ 변경/ 삭제 하는 모든 것은 alter 명령어를
-- 사용해서 적용할 수 있다.
-- 값을 추가하는 것이 아니라 테이블에 컬럼이나 제약조건 데이터타입 관련된 것 추가 삭제한다는 것

-- List<MemberDTO> member 라는 변수가 있었으면
-- member.add(멤버객체)

-- 열 추가 -> 컬럼 추가
alter table tb2 
add col2 int not null;

describe tb2;

alter table tb2
drop column col2;

-- 열 삭제 -> 컬럼삭제

-- 열 이름 변경 및 데이터 타입 변경
-- alter table 변경할테이블 change column 기존컬럼명 바꿀컬럼명 컬럼정의(데이터타입, 제약조건)
-- tb2 의 fk 컬럼을 change_fk 로 변경, 제약조건을 not null 바꿔라

alter table tb2 
change column fk change_fk int not null;

describe tb2;

-- 열의 제약 조건 추가 및 삭제
-- alter table 테이블명 drop 제약조건
alter table tb2
drop primary key; 

-- drop 인데 auto_crement 를 제거해야 된다.
-- auto_increment 가 걸려있는 컬럼은 primary key 제거가 되지 않는다.
-- 따라서 auto_increment 속성을 modify 로 제거한다.
-- modify 는 컬럼의 정의를 바꾸는 것이다.

alter table tb2
modify pk int; 

describe tb2;

-- auto increment 제거 후 primanry key 삭제
alter table tb2
drop primary key; 

describe tb2;

-- tb3 생성
create table if not exists tb3 (
	pk int auto_increment key, -- auto_increment 조건추가
    fk int,					    
    col1 varchar(255)           
    check(col1 in ('Y','N'))
                                
) engine = innodb;

describe tb3;
-- tb3 삭제
-- if exists 안전한 식을 만들 수 있다.
drop table if exists tb3; -- 한 번 더 누르면 에러발생 이미 없기 때문에 전체실행하면 반드시 여기서 끊겨요 끊기지 않게 하기 위하여 if exists 로 만든다.

create table if not exists tb4 (
	pk int auto_increment  key, 
    fk int,					    
    col1 varchar(255)           
    check(col1 in ('Y','N'))
                                
) engine = innodb;

create table if not exists tb5 (
	pk int auto_increment  key, 
    fk int,					    
    col1 varchar(255)           
    check(col1 in ('Y','N'))
                                
) engine = innodb;

-- 동시에 테이블 삭제
drop table if exists tb4, tb5;

-- truncate // delete
-- truncate 와 delete 는 라이벌이다.
-- delete 구문을 작성을 하면
-- where 조건절로 행을 삭제
-- 조건 없이 delete 를 하면 전체 행 삭제
-- truncate 구문은 행마다 하나씩 지워주는게 아닌 
-- 테이블을 drop 후 재생성을 해주는 초기화의 개념을 가지고 있다.

-- delete 는 우리가 제어판에서 하나씩 삭제한다라고 치면
-- truncate 는 pc 초기화의 느낌이다.

create table if not exists tb6 (
	pk int auto_increment  key, 
    fk int,					    
    col1 varchar(255)           
    check(col1 in ('Y','N'))
                                
) engine = innodb;

-- 초기화 확인용 더미데이터
insert into tb6 values (null , 10 , 'Y');
insert into tb6 values (null , 20 , 'Y');
insert into tb6 values (null , 30 , 'Y');
insert into tb6 values (null , 40 , 'Y');

select * from tb6;

-- 테이블 초기화
-- truncate 데이터조작 dml 이 아닌 이유는 테이블을 없앴다가 다시 만들어 준 것이에요
-- truncate 데이터를 수정하는 dml 이 아니냐 라고 할 수 있는데
-- 이 친구는 table drop 하고 create 하기 때문에 테이블 구조를 변경한 것이다.
truncate table tb6;










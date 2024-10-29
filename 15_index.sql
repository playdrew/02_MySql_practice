
create table phone (
	phone_code int primary key,
    phone_name varchar(100),
    phone_price decimal(10,2)
) engine = innodb;

-- decimal : sql 에서 숫자 값을 정밀하게 저장하기 위해서 사용한다. 
-- 소수점을 다룰 때 유용하다
-- 1번째 인자 : 정밀도, 전체숫자의 최대 자릿수를 의미 소숫점 앞뒤 포함
-- 2번째 인자 : 소숫점 아래 올 수 있는 최대 자리수 의미

insert into phone 
values
(1,'갤럭시S24울트라',1200000),
(2,'갤럭시Z폴드6',2250000),
(3,'갤럭시Z플립6',1400000);

select * from phone;

-- explain (설명)
-- 우리가 작성한 쿼리문의 실행 계획을 출력해준다.
-- 어떤식으로 동작하는지 보여주는 셈

explain select * from phone where phone_name = '갤럭시S24울트라';

-- rows 행개수 fiiltered 1/3

-- 인덱스가 없는 컬럼을 where 절의 조건으로 실행한 결과

-- index 생성
create index idx_name 
on phone(phone_name);

-- phone 이라는 테이블에서 phone name 이라는 컬럼에 적용을 하겠다.
-- 이렇게 목차를 만들어서 미리 읽었다. 갤럭시S24울트라 등등을 조회하고 어 읽었네 더 빨리 가져오는 셈 
-- 미리 읽혀놓은 다음에 필요할때 후딱 꺼낼 수 있게 하는것

show index from phone;

select * from phone where phone_name = '갤럭시Z폴드6';
-- 실행계획 출력을 통해 인덱스를 통해 데이터를 빠르게 조회했는지 확인
explain select * from phone where phone_name = '갤럭시Z폴드6';

-- row 1 filtered 100
-- 해당하는 컬럼을 인덱스로 등록하게 되면 조회하는 속도가 훨씬 개선이 됩니다.

drop index idx_name on phone;
show index from phone;

-- 많이 동작시켜야 하는 것이 있을때 조회하는 결과의 시간이 단축
-- 빈번한 사용이 필요한 조건이 있을때 인덱스를 사용하면 좋아요(사람들이 많이 들어가는 곳)

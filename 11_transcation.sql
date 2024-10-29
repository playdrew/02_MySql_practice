-- 쿠팡에서 주문버튼을 눌러요 주문버튼을 누르면 집한테 배송을 해주는데요
-- 선별 포장 발송 배달 집으로 오는데요 일련의 과정을 transcation(트랜젝션)을 해요
-- 글쓰기라는 것을 하면 이러한 일련의 과정을 받고 넘기고 데이터베이스에게 넘기고 등등을 하는 과정에서 에러가 발생
-- 포장에서 주문취소를 누르면 주문전 상태로 돌아가야하잖아요 돈도 먹지 않고 일련의 과정이 어떠한 에러가 발생하면 안전하게 돌아가게 하는 것을 말합니다.
-- 데이터베이스는 예상치 못하게 에러 발생을 했을때 돌이킬수 있는 기능을 제공을 해줘요
-- 클래스구조를 컨트롤러 <-> 서비스 <-> 레파지토리 <-> 데이터베이스 값이 이상한 값이 넘어왔다 그럼 롤백을 하는 거에요 서비스 레파지토리 데이터베이스에서요
-- 이상한 값이 들어왔다 저장이 되는게 아니라 다시 돌아가는 롤백
-- 주문 접수 발주 포장 상차 배송 집 포장상태에서 주문취소를 눌렀다 그럼 시작단계로 넘어가는 거에요 이런 식으로 일련의 과정에서 예상치 못한 값이나 에러가 발생하면 주문전으로 보내주는 것을 롤백이라고 합니다.
-- 화면에 입력하는 값을 전달인자인데 입력을 할때 안녕하세요 이런게 아니라 쿼리문을 써요 where 1 = 1; 조건절이 항상 true 이런 식으로 비밀번호없이 뚫리는 경우에 예전에 있었어요 sql 인젝션이라고 하는데 지금은 다 막혔어요
-- 아이디 패스워드 맴버객체에 묶어 전달전달전달하고 해당하는 select 구문에 조회를 해서 select * from member where memberid = id 이런 식으로 다 하는 거에요 다 쿼리문을 돌렸다가 도출된 값을 돌려줍니다.


-- transcation 
-- 데이터베이스에서 한 번에 수행되는 작업의 단위이다.
-- 시작, 진행, 종료 단계를 거치게 되면서 만약 중간에 예기치 못한 값 or 에러 
-- 가 발생할 시 rollback(시작하기 이전 단계로 돌어감)을 진행한다.
-- MySQL 은 default 설정이 auto-commit(자동 저장)이기 때문에
-- 우리가 수행한 쿼리문을 돌릴 수 없다.
-- 따라서 transcation 기능을 사용하기 위해서는 auto-commit 설정을 
-- 해제 해주어야 한다.

-- java 복습 boolean 기본 값은 false false 가 정수로는 0
-- 1 -> true

-- autocommit 활성화
set autocommit = 1;

-- autocommit 비활성화
set autocommit = 0;
set autocommit = OFF;

-- start transcation 구문을 작성을 하면 이제
-- 하나의 과정으로 인식을 하고 commit, rollback 과정을 수행할 수 있다.

start transaction;
select * from tbl_menu;

-- dml 수정 삭제 삽입 진행

insert into tbl_menu values (null,'해장국',9000,2,'Y');
update tbl_menu set menu_name = '해장끝' where menu_code = 28;

-- 작성한 dml 구문이 에러나 이상한 값이 없다면 직접 commit 을 해주어야 반영이 된다.
-- commit 이후에 데이터베이스에 반영이 되어있기 때문에 롤백을 하더라도 전단계로 돌아가지 않는다
commit; -- 변경한 값이 이상이 없다면 

rollback;

-- start transcation 을 만나는 순간 이후의 쿼리는 보호를 받기 시작해서
-- rollback을 하면 start transcation 시작하기 전 단계로 돌아가게 되는 것입니다.

-- @Transcation 이라는 매소드 위에 붙으면 일련의 과정을 보호해서 중간에 에러가 발생하면 롤백을 해줘요
-- 조회(select)할때는 transcation이 필요없어요. 

-- ddl date definition 데이터정의를 하는 것에 대해서 다음에 해볼 것입니다.


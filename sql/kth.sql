CREATE USER KH_SEMI IDENTIFIED BY KH_SEMI; -- 공용 계정 생성
GRANT RESOURCE, CONNECT TO KH_SEMI; -- 권한 설정
GRANT CREATE VIEW TO KH_SEMI; -- View 권한 추가 설정

-- session을 늘리면 연결 문제가 해결될까 싶어서 크게 늘려봄
-- sessions, processes 현재 사용중인 수
SELECT * from v$resource_limit where resource_name in ('processes', 'sessions', 'transactions');

SELECT 
    a.sid, -- SID 
    a.serial#, -- 시리얼번호 
    a.status, -- 상태정보 
    a.process, -- 프로세스정보 
    a.username, -- 유저 
    a.osuser, -- 접속자의 OS 사용자 정보 
    b.sql_text, -- sql 
    c.program -- 접속 프로그램 
FROM v$session a, v$sqlarea b, v$process c 
WHERE a.sql_hash_value=b.hash_value AND a.sql_address=b.address AND a.paddr=c.addr AND a.status='ACTIVE';

ALTER SYSTEM KILL SESSION '21, 9';

ALTER SYSTEM SET processes = 1000 scope=spfile; 
-- 변경할 processes의 값을 넣어주면됨. 
-- 변경후 db 재시작 한다음 processes , sessions수 확인

SELECT a.osuser
               ,a.SID
               ,a.serial#
               ,a.status
               ,b.sql_text
  FROM v$session a
              ,v$sqlarea b
WHERE a.sql_address = b.address;

-- Recruit Part DB 구축 -------------------------------------------------------
------------------------------------------------------------------------------

-- Recruitment Table ---------------------------------------------------------
CREATE TABLE RECRUITMENT (
    R_TITLE VARCHAR(30) PRIMARY KEY,
    R_CODE VARCHAR(30),
    R_START DATE,
    R_END DATE,
    R_TIME VARCHAR(20),
    R_CONTENT1 VARCHAR(1024),
    R_CONTENT2 VARCHAR(1024),
    R_CONTENT3 VARCHAR(1024),
    R_CONTENT4 VARCHAR(1024),
    R_CONTENT5 VARCHAR(1024),
    R_CONTENT6 VARCHAR(1024)
);

DESC RECRUITMENT;

COMMENT ON COLUMN RECRUITMENT.R_TITLE IS '공고명';
COMMENT ON COLUMN RECRUITMENT.R_CODE IS '직무구분';
COMMENT ON COLUMN RECRUITMENT.R_START IS '공고시작일';
COMMENT ON COLUMN RECRUITMENT.R_END IS '공고종료일';
COMMENT ON COLUMN RECRUITMENT.R_TIME IS '공고종류';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT1 IS '공고소개';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT2 IS '주요업무';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT3 IS '자격요건';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT4 IS '우대사항';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT5 IS '혜택및복지';
COMMENT ON COLUMN RECRUITMENT.R_CONTENT6 IS '기타사항';

ALTER TABLE RECRUITMENT 
MODIFY (R_CODE NOT NULL, R_START NOT NULL, R_END NOT NULL, R_TIME NOT NULL);

-- 수정사항 공고번호로 PRIMARY KEY 변경

-- 공고명 PRIMARY KEY 삭제, 먼저 RECRUIT_STATUS 에서 R_TITLE 삭제해야함
ALTER TABLE RECRUITMENT
DROP CONSTRAINT SYS_C007339; 

-- 공고번호 열 추가 primary key
ALTER TABLE RECRUITMENT
ADD R_ID NUMBER PRIMARY KEY;

COMMENT ON COLUMN RECRUITMENT.R_ID IS '공고번호';

-- 공고 테이블 컬럼 순서 변경 -> 안하기로 함 
ALTER TABLE RECRUITMENT2 RENAME TO RECRUITMENT;

-- 직무구분 PK 추가
ALTER TABLE RECRUITMENT
ADD CONSTRAINT FK_R_CODE FOREIGN KEY(R_CODE) REFERENCES RECRUITCODE(R_CODE);

-- RecruitMember Table ---------------------------------------------------------
CREATE TABLE RECRUIT_MEMBER (
    RM_ID NUMBER PRIMARY KEY,
    RM_NAME VARCHAR(30),
    RM_PHONE VARCHAR(30),
    RM_EDUCATION VARCHAR(100),
    RM_CAREER VARCHAR(200),
    RM_EMAIL VARCHAR(50),
    RM_PASSWORD VARCHAR(30)
);

DESC RECRUIT_MEMBER;

COMMENT ON COLUMN RECRUIT_MEMBER.RM_ID IS '지원자번호';
COMMENT ON COLUMN RM_NAME.RM_ID IS '성명';
COMMENT ON COLUMN RECRUIT_MEMBER.RM_PHONE IS '연락처';
COMMENT ON COLUMN RECRUIT_MEMBER.RM_EDUCATION IS '학력사항';
COMMENT ON COLUMN RECRUIT_MEMBER.RM_CAREER IS '경력사항';
COMMENT ON COLUMN RECRUIT_MEMBER.RM_EMAIL IS '이메일';
COMMENT ON COLUMN RECRUIT_MEMBER.RM_PASSWORD IS '비밀번호';

ALTER TABLE RECRUIT_MEMBER 
MODIFY (RM_NAME NOT NULL, RM_PHONE NOT NULL, RM_EDUCATION NOT NULL, 
RM_CAREER NOT NULL, RM_EMAIL NOT NULL, RM_PASSWORD NOT NULL);

ALTER TABLE RECRUIT_MEMBER
MODIFY RM_PASSWORD NULL;

-- RecruitStatus Table ---------------------------------------------------------
DROP TABLE RECRUIT_STATUS;

CREATE TABLE RECRUIT_STATUS (
    RS_ID NUMBER PRIMARY KEY,
    RS_STATE VARCHAR(20)
);

COMMENT ON COLUMN RECRUIT_STATUS.RS_ID IS '지원번호';
COMMENT ON COLUMN RECRUIT_STATUS.RS_STATE IS '지원상태';

ALTER TABLE RECRUIT_STATUS 
ADD R_TITLE VARCHAR(30);

ALTER TABLE RECRUIT_STATUS 
ADD CONSTRAINT FK_R_TITLE FOREIGN KEY(R_TITLE) REFERENCES RECRUITMENT(R_TITLE);

ALTER TABLE RECRUIT_STATUS 
ADD RM_ID NUMBER;

ALTER TABLE RECRUIT_STATUS 
ADD CONSTRAINT FK_RS_ID FOREIGN KEY(RM_ID) REFERENCES RECRUIT_MEMBER(RM_ID);

ALTER TABLE RECRUIT_STATUS
RENAME CONSTRAINT FK_RS_ID TO FK_RS_RM_ID;

COMMENT ON COLUMN RECRUIT_STATUS.R_TITLE IS '공고명';
COMMENT ON COLUMN RECRUIT_STATUS.RM_ID IS '지원자번호';

-- 수정사항 RECRUIT_STATUS 공고번호로 외래키 추가
-- RECRUIT_STATUS 공고명 제거
ALTER TABLE RECRUIT_STATUS
DROP COLUMN R_TITLE CASCADE CONSTRAINTS;
-- RECRUIT_STATUS 공고번호 외래키로 추가
ALTER TABLE RECRUIT_STATUS
ADD R_ID NUMBER
ADD CONSTRAINT FK_R_ID FOREIGN KEY(R_ID) REFERENCES RECRUITMENT(R_ID);

COMMENT ON COLUMN RECRUIT_STATUS.R_ID IS '공고번호';

-- 수정사항2 RECRUIT_STATUS 지원상태 제거, 지원날짜 추가
ALTER TABLE RECRUIT_STATUS
DROP COLUMN RS_STATE;

ALTER TABLE RECRUIT_STATUS
ADD RS_DATE DATE;

COMMENT ON COLUMN RECRUIT_STATUS.RS_DATE IS '지원날짜';

-- Attachment Table ---------------------------------------------------------
CREATE TABLE ATTACHMENT (
    FILE_NO NUMBER PRIMARY KEY,
    REF_NO NUMBER,
    ORIGIN_NAME VARCHAR(200),
    CHANGE_NAME VARCHAR(200),
    UPLOAD_DATE DATE,
    FILE_PATH VARCHAR(1000)
);

COMMENT ON COLUMN ATTACHMENT.FILE_NO IS '파일번호';
COMMENT ON COLUMN ATTACHMENT.REF_NO IS '참조파트번호'; -- 1 공고 2 강의 3 펀딩 4 회원
COMMENT ON COLUMN ATTACHMENT.ORIGIN_NAME IS '파일원본명';
COMMENT ON COLUMN ATTACHMENT.CHANGE_NAME IS '파일수정명';
COMMENT ON COLUMN ATTACHMENT.UPLOAD_DATE IS '업로드일';
COMMENT ON COLUMN ATTACHMENT.FILE_PATH IS '저장폴더경로';

ALTER TABLE ATTACHMENT
ADD CONSTRAINT FK_REF_NO FOREIGN KEY(REF_NO) REFERENCES ATTACHMENT_REFERENCE(REF_NO);


-- Attachment Reference Table ----------------------------------------------
CREATE TABLE ATTACHMENT_REFERENCE (
    REF_NO NUMBER PRIMARY KEY,
    REF_NAME VARCHAR(20)
);

COMMENT ON COLUMN ATTACHMENT_REFERENCE.REF_NO IS '참조파트번호';
COMMENT ON COLUMN ATTACHMENT_REFERENCE.REF_NAME IS '참조파트이름';

INSERT INTO ATTACHMENT_REFERENCE VALUES (1, '공고');
INSERT INTO ATTACHMENT_REFERENCE VALUES (2, '강의');
INSERT INTO ATTACHMENT_REFERENCE VALUES (3, '펀딩');
INSERT INTO ATTACHMENT_REFERENCE VALUES (4, '회원');


-- Portfolio Table ---------------------------------------------------------
DROP TABLE PORTFOLIO;

CREATE TABLE PORTFOLIO (
    P_NO NUMBER PRIMARY KEY,
    FILE_NO NUMBER,
    RM_ID NUMBER,
    CONSTRAINT FK_FILE_NO FOREIGN KEY(FILE_NO) REFERENCES ATTACHMENT(FILE_NO),
    CONSTRAINT FK_RM_ID FOREIGN KEY(RM_ID) REFERENCES RECRUIT_MEMBER(RM_ID)
);

--COMMENT ON COLUMN PORTFOLIO.P_NO IS '첨부파일번호';
COMMENT ON COLUMN PORTFOLIO.P_NO IS '포트폴리오번호';
COMMENT ON COLUMN PORTFOLIO.FILE_NO IS '파일번호';
COMMENT ON COLUMN PORTFOLIO.RM_ID IS '지원자번호';


-- 공고 종류 테이블 R_CODE에 대한 테이블
-- RecruitCode Table -------------------------------------------------------

CREATE TABLE RECRUITCODE (
    R_CODE VARCHAR(30) PRIMARY KEY
);

COMMENT ON COLUMN RECRUITCODE.R_CODE IS '직무구분';

INSERT INTO RECRUITCODE VALUES ('신입');
INSERT INTO RECRUITCODE VALUES ('개발직군');

-- RecruitCode 테이블명 Recruit_code로 변경
ALTER TABLE RECRUITCODE RENAME TO RECRUIT_CODE;

CREATE SEQUENCE SEQ_RM_NO;
CREATE SEQUENCE SEQ_RS_NO;
CREATE SEQUENCE SEQ_P_NO;
CREATE SEQUENCE SEQ_R_ID;
CREATE SEQUENCE SEQ_AT_NO;

-- 시퀀스 이름 NO -> ID로 변경
RENAME SEQ_RS_NO TO SEQ_RS_ID;
RENAME SEQ_RM_NO TO SEQ_RM_ID;

-- 시퀀스 초기화 방법
-- 삭제 후 생성
DROP SEQUENCE SEQ_P_NO;
CREATE SEQUENCE SEQ_P_NO;

-- 권한 없을 때 -> 안됨 뭔가 문제있는듯
--SELECT SEQ_P_NO.NEXTVAL FROM DUAL; -- 3까지 바꿈
---- 시퀀스 현재 값 확인
--SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_P_NO';
---- cache있으면 CURRVAL과 차이남 CURRVAL로 조회하는게 좋음
--SELECT SEQ_P_NO.CURRVAL FROM DUAL;
---- 시퀀스의 INCREMENT를 현재 값 - 1만큼 빼도록 설정 (LAST_NUMBER가 현재값 : 21, CURRVAL : 3)
--ALTER SEQUENCE SEQ_P_NO INCREMENT BY -2; -- 현재값3이면 -2
---- 시퀀스에서 다음 값 가져오기
--SELECT SEQ_P_NO.NEXTVAL FROM DUAL;
---- 시퀀스의 증가값 복구
--ALTER SEQUENCE SEQ_P_NO.INCREMENT BY 1;

-- 기타
-- 오라클 버전 확인
SELECT * FROM PRODUCT_COMPONENT_VERSION;

-- DML 작성 --------------------------------------------------------------------

-- 공고 등록
INSERT INTO RECRUITMENT VALUES 
('title', 'code', SYSDATE, SYSDATE, 'time', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', SEQ_R_ID.NEXTVAL);

-- insertRecruitment
-- INSERT INTO RECRUITMENT VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SEQ_R_ID.NEXTVAL)

-- 공고 수정
UPDATE RECRUITMENT 
SET 
    R_TITLE = '공고 수정 테스트',
    R_CODE = '신입',
    R_START = SYSDATE-5,
    R_END = SYSDATE,
    R_TIME = '상시 채용',
    R_CONTENT1 = '공고 수정1',
    R_CONTENT2 = '공고 수정2',
    R_CONTENT3 = '공고 수정3',
    R_CONTENT4 = '공고 수정4',
    R_CONTENT5 = '공고 수정5',
    R_CONTENT6 = '공고 수정6'
WHERE R_ID = 9;

-- updateRecruitment
-- UPDATE RECRUITMENT SET R_TITLE = ?, R_CODE = ?, R_START = ?, R_END = ?, R_TIME = ?, R_CONTENT1 = ?, R_CONTENT2 = ?, R_CONTENT3 = ?, R_CONTENT4 = ?, R_CONTENT5 = ?, R_CONTENT6 = ? WHERE R_ID = ?;

-- 공고 삭제
DELETE FROM RECRUITMENT WHERE R_ID = 8;

-- deleteRecruitment
-- DELETE FROM RECRUITMENT WHERE R_ID = ?

-- 공고명 조회
SELECT R_TITLE FROM RECRUITMENT;

-- 공고명으로 공고 찾기 (동일한 공고명일 경우 R_ID가 가장 큰걸로)
SELECT * FROM RECRUITMENT WHERE R_ID = (SELECT MAX(R_ID) FROM RECRUITMENT WHERE R_TITLE='test1' GROUP BY R_TITLE);

SELECT * FROM RECRUITMENT;
DELETE FROM RECRUITMENT;
DROP SEQUENCE SEQ_R_ID;
CREATE SEQUENCE SEQ_R_ID;

-- 공고 지원 등록
INSERT INTO RECRUIT_MEMBER VALUES
(SEQ_RM_ID.NEXTVAL, 'name', 'phone', 'education', 'career', 'email', 'password');

-- insertRecruitMemeber
-- INSERT INTO RECRUIT_MEMBER VALUES (SEQ_RM_ID.NEXTVAL, ?, ?, ?, ?, ?, ?)

-- findRecruitMemberWithEmail
-- SELECT * FROM RECRUIT_MEMBER WHERE RM_EMAIL=?

-- insertRecruitStatus
-- INSERT INTO RECRUIT_STATUS VALUES (SEQ_RS_ID.NEXTVAL, ?, ?, SYSDATE)

SELECT * FROM RECRUIT_MEMBER;

DELETE FROM RECRUIT_MEMBER;
DROP SEQUENCE SEQ_RM_ID;
CREATE SEQUENCE SEQ_RM_ID;

-- 공고 지원자 첨부파일 추가
INSERT INTO ATTACHMENT VALUES
(SEQ_At_NO, 1, 'test.jpg', 'test.jpg', SYSDATE, 'path');

SELECT * FROM ATTACHMENT;
DELETE FROM ATTACHMENT;
DROP SEQUENCE SEQ_AT_NO;
CREATE SEQUENCE SEQ_AT_NO;

-- insertAttachment
-- INSERT INTO ATTACHMENT VALUES (SEQ_P_NO.NEXTVAL, 1, ?, ?, SYSDATE, ?)

-- findAttachmentWithOriginName
-- SELECT * FROM ATTACHMENT WHERE ORIGIN_NAME = ?

-- 포트폴리오에 첨부파일 추가
INSERT INTO PORTFOLIO VALUES (SEQ_P_NO.NEXTVAL, 1 , 1);

-- insertPortfolio
-- INSERT INTO PORTFOLIO VALUES (SEQ_P_NO.NEXTVAL, ? , ?)

SELECT * FROM PORTFOLIO;
DELETE FROM PORTFOLIO;
DROP SEQUENCE SEQ_P_NO;
CREATE SEQUENCE SEQ_P_NO;

-- 공고 조회

-- 공고 리스트 조회
-- 가장 최근 기준으로 일정 갯수만
SELECT * FROM (SELECT ROWNUM, A.* FROM RECRUITMENT A ORDER BY R_ID DESC) WHERE ROWNUM BETWEEN 1 AND 5;

-- selectList
-- SELECT * FROM (SELECT ROWNUM, A.* FROM RECRUITMENT A ORDER BY R_ID DESC) WHERE ROWNUM BETWEEN ? AND ?

-- 공고 지원자 첨부파일 조회

SELECT A.* 
FROM Attachment A, Portfolio P
WHERE 1=1
AND P.FIlE_NO = A.FILE_NO
AND P.RM_ID = 1;

-- selectPortfolio
-- SELECT A.* FROM Attachment A, Portfolio P WHERE P.FILE_NO = A.FILE_NO AND P.RM_ID = ?

-- 추후 구현 필요한거
-- 공고에 공고 지원자 등록
-- 공고에 등록한 공고 지원자 조회

-- 공고 CODE 추가
INSERT INTO RECRUITCODE VALUES ('마케팅');
INSERT INTO RECRUITCODE VALUES ('광고사업');
-- insertRecruitCode
-- INSERT INTO RECRUITCODE VALUES (?)

-- 공고 CODE 조회
SELECT * FROM RECRUIT_CODE;
-- selectRecruitCode
-- SELECT * FROM RECRUIT_CODE

-- 공고 CODE 조회 및 그룹별 갯수
SELECT A.R_CODE R_CODE, COUNT(*) COUNT
FROM RECRUIT_CODE A, RECRUITMENT B 
WHERE A.R_CODE = B.R_CODE
GROUP BY A.R_CODE;

-- selectRecruitCodeWithCount
-- SELECT A.R_CODE, COUNT(*) FROM RECRUIT_CODE A, RECRUITMENT B WHERE A.R_CODE = B.R_CODE GROUP BY A.R_CODE

---- DML query 정리 ------------------------------------------------

----- Recruitment -----
-- insertRecruitment
-- INSERT INTO RECRUITMENT VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SEQ_R_ID.NEXTVAL)

-- selectRecruitment
-- SELECT * FROM RECRUITMENT WHERE R_ID = ?
SELECT * FROM RECRUITMENT WHERE R_ID = 6;

-- selectList
-- SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A ORDER BY R_ID DESC) WHERE RNUM BETWEEN ? AND ?
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A ORDER BY R_ID DESC) WHERE RNUM BETWEEN 6 AND 10;

-- selectListWithCode
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_CODE = '개발직군' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 6 AND 10;
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_CODE = '신입' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 1 AND 10;

-- selectListWithTitle
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_TITLE LIKE '%공고%' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 1 AND 5;

-- selectListWithCodeTitle
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_CODE = '개발직군' AND R_TITLE LIKE '%test%' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 1 AND 5;
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_CODE = '개발직군' AND R_TITLE LIKE '%공고%' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 1 AND 5;
SELECT * FROM (SELECT ROWNUM RNUM, A.* FROM RECRUITMENT A WHERE R_CODE = '신입' AND R_TITLE LIKE '%공고%' ORDER BY R_ID DESC) WHERE RNUM BETWEEN 1 AND 5;

-- getListCount
SELECT COUNT(*) FROM RECRUITMENT;

-- getListCountWithCode
SELECT COUNT(*) FROM RECRUITMENT WHERE R_CODE Like '%신입%';
SELECT COUNT(*) FROM RECRUITMENT WHERE R_CODE = '개발직군';

-- getListCountWithTitle
SELECT COUNT(*) FROM RECRUITMENT WHERE R_TITLE LIKE '%test%';

-- getListCountWithCodeTitle
SELECT COUNT(*) FROM RECRUITMENT WHERE R_CODE = '개발직군' AND R_TITLE LIKE '%test%';

-- updateRecruitment
UPDATE RECRUITMENT 
SET 
    R_TITLE = '공고 수정 테스트',
    R_CODE = '신입',
    R_START = SYSDATE-5,
    R_END = SYSDATE,
    R_TIME = '상시 채용',
    R_CONTENT1 = '공고 수정1',
    R_CONTENT2 = '공고 수정2',
    R_CONTENT3 = '공고 수정3',
    R_CONTENT4 = '공고 수정4',
    R_CONTENT5 = '공고 수정5',
    R_CONTENT6 = '공고 수정6'
WHERE R_ID = 9;

-- updateRecruitment
-- UPDATE RECRUITMENT SET R_TITLE = ?, R_CODE = ?, R_START = ?, R_END = ?, R_TIME = ?, R_CONTENT1 = ?, R_CONTENT2 = ?, R_CONTENT3 = ?, R_CONTENT4 = ?, R_CONTENT5 = ?, R_CONTENT6 = ? WHERE R_ID = ?

-- deleteRecruitment
-- DELETE FROM RECRUITMENT WHERE R_ID = ?

-- 공고명 조회
SELECT R_TITLE FROM RECRUITMENT;
-- selectAllTitle
-- SELECT R_TITLE FROM RECRUITMENT


-- 공고명으로 공고 찾기 (동일한 공고명일 경우 R_ID가 가장 큰걸로)
SELECT * FROM RECRUITMENT WHERE R_ID = (SELECT MAX(R_ID) FROM RECRUITMENT WHERE R_TITLE='test1' GROUP BY R_TITLE);

-- findRecruitmentWithTitle
-- SELECT * FROM RECRUITMENT WHERE R_ID = (SELECT MAX(R_ID) FROM RECRUITMENT WHERE R_TITLE=? GROUP BY R_TITLE)

----- RecruitMember -----
-- insertRecruitMember
-- INSERT INTO RECRUIT_MEMBER VALUES (SEQ_RM_ID.NEXTVAL, ?, ?, ?, ?, ?)

-- insertRecruitStatus
-- INSERT INTO RECRUIT_STATUS VALUES (SEQ_RS_ID.NEXTVAL, ?, ?, SYSDATE)

----- Attachment -----
-- insertAttachment
-- INSERT INTO ATTACHMENT VALUES (SEQ_P_NO.NEXTVAL, ?, ?, ?, SYSDATE, ?, ?)

-- findAttachmentWithOriginName
-- SELECT * FROM ATTACHMENT WHERE ORIGIN_NAME = ?

----- Portfolio -----
-- insertPortfolio
-- INSERT INTO PORTFOLIO VALUES (SEQ_P_NO.NEXTVAL, ?, ?)

-- selectPortfolio
-- SELECT A.* FROM Attachment A, Portfolio P WHERE P.FILE_NO = A.FILE_NO AND P.RM_ID = ?

----- RecruitCode -----
-- insertRecruitCode
-- INSERT INTO RECRUIT_CODE VALUES (?)

-- selectRecruitCode
-- SELECT A.R_CODE R_CODE, COUNT(*) COUNT FROM RECRUIT_CODE A, RECRUITMENT B WHERE A.R_CODE = B.R_CODE GROUP BY A.R_CODE


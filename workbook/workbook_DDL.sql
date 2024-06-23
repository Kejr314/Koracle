-- < DDL >
/*
1. 계열 정보를 저장할 카테고리 테이블을 만들려고 핚다. 다음과 같은 테이블을 작성하시오.
*/
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

/*
2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
*/ 
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

/*
3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
*/
ALTER TABLE TB_CATEGORY
ADD CONSTRAINT CATEGORY_KEY PRIMARY KEY(NAME);

/*
4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
*/
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

/*
5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10으로, 컬럼명이 NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
*/
ALTER TABLE TB_CATEGORY MODIFY (NAME VARCHAR2(20));
ALTER TABLE TB_CLASS_TYPE MODIFY (NAME VARCHAR2(20), NO VARCHAR2(10));

/*
6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.(ex. CATEGORY_NAME)
*/
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;

/*
7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
    Primary Key 의 이름은 ‚PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )
*/
SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;

ALTER TABLE TB_CATEGORY DROP CONSTRAINT CATEGORY_KEY;
ALTER TABLE TB_CATEGORY ADD CONSTRAINT PK_CATEGORY_NAME PRIMARY KEY(CATEGROY_NAME);

ALTER TABLE TB_CLASS_TYPE DROP CONSTRAINT SYS_C007047;
ALTER TABLE TB_CLASS_TYPE ADD CONSTRAINT PK_CLASS_TYPE_NAME PRIMARY KEY(CLASS_TYPE_NAME);

/*
8. 다음과 같은 INSERT 문을 수행한다.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 
*/
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 

/*
9.TB_DEPARTMENT의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY를 지정하시오. 
이때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )
*/
ALTER TABLE TB_DEPARTMENT 
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY)
REFERENCES TB_CATEGORY(CATEGORY_NAME);

/*
10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 핚다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
- 뷰 이름 : VW_학생일반정보
- 컬럼 : 학번, 학생이름, 주소
*/
GRANT CREATE VIEW TO CHUN; -- VIEW 권한 부여

CREATE VIEW VW_학생일반정보 AS
SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 학생이름, STUDENT_ADDRESS AS 주소
FROM TB_STUDENT;

/*
11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다.
이를 위해 사용할 학생이름, 학과이름, 담당교수이름으로 구성되어 있는 VIEW 를 만드시오.
이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오
(단, 이 VIEW 는 단순 SELECT 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
- 뷰 이름 : VW_지도면담
- 컬럼 : 학생이름, 학과이름, 지도교수이름
*/
CREATE VIEW VW_지도면담 AS
SELECT STUDENT_NAME AS 학생이름, DEPARTMENT_NAME AS 학과이름, NVL(PROFESSOR_NAME, '없음') AS 지도교수이름
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO;

/*
12. 모든 학과의 학과별 학생 수를 확인핛 수 있도록 적적할 VIEW 를 작성해 보자.
- 뷰 이름 : VW_학과별학생수
- 컬럼 : DEPARTMENT_NAME, STUDENT_COUNT
*/
CREATE VIEW VW_학과별학생수 AS
SELECT DEPARTMENT_NAME, COUNT(*) AS STUDENT_COUNT
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
GROUP BY DEPARTMENT_NAME;

SELECT * FROM VW_학과별학생수;

/*
13. 위에서 생성한 학생일반정보 View를 통해서 학번이 A213046 인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오.
*/
UPDATE VW_학생일반정보
SET 학생이름 = '김마루'
WHERE 학번 = 'A213046';

SELECT * FROM VW_학생일반정보 WHERE 학번 = 'A213046';

/* 
14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를 어떻게 생성해야 하는지 작성하시오.
*/
- VIEW를 생성할 때 WITH READ ONLY 옵션을 작성한다.

/* 
15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 
최근 3년을 기준으로 수강인원이 가장 많았던 3과목을 찾는 구문을 작성해보시오.
*/
SELECT *
FROM
    (SELECT C.CLASS_NO AS 과목번호, C.CLASS_NAME AS 과목이름, COUNT(*) AS 누적수강생수
    FROM TB_CLASS C
    JOIN TB_GRADE G ON C.CLASS_NO = G.CLASS_NO
    WHERE SUBSTR(G.TERM_NO, 1, 4) IN ('2005', '2006', '2007', '2008', '2009')
    GROUP BY C.CLASS_NO, C.CLASS_NAME
    ORDER BY 3 DESC
    )
WHERE ROWNUM <= 3; -- 상위 3개 결과 선택
-- ROWNUM : 상위 N개의 행 선택. 결과가 정렬되기 전 할당되기 때문에 정렬된 결과에서 상위 N개의 행을 선택하려면 서브쿼리 사용해야 함























GRANT CONNECT, RESOURCE TO CHUN;

SELECT * FROM TB_CLASS;
SELECT * FROM TB_STUDENT; 

// < Basic SELECT >
/* 
7.  혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 
어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
*/
SELECT * 
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

/*
 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.
*/
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

// < Additional SELECT - 함수 >
/*
7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까? 
또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까? 
*/ 
 TO_DATE('99/10/11','YY/MM/DD') -- 2099년 10월 11일
 TO_DATE('49/10/11','YY/MM/DD') -- 2049년 10월 11일
 TO_DATE('99/10/11','RR/MM/DD') -- 1999년 10월 11일 
 TO_DATE('49/10/11','RR/MM/DD') -- 2049년 10월 11일
 
// YY : 2000년대, RR : 50 미만 = 2000년대 / 50 이상 = 1990년대
 
/* 
8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
*/
SELECT STUDENT_NO "학번", STUDENT_NAME "이름"
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

/*
10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이 출력되도록 하시오.
*/
SELECT DEPARTMENT_NO "학과번호", COUNT(*) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;                     

// < Additional SELECT - Option >

/*
7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
*/
SELECT CLASS_NAME "과목 이름", DEPARTMENT_NAME "학과 이름"
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

/*
8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오. 
*/
SELECT CLASS_NAME "과목 이름", PROFESSOR_NAME "교수 이름"
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);

/*
15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.
*/
SELECT * FROM TB_GRADE ORDER BY STUDENT_NO ASC;

SELECT STUDENT_NO "학번", STUDENT_NAME "이름", DEPARTMENT_NAME "학과 이름", ROUND(AVG(POINT), 8) "평점"
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY (STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME)
HAVING AVG(POINT) >= 4
ORDER BY 1;

/*
16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
*/
SELECT CLASS_NO, CLASS_NAME, ROUND(AVG(POINT), 8)
FROM TB_CLASS
JOIN TB_GRADE USING(CLASS_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY (CLASS_NO, CLASS_NAME)
ORDER BY 1;

/*
19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오. 
단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
*/
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT), 1) "전공평점"
FROM TB_DEPARTMENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY =
(SELECT CATEGORY FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY 1;































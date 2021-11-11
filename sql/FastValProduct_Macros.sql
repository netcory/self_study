/*
* FastValProduct_Macros 테이블의 Step Down 입력 (표준)
*
* 변경내역
  -
*/
WITH POSTN AS
(
SELECT POSTN_ID_NM                  AS Reference
      ,TO_CHAR(PR_VL_AMT)           AS NOTIONAL
      ,TO_CHAR(TO_DATE(CTRT_DT,'YYYYMMDD'),'DD-MON-YYYY','NLS_DATE_LANGUAGE=ENGLISH') AS EFFECTIVE_DATE
      ,TO_CHAR(TO_DATE(EXCS_END_DT,'YYYYMMDD'),'DD-MON-YYYY','NLS_DATE_LANGUAGE=ENGLISH') AS MATURITY
    FROM RMO02GB
    WHERE STD_DT = '@BaseDate'
    AND OPT_TYP_CD IN ('18', '21')
)
,A AS
(
SELECT '@BaseDate' AS Base_Date
      ,'Step Down' AS Object
      ,Name
      ,Reference
      ,(CASE WHEN SUBSTR(VAL, 1, 1) = '.' THEN '0' || VAL
             ELSE VAL
        END) AS "VALUE"
      ,'RMO02B' AS Source_Table_Name
      ,TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS Final_Update_Datetime
    FROM (SELECT NAME
                ,REFERENCE
                ,VAL
            FROM POSTN
            UNPIVOT (VAL FOR NAME IN (NOTIONAL, EFFECTIVE_DATE, MATURITY))
            ) T
WHERE VAL IS NOT NULL
)

-- INSERT INTO AID_FastValProduct_Macros
SELECT Base_Date
      ,Object
      ,NAME
      ,Reference
      ,"VALUE"
      ,Source_Table_Name
      ,Final_Update_Datetime
    FROM A
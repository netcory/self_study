/*
* FastValProduct_AuxTableData 테이블의 Step Down 입력 (표준)
*
* 변경내역
  -
*/
WITH TT AS
(
SELECT T2.POSTN_ID_NM
      ,T1.VAL_END_DT                AS X            -- 평가종료일
      ,T1.OPT_EXCS_PRC1/100         AS "barrier"    -- 옵션행사가1
      ,T1.EXCS_PY_AMT1/100          AS "redemption" -- 중도상환지급금액1
    FROM RMO04B T1
    INNER JOIN RMO02B T2
    ON(T1.INS_RE_GDS_CD = T2.INS_RE_GDS_CD)
    WHERE 1=1
    AND T1.STD_DT = '@BaseDate'
    AND T2.STD_DT = '@BaseDate'
    AND T2.OPT_TYP_CD IN ('18', '21')
)

,A AS
(
SELECT '@BaseDate' AS Base_Date
      ,'Step Down' AS Object
      ,POSTN_ID_NM AS Refrence
      ,Name
      ,X
      ,Y
      ,'RMO04B,RMO02B' AS Source_Table_Name
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS Final_Update_Datetime
    FROM (SELECT POSTN_ID_NM
                ,Name
                ,X
                ,Y
            FROM TT
        UNPIVOT (Y FOR Name IN ("barrier", "redemption"))
        UNION ALL
        SELECT 'NA', 'barrier_cont', '0', 0.85 FROM DUAL
        UNION ALL
        SELECT 'NA', 'barrier_cont', '1', 0.75 FROM DUAL
        UNION ALL
        SELECT 'NA', 'barrier_cont', '2', 10 FROM DUAL
        UNION ALL
        SELECT 'NA', 'barrier_cont', '3', 10 FROM DUAL
        UNION ALL
        SELECT 'NA', 'barrier_cont', '4', 10 FROM DUAL
        UNION ALL
        SELECT 'NA', 'barrier_cont', '5', 0.5 FROM DUAL
        )
)
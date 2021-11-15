/*
* FastValProduct_CustomSchedules 테이블의 Step Down 입력 (표준)
*
* 변경내역
  -
*/
WITH A AS
(
SELECT '@BaseDate'              AS Base_Date
      ,'Step Down'              AS Object
      ,T1.POSTN_ID_NM           AS Reference
      ,'autocall'               AS Name
      ,T2.VAL_END_DT            AS Schedules_FixingDate     -- 평가종료일
      ,T2.VAL_END_DT            AS Schedules_StartDate      -- 평가종료일
      ,T2.VAL_END_DT            AS Schedules_EndDate        -- 평가종료일
      ,T3.PY_DT                 AS Schedules_PayDate        -- 지급일
      ,'ACT_360'                AS Schedules_Basis
      ,'RMO02B,RMO04B,RMO05B'   AS Source_Table_Name
      ,TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS Final_Update_Datetime
      ,ROW_NUMBER() OVER(PARTITION BY T2.INS_RE_GDS_CD, T2.VAL_END_DT ORDER BY T3.PY_DT) AS RN1
      ,ROW_NUMBER() OVER(PARTITION BY T3.INS_RE_GDS_CD, T3.PY_DT ORDER BY T2.VAL_END_DT) AS RN2
    FROM RMO02B T1  -- 포지션
    INNER JOIN RMO04B T2    -- 평가일
    ON (T1.INS_RE_GDS_CD = T2.INS_RE_GDS_CD)
    INNER JOIN RMO05B T3    -- 지급일
    ON (T1.INS_RE_GDS_CD = T3.INS_RE_GDS_CD)
    WHERE 1=1
    AND T1.OPT_TYP_CD IN ('18', '21')
    AND T1.STD_DT = '@BaseDate'
    AND T2.STD_DT = '@BaseDate'
    AND T3.STD_DT = '@BaseDate'
)

-- INSERT INTO AID_FastValProduct_CustomSchedules
SELECT Base_Date
      ,Object
      ,Reference
      ,Name
      ,Schedules_FixingDate
      ,Schedules_StartDate
      ,Schedules_EndDate
      ,Schedules_PayDate
      ,Schedules_Basis
      ,Source_Table_Name
      ,Final_Update_Datetime
    FROM A
    WHERE RN1 = RN2
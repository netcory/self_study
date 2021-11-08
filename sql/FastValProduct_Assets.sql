/*
* FastValProduct_Assets 테이블의 Step Down 입력 (표준)
*
* 변경내역
  -
*/
WITH A AS
(
SELECT '@BaseDate'                  AS Base_Date
      ,'Step Down'                  AS Object
      ,'T2.POSTN_ID_NM'             AS Reference                --  포지션 ID
      ,TRIM(T1.BSC_ASTS_IS_CD)      AS Name                     --  기초자산종목코드
      ,(CASE WHEN TRIM(T1.BSC_ASTS_IS_CD) IN ('HSCEI', 'HSI') THEN 'HKD'
             WHEN TRIM(T1.BSC_ASTS_IS_CD) = 'NKY' THEN 'JPY'
             WHEN TRIM(T1.BSC_ASTS_IS_CD) = 'SPX' THEN 'USD'
             WHEN TRIM(T1.BSC_ASTS_IS_CD) = 'SX5E' THEN 'EUR'
             WHEN TRIM(T1.BSC_ASTS_IS_CD) = 'KOSPI200' THEN 'KRW'
             ELSE T4.PR_VL_CRNCY_CD
        END)                        AS YieldCurveName           -- 추후 RMI18B, RMI06B 테이블 통해 유동적으로 입력하도록 수정
--    ,T3.CRNCY_CD                  AS YieldCurveName           -- 통화코드
      ,'EQUITY'                     AS "Type"
      ,'LOCAL_VOL'                  AS Model
      ,'RMO03B,RMO02B'              AS Source_Table_Name
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS Final_Update_Datetime
    FROM RMO03B T1
    INNER JOIN RMO02B T2
    ON (T1.INS_RE_GDS_CD = T2.INS_RE_GDS_CD AND T1.STD_DT = T2.STD_DT)
--  LEFT OUTER JOIN (SELECT T12.CD_NM
--                         ,T11.CRNCY_CD
--                    FROM RMI18B T11
--                  INNER JOIN RMI06B T12
--                      ON (TRIM(T11.STK_PRC_INDX_ID_NM) = T12.DTLS_CD_NM)
--                   WHERE T11.STD_DT = 'BaseDate'
--                     AND T12.CD_CLSF_NM = '주가지수매핑'
--                  ) T3
--              ON (TRIM(T1.BSC_ASTS_IS_CD) = T3.CD_NM)
    LEFT OUTER JOIN RRS12B T4
    ON (TRIM(T1.BSC_ASTS_IS_CD) = T4.IS_CD)
    WHERE 1=1
    AND T1.STD_DT = '@BaseDate'
    AND T2.STD_DT = '@BaseDate'
    AND T2.OPT_TYP_CD IN ('18', '21')
)

-- INSERT INTO AID_FastValProduct_Assets
SELECT Base_Date
      ,Object
      ,Reference
      ,Name
      ,YieldCurveName
      ,"Type"
      ,Model
      ,Source_Table_Name
      ,Final_Update_Datetime
    FROM A
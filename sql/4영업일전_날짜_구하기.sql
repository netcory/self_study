-- 특정 날짜로부터 4영업일전 날짜를 계산하기 위한 oracle query
-- Equity Discrete Asian Option 신설 상품 가공

WITH BSNSS_DAY AS
(
    SELECT A.DT, LAG(A.DT, 4) OVER (ORDER BY A.DT) AS "FOUR_BFR_BSNSS_DAY"
    FROM (
            SELECT TO_CHAR (SDT + LEVEL -1, 'YYYYMMDD') DT,
                   TO_CHAR (SDT + LEVEL -1, 'D') D
              FROM (
                    SELECT TO_DATE('@BaseDate', 'YYYYMMDD') - 10 SDT,
                           TO_DATE(20991231, 'YYYYMMDD') EDT
                      FROM DUAL)
            CONNECT BY LEVEL <= EDT - SDT + 1) A,
            (
                SELECT DT
                  FROM RRA71B
                  WHERE DT >=  TO_CHAR(SYSDATE, 'YYYY')
                  AND CITY_CD = 'SK'
            ) B
WHERE A.DT = B.DT(+)
AND A.D NOT IN ('1', '7')
AND B.DT IS NULL
ORDER BY A.DT ASC
)

, A AS (
    SELECT A.POSTN_ID_NM    AS Reference
          ,NVL(A.HDQT_CD || A.DPRT_CD || A.DESK_ID_NM, '999999')    AS BookNode
          ,A.GDS_CD AS ProductCode
          ,A.PR_VL_CRNCY_CD AS Currency
          ,CASE WHEN A.TRD_CCD = 'L' THEN 'Buy'
                WHEN A.TRD_CCD = 'S' THEN 'Sell' END    AS BuySell
          ,TO_CHAR(B.FOUR_BFR_BSNSS_DAY)    AS First_Sample_Date
          ,C.MTRT_DT    AS Maturity
          ,TO_CHAR(A.BLNC_Q * A.CTRT_MLTPLR, 'FM9999999999990.099999') AS Unit
          ,CASE WHEN C.CALL_PUT_CCD = 'C' THEN 'Call'
                WHEN C.CALL_PUT_CCD = 'P' THEN 'Put' END    AS OptionType
          ,C.NOW_PRC    AS Strike
          ,TRIM(DECODE(C.BSC_ASTS_IS_CD, 'MIKRW_KOSPI2', 'KOSPI200', 'MIKRW_KOSDAQ', 'KOSDAQ150', C.BSC_ASTS_IS_CD)) AS Equity
          ,TRIM(DECODE(C.BSC_ASTS_IS_CD, 'MIKRW_KOSPI2', 'KOSPI200', 'MIKRW_KOSDAQ', 'KOSDAQ150', C.BSC_ASTS_IS_CD)) || '.' || A.PR_VL_CRNCY_CD AS Equity_Volatility
          ,TRIM(A.INS_RE_GDS_CD)    AS INS_RE_GDS_CD
          ,TO_NUMBER(A.BLNC_Q * A.CTRT_MLTPLR)  AS Notional
      FROM RMI48B A
          ,RMI36B C
    LEFT JOIN BSNSS_DAY B
           ON C.MTRT_DT = B.DT
     WHERE A.STD_DT = '@BaseDate'
       AND A.STD_DT = C.STD_DT
       AND A.INS_RE_GDS_CD = C.IS_CD
       AND A.GDS_CD = 'ELW'
       AND A.DL_TYP_CD != 'ZZ'
       AND A.GDS_CD = C.GDS_CD
       AND A.MKT_PRC_AMT > 0
       AND C.OPT_EXCS_PRC IS NOT NULL
)


-- INSERT INTO AID_EquityDiscreteAsianOption

SELECT '@BaseDate'  AS Base_Date
      ,'N'  AS RWA_YN
      /* 기타 컬럼 입력 */
      ,'RMI48B, RMI36B'  AS Source_Table_Name
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:Mi:SS')  AS Final_Update_Datetime
  FROM A
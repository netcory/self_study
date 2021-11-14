#! /bin/sh
##------------------------------------------------------------------------------------
## AA 리스크산출 Main Shell
##------------------------------------------------------------------------------------
## in_run_aa.sh $1 기준일자 $2 리스크산출작업구분 $3 추출/적재작업구분 $4 산출작업구분
##------------------------------------------------------------------------------------
## 리스크산출 작업구분
##  F: FRTB
##  I: 내부모형
##  N: 산출안함
## 기초데이터 추출/적재 작업구분
##  OO: Open시 추출O 적재O
##  OL: Open시 추출X 적재O
##  AA: 일상   추출O 적재O
##  AL: 일상   추출X 적재O
##  NN: -----  추출X 적재X
##  
## 산출작업구분
## 0: 전체
## 1: 내부모형 산출모듈 호출 (HS VaR)
## 2: 내부모형 산출모듈 호출 (PV)
## 3: 내부모형 산출모듈 호출 (Cashflow)
## 4: 내부모형 산출모듈 호출 (Duration)
## 5: 내부모형 산출모듈 호출 (Sensitivity)
## 6: 내부모형 산출모듈 호출 (가상손익)
## 7: 내부모형 산출모듈 호출 (스트레스테스트)
##------------------------------------------------------------------------------------
## EX) FRTB     작업(ERMS 추출X AA 적재O 산출 및 이관X): in_run_aa.sh 20210531 N AL 0
##     FRTB     작업(ERMS 추출O AA 적재O 산출 및 이관O): in_run_aa.sh 20210531 F AA 0
##     FRTB     작업(ERMS 추출X AA 적재O 산출 및 이관O): in_run.aa.sh 20210531 F AL 0
##     FRTB     작업(ERMS 추출X AA 적재X 산출 및 이관O): in_run_aa.sh 20210531 F NN 0
##     내부모형  작업(ERMS 추출X AA 적재X 산출 및 이관O): in_run_aa.sh 20210531 I NN O
##------------------------------------------------------------------------------------

if [ $# -ne 4]
then
    echo "/*---------------------------------------------*/"
    echo "/*-- arg1: BaseDate                          --*/"
    echo "/*-- arg2: WorkTp(I, F)                      --*/"
    echo "/*-- arg3: ExtrTp(O, A, N)                   --*/"
    echo "/*-- arg4: CalcTp(0, 1, 2, 3, 4, 5, 6, 7)    --*/"
    exit 1
fi

BASE_DT = $1
BASE_MN = `expr substr $1 1 6`
WORK_TP = $2
EXTR_TP = $3
CALC_TP = $4

##------------------------------------------------------------------------------------
## 1. ERMS 추출 및 AA 이관, AA 적재
## - Open시 sd_aa_ftp_in_all_open.sh $1
## - 일상시 sd_aa_ftp_in_all.sh $1
##------------------------------------------------------------------------------------

if [ ${EXTR_TP} = "OO" ]
then
    ##-----------------------------------------------------
    echo "Open시 추출O 적재O 작업"
    ##-----------------------------------------------------
    sd_aa_ftp_in_all_open.sh $BASE_DT
    sd_aa_ftp_in.sh $BASE_DT RRS02B
    sd_aa_ftp_in.sh $BASE_DT RSP01B
    result = $(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\00_file_erms_open.ps1 $BASE_DT""")
elif [ ${EXTR_TP} = "OL" ]
then
    ##-----------------------------------------------------
    echo "Open시 추출X 적재O 작업"
    ##-----------------------------------------------------
    result = $(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\00_file_erms_open.ps1 $BASE_DT""")
elif [ ${EXTR_TP} = "AA" ]
then
    ##-----------------------------------------------------
    echo "일상   추출O 적재O 작업"
    ##-----------------------------------------------------
    sd_aa_ftp_in_all.sh $BASE_DT
    sd_aa_ftp_in.sh $BASE_DT RRS02B
    sd_aa_ftp_in.sh $BASE_DT RSP01B
    result = $(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\00_file_erms.ps1 $BASE_DT""")
elif [ ${EXTR_TP} = "AL" ]
then
    ##-----------------------------------------------------
    echo "일상,   추출X 적재O 작업"
    ##-----------------------------------------------------
    result = $(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\00_file_erms.ps1 $BASE_DT""")
else
    echo "ERMS 추출/AA적재 생략"
    results = "su"
fi

if [ "$result" != "su" ]; then
    echo "FAIL"
    exit 1
fi

##-----------------------------------------------------
## 2. AA 서버 리스크산출 배치 호출 및 AA산출결과 ERMS로 전송
##-----------------------------------------------------
if [ ${WORK_TP} = "I" ]
then
    ##-----------------------------------------------------
    echo "AA 내부모형 산출 및 ERMS전송 작업"
    ##-----------------------------------------------------
    results = $(in_run_aa_im.sh $BASE_DT $CALC_TP)
    echo "$result"
elif [ ${WORK_TP} = "F" ]
then
    ##-----------------------------------------------------
    echo "AA FRTB 산출 및 ERMS전송 작업"
    ##-----------------------------------------------------
    results = $(in_run_aa_frtb.sh $BASE_DT $CALC_TP)
    echo "$result"
else
    echo "AA 리스크산출 및 ERMS전송 생략"
fi


ReturnCode1 = $BASE_DT

exit ${ReturnCode1}
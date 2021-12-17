#! /bin/sh
##-----------------------------------------------------
## AA FRTB 산출 및 ERMS전송
## in_run_aa_frtb.sh $1 기준일자 $2 산출작업구분
##-----------------------------------------------------
if [ $# -ne 2 ]
then
    echo "/*---------------------------------------------*/"
    echo "/*-- arg1: BaseDate                          --*/"
    echo "/*-- arg2: CalcTp                            --*/"
    echo "/*---------------------------------------------*/"
    exit 1
fi

BASE_DT = $1
BASE_MN = `expr substr $1 1 6`
CALC_TP = $2

##-----------------------------------------------------
echo "InsightStudio구동 Batch 호출 - FRTB SA 지주전송"
##-----------------------------------------------------
result = $(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\01_frtbsa.ps1 $BASE_DT""")
result2 = `expr substr $result 1 2`

if [ "$result2" = "su" ]; then
    echo "SUCCESS"
else
    echo "FAIL"
##      exit 1
f1

##-----------------------------------------------------
echo "FRTB 지주전송용 Output파일(.dat) ERMS로 가져오기"
##-----------------------------------------------------
sd_aa_ftp_out_frtb.sh $BASE_MN

##-----------------------------------------------------
## 3.ERMS FRTB TABLE에 결과 적재
##-----------------------------------------------------
sd_aa_rslt_bat_frtb.sh $BASE_MN

##-----------------------------------------------------
## 이하 rdmdev로 user 바꿔서 실행해야 함.
## 4. 지주전송용 .dat .chk 파일 생성
## pd_frtb_dat_cre.sh 202105
## 5. 지주전송 Shell 호출
## pd_send_frtb.sh 202105
##-----------------------------------------------------

ReturnCode1 = $BASE_DT

exit ${ReturnCode1}
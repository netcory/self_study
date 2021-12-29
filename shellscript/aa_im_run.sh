#! /bin/sh
##--------------------------------------------------
## AA 내부모형 산출 및 ERMS 전송
## aa_im_run.sh $1 기준일자 $2 산출작업구분
##--------------------------------------------------
echo "/*----------------------------------*/"
echo "/*-- arg1: BaseDate               --*/"
echo "/*-- arg2: CalcTp                 --*/"
echo "/*----------------------------------*/"

# 일배치 DT_FILE="std_dt_d.data"
DT_FILE="std_dt_d.data"
FILE_NAME=`ls $PARAM_PATH | grep "${DT_FILE}"`

BASE_DT=`cat $PARAM_PATH/${DT_FILE}`
CALC_TP="0"

if [ $# -ne 0]; then
        BASE_DT=$1

        if [$# -ne 2 ]; then
            CALC_TP=$2
        fi
fi

echo "${CALC_TP} ${CALC_TP}"

##--------------------------------------------------
## 1. InsightStudio 구동 Batch 호출
##--------------------------------------------------
if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "1" ]; then
    echo "00_inner_market.ps1 - 내부관리 시장&거래 생성"
    result=$(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\00_inner_market.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if[ "$result2" = "su" ]; then
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi

if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "2" ]; then
    echo "01_hsvar.ps1 - 내부관리 계산"
    result=$(ssh adaptiv@128.16.248.224 powershell "& ""D:\Batch\01_hsvar.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if [ "$result2" = "su" ]; then
            FILE_NM='HSVaR_'
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi

if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "3" ]; then
    echo "01_duration.ps1 - Duration 산출"
    result=$(ssh adaptiv @128.16.248.224 powershell "& ""D:\Batch\01_duration.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if [ "$result2" = "su" ]; then
            FILE_NM='HSVaR_'
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi

if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "4" ]; then
    echo "01_cashflow.ps1 - Cashflow 산출"
    result=$(ssh adaptiv@128.16.248.224 powershell "$ ""D:\Batch\01_cashflow.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if [ "$result2" = "su" ]; then
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi

if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "5" ]; then
    echo "01_local.ps1 - 현지법인 산출"
    result=$(ssh adaptiv@128.16.248.224 powershell "$ ""D:\Batch\01_local.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if [ "$result2" = "su" ]; then
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi

if [ ${CALC_TP} = "0" ] || [ ${CALC_TP} = "6" ]; then
    echo "01_noaction.ps1 - 가상손익 산출"
    result=$(ssh adaptiv@128.16.248.224 powershell "$ ""D:\Batch\01_noaction.ps1 $BASE_DT""")
    result2=`expr substr $result 1 2`

    if [ "$result2" = "su" ]; then
        echo "SUCCESS"
    else
        echo "FAIL"
    ##  exit 1
    fi
fi


ReturnCode1=$BASE_DT

exit ${ReturnCode1}
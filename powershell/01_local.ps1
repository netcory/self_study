# 현지법인 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@date,2@'
$Sequence = Invoke-RestMethod -Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers = @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 160,
    operator_params: "[{\"type\":\"text\",\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"name\":\"기준일자\",\"hide\":false},
                       {\"type\":\"text\",\"value\":\"SEN_PV_HK\",\"value_name\":\"@Path\",\"name\":\"생성폴더\",\"hide\":false},
                       {\"type\":\"text\",\"value\":\"' + $Sequence + '\",\"value_name\":\"@Seq\",\"name\":\"seq\",\"hide\":false},
                       {\"type\":\"text\",\"value\":\"N\",\"value_name\":\"@RWA_YN\",\"name\":\" 지주전송월데이터여부\"},
                       {\"type\":\"text\",\"value\":\"Y\",\"value_name\":\"@Main\",\"name\":\"아카이브여부\",\"codegroup_id\":\"USE_YN\",\"hide\":false},
                       {\"type\":\"code_multi\",\"value\":[\"AUD\",\"CNY\",\"EUR\",\"EURCRS\",\"GBP\",\"GBPCRS\",\"HKD\",\"HKDCRS\",\"IRKRW_Corp_AA0\",\"IRKRW_Interbank\",\"JPY\",\"JPYCRS\",\"KRW\",\"KRWCRS\",\"USD\",\"USD.L6M\"],\"value_name\":\"@FactorID\",\"name\":\"팩터ID\",\"codegroup_id\":\"INTEREST_RATE_FACTOR_ID\",\"code_multi_option\":\"multi\"}]"
}'

$PostParam = [System.Text.Encoding]::UTF8.GetBytes($Body)

$Uri = 'http://localhost:5000/v2/flowrun/batch/create'
$FlowId = Invoke-RestMethod -Method 'Post' -Body $PostParam -Uri $Uri -UseDefaultCredential -Headers $headers
$UriStatus = 'http://localhost:5000/v2/flowrun/batch/status/' + $FlowId
$Status = "Pending"

Do
{
    Start Sleep -Seconds 5
    $Status = Invoke-RestMethod -Method 'Get' -Uri $UriStatus -UseDefaultCredential -Headers $headers

} While ($Status -eq "pending" -or $Status -eq "inprogress")

Write-Output $Status
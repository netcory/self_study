# 내부관리 계산 (HSVaR, Market Value, Sensitivity, Stress Test) ERMS 배치 연동

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@date,2@'
$Sequence = Invoke-RestMethod - Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers = @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 1038,
    operator_params: "[{\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"type\":\"text\"},
                       {\"value\":[\"ASX200\",\"CCMP\",\"HSCEI\",\"HSI\",\"KOSPI200\",\"NKY\",\"SPX\",\"SX5E\"],\"value_name\":\"@FixedExd\",\"codegroup_id\":\"FIXED_EXP\",\"code_multi_option\":\"multi\",\"type\":\"code_multi\"},
                       {\"value\":\"HSVAR\",\"value_name\":\"@Path\",\"type\":\"text\"},
                       {\"value\":\"' + $Sequence + '\",\"value_name\":\"@Seq\",\"type\":\"text\"},
                       {\"value\":\"N\",\"value_name\":\"@RWA_YN\",\"type\":\"text\"},
                       {\"value\":[\"AUD\",\"CNY\",\"EUR\",\"EURCRS\",\"GBP\",\"GBPCRS\",\"HKD\",\"HKDCRS\",\"IRKRW_Corp_AA0\",\"IRKRW_Interbank\",\"JPY\",\"JPYCRS\",\"KRW\",\"KRWCRS\",\"USD\",\"USD.L6M\"],\"value_name\":\"@FactorID\",\"codegroup_id\":\"INTEREST_RATE_FACTOR_ID\",\"code_multi_option\":\"multi\",\"type\":\"code_multi\"},
                       {\"value\":\"Y\",\"value_name\":\"@Main\",\"type\":\"text\"}]"
}'

$PostParam = [System.Text.Encoding]::UTF8.GetBytes($Body)

$Uri = 'http://localhost:5000/v2/flowrun/batch/create'
$FlowId = Invoke-RestMethod -Method 'Post' -Body $PostParam -Uri $Uri -UseDefaultCredential -Headers $headers
$UriStatus = 'http://localhost:5000/v2/flowrun/batch/status/' + $FlowId
$Status = "Pending"

Do
{
    Start-Sleep -Seconds 5
    $Status = Invoke-RestMethod -Method 'Get' -Uri $UriStatus -UseDefaultCredential -Headers $headers

} While ($Status -eq "pending" -or $Status -eq "inprogress")

Write-Output $Status
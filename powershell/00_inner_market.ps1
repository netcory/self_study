# 내부관리 시장&거래 생성 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$headers - @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 193,
    operator_params: "[{\"type\":\"date\",\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"name\":\"기준일자\"},{\"type\":\"code_multi\",\"value\":[\"ASX200\",\"CCMP\",\"HSCEI\",\"HSI\",\"KOSPI200\",\"NKY\",\"SPX\",\"SX5E\"],\"value_name\":\"@FixedExd\",\"name\":\"고정만기 대상지수\",\"codegroup_id\":\"FIXED_EXP\",\"code_multi_option\":\"multi\"}]"
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
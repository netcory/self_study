# 내부관리 시장&거래 생성 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$headers - @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 193,
    operator_params: "[{\"default\":\"20210531\",\"type\":\"date\",\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"name\":\"기준일자\"}]"
}'

$Uri = 'http://localhost:5000/v2/flowrun/batch/create'
$FlowId = Invoke-RestMethod -Method 'Post' -Body $body -Uri $Uri -UseDefaultCredential -Headers $headers
$UriStatus = 'http://localhost:5000/v2/flowrun/batch/status/' + $FlowId
$Status = "Pending"

Do
{
    Start-Sleep -Seconds 5
    $Status = Invoke-RestMethod -Method 'Get' -Uri $UriStatus -UseDefaultCredential -Headers $headers
} While ($Status -eq "pending" -or $Status -eq "inprogress")

Write-Output $Status

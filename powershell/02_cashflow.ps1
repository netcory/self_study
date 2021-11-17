# Cashflow 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@sequence,HS_VaR_Cashflow,M@'
$Sequence = Invoke-RestMethod -Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers - @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 162,
    operator_params: "[{\"default\":\"\",\"type\":\"date\",\"value\":\"NaNaNaN\",\"value_name\":\"@BaseDate\",\"name\":\"작업기준일자\",\"hide\":false},{\"default\":\"N\",\"type\":\"text\",\"value\":\"N\",\"value_name\":\"@RWA_YN\",\"name\":\"지주전송월작업여부\",\"hide\":false},{\"default\":\"CASHFLOW\",\"type\":\"text\",\"value\":\"CASHFLOW\",\"value_name\":\"@Path\",\"name\":\"생성폴더\",\"hide\":false},{\"default\":\"@sequence,HS_VaR_Cashflow,M@\",\"type\":\"text\",\"value\":\"407\",\"value_name\":\"@Seq\",\"name\":\"Seq\",\"hide\":false}]"
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
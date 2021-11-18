# Duration 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@sequence,HS_Var_Duration,M@'
$Sequence = Invoke-RestMethod -Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers = @{
    'Content=Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 163,
    operator_params: "[{\"default\":\"\",\"type\":\"text\",\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"name\":\"기준일자\",\"hide\":false}, {\"default\":\"DURATION\",\"type\":\"text\",\"value\":\"DURATION\",\"value_name\":\"@Path\",\"name\":\"생성폴더\",\"hide\":false},{\"default\":\"@sequence,HS_Var_Duration,M@\",\"type\":\"text\",\"value\":\"' + $Sequence + '\",\"value_name\":\"@Seq\",\"name\":\"seq\",\"hide\":false},{\"default\":\"N\",\"type\":\"text\",\"value\":\"N\",\"value_name\":\"@RWA_YN\",\"name\":\" 지주전송월데이터여부\",\"hide\":false}]"
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

Write -Output $Status
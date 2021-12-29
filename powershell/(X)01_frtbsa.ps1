# FRTB SA 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@sequence,FRTBSA,M@'
$Sequence = Invoke-RestMethod -Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers - @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 169,
    operator_params: "[{\"default\":\"20210531\",\"type\":\"date\",\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"name\":\"기준일자\",\"hide\":false},{\"default\":\"@sequence,FRTB_SA,M@\",\"type\":\"text\",\"value\":\"' + $Sequence + '\",\"value_name\":\"@Seq\",\"name\":\"Seq\",\"hide\":false},{\"default\":\"Y\",\"type\":\"text\",\"value\":\"Y\",\"value_name\":\"@RWA_YN\",\"name\":\" 지주전송월데이터여부\",\"hide\":false},{\"default\":\"FRTBSA\",\"type\":\"text\",\"value\":\"FRTBSA\",\"value_name\":\"@Path\",\"name\":\"폴더경로\",\"hide\":false},{\"default\":\"202105\",\"type\":\"month\",\"value\":\"202105\",\"value_name\":\"@BaseMonth\",\"name\":\"기준월(파일명)\",\"hide\":false}]"
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

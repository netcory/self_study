# FRTB SA 자동화 작업 연동 배치 스크립트

$baseDate = $args[0]

$GetSeqUri = 'http://localhost:5000/v2/flow/sequence/@date,2@'
$Sequence = Invoke-RestMethod -Method 'Get' -Uri $GetSeqUri -UseDefaultCredential

$headers - @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$Body = '{
    flow_id: 1039,
    operator_params: "[{\"value\":\"' + $baseDate + '\",\"value_name\":\"@BaseDate\",\"type\":\"text\"},
                       {\"value\":\"FRTBSA\",\"value_name\":\"@Path\",\"type\":\"text\"},
                       {\"value\":\"' + $Sequence + '\",\"value_name\":\"@Seq\",\"type\":\"text\"},
                       {\"value\":\"Y\",\"value_name\":\"@RWA_YN\",\"type\":\"text\"},
                       {\"value\":\"0.85\",\"value_name\":\"@S1EQShift\",\"type\":\"text\"},
                       {\"value\":\"1.2\",\"value_name\":\"@S1FXShift\",\"type\":\"text\"},
                       {\"value\":\"1.0150\",\"value_name\":\"@S1IRShift1\",\"type\":\"text\"},
                       {\"value\":\"1.0100\",\"value_name\":\"@S1IRShift2\",\"type\":\"text\"},
                       {\"value\":\"1.30\",\"value_name\":\"@S1VOLShift2\",\"type\":\"text\"},
                       {\"value\":\"0.70\",\"value_name\":\"@S2EQShift2\",\"type\":\"text\"},
                       {\"value\":\"1.30\",\"value_name\":\"@S2FXShift2\",\"type\":\"text\"},
                       {\"value\":\"1.0200\",\"value_name\":\"@S2IRShift1\",\"type\":\"text\"},
                       {\"value\":\"1.030\",\"value_name\":\"@S2IRShift2\",\"type\":\"text\"},
                       {\"value\":\"1.50\",\"value_name\":\"@S2VOLShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S3EQShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S3FXShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S3IRShift1\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S3IRShift2\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S3VOLShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S4EQShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S4FXShift\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S4IRShift1\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S4IRShift2\",\"type\":\"text\"},
                       {\"value\":\"1.1\",\"value_name\":\"@S4VOLShift\",\"type\":\"text\"}]"
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
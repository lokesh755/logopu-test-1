cd C:\actions-runner

Invoke-WebRequest -Uri $latestVersionWindowsRunnerURL.browser_download_url -OutFile "runner.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem ; 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\runner.zip", "$PWD")


cd C:\

Remove-Item -Recurse C:\actions-runner -Force -ErrorAction SilentlyContinue



Write-Host "Get Registration Token"

$registrationTokenUrl = "https://api.github.com/repos/testorg755/logopu-test/actions/runners/registration-token"

$headers = @{
 "Content-Type"="application/json"
 "Authorization"= "token 434d08c2a7632651e4b94a34a2a78b3993ce2d11"
} 

$registrationToken = ((Invoke-WebRequest -Uri $registrationTokenUrl -Method 'Post' -Headers $headers).Content | ConvertFrom-Json).token

Write-Host "Configure runner"


 
.\config.cmd --url https://github.com/testorg755/logopu-test --token $registrationToken --name windows-runner --labels canary --unattended --replace --runasservice


If (Get-ChildItem -Recurse .\_diag | Select-String "Listening for Jobs")
{
    Write-Host "Found"
}
else {
    Write-Host "Not Found"
}
    

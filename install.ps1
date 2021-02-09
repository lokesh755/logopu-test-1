$ORG = "testorg755"
$REPO = "logopu-test"

#$GITHUB_TOKEN = ${{ secrets.CANARY_TOKEN }}


$releases = "https://api.github.com/repos/actions/runner/releases"

Write-Host Determining latest release

$assets = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].assets

$latestVersionWindowsRunnerURL = $assets | Where-Object { $_.browser_download_url -like "*win*" } | Select -First 1 -Property browser_download_url

mkdir C:\actions-runner 

cd C:\actions-runner

Invoke-WebRequest -Uri $latestVersionWindowsRunnerURL.browser_download_url -OutFile "runner.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem ; 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\runner.zip", "$PWD")


cd C:\

Remove-Item -Recurse C:\actions-runner -Force -ErrorAction SilentlyContinue

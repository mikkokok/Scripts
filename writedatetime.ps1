$targetDir = "C:\Temp"
$targetFile = "datetime.txt"
if (-Not (Test-Path -Path $targetDir)) {
    New-Item -Name $targetDir -ItemType Directory
}
(Get-Date).DateTime | Out-File "$targetDir\$targetFile" -Append
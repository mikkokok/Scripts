$targetPath = "C:\"
$targetDir = "Temp"
$targetFile = "datetime.txt"
if (-Not (Test-Path -Path $targetDir)) {
    New-Item -Path $targetPath -Name $targetDir -ItemType Directory
}
(Get-Date).DateTime | Out-File "$targetPath\$targetDir\$targetFile" -Append

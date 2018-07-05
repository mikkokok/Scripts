param (
    [string]$Which
)

function DisplayHelp()
{
    DisplayCat
    Write-Host "Call 'script.ps1 -Which Images' to remove all images (except Microsoft images)"
    Write-Host "Call 'script.ps1 -Which Containers' to remove all containers"
}
function DisplayCat() 
{
Write-Host @"    
               .__....._             _.....__,
                 .": o :':         ;': o :".
                 `. `-' .'.       .'. `-' .'  
                   `---'             `---' 

         _...----...      ...   ...      ...----..._
      .-'__..-""'----    `.  `"`  .'    ----'""-..__`-.
     '.-'   _.--"""'       `-._.-'       '"""--._   `-.`
     '  .-"'                  :                  `"-.  `
       '   `.              _.'"'._              .'   `
             `.       ,.-'"       "'-.,       .'
               `.                           .'
                 `-._                   _.-'
                     `"'--...___...--'"`"
Powered by mikkokok
"@
}
function clearAllDockerContainers() 
{
    $dockerOutput = docker ps -a
    Try
    {
        foreach ($Index in 0..$dockerOutput.GetUpperBound(0))
        {
            $dockerOutput[$Index] = $dockerOutput[$Index] -replace '\s{23,}', ',,' -replace '\s{2,}', ','
        }
    }
    Catch
    {
        Write-Host "Nothing to remove, returning"
        return
    }

    $DockerPSA_Objects = $dockerOutput | ConvertFrom-Csv


    $Ids = $DockerPSA_Objects | select-object -ExpandProperty 'CONTAINER ID'
    if ($Ids.Count -le 0) {
        Write-Host "Nothing to remove, returning"
        return
    }
    Write-Host $Ids
    
    foreach ($id in $Ids) 
    {
        Try {
            Write-Host $id
            docker stop $id
            docker rm $id
        }
        Catch 
        {
            continue
        }
    }
    clearAllDockerContainers
    Write-Host "All containers removed"
}

function clearAllDockerImages() 
{
    $dockerOutput = docker images -a

    Try 
    {
        foreach ($Index in 0..$dockerOutput.GetUpperBound(0))
        {
            $dockerOutput[$Index] = $dockerOutput[$Index] -replace '\s{23,}', ',,' -replace '\s{2,}', ','
        }
    }
    Catch 
    {
        Write-Host "Nothing to remove, returning"
        return
    }

    $DockerImages = $dockerOutput | ConvertFrom-Csv
    if ($DockerImages.Count -le 0) 
    {
        Write-Host "Nothing to remove, returning"
        return
    }
    $NumberOfMsImages = GetNumberOfMsImages $DockerImages
    $MSImages = 0
    foreach ($Image in $DockerImages) 
    {
        $ImageName = $Image | Select-Object -ExpandProperty 'REPOSITORY'
        if (($ImageName) -and ($ImageName.StartsWith("microsoft")))
        {
            $MSImages++
            if ($MSImages -eq $NumberOfMsImages) 
            {
                return
            }
            continue
        }
        $ImageID = $Image | Select-Object -ExpandProperty 'IMAGE ID'
        $ImageTag = $Image | Select-Object -ExpandProperty 'TAG'
        Write-Host $ImageID
        Try 
        {
            docker rmi --force  $ImageID
            docker rmi --force  $ImageTag
        }
        Catch 
        {
            continue
        }
    }
    clearAllDockerImages
    Write-Host "All images removed"
}
function GetNumberOfMsImages($DockerImages) 
{
    $NumberOfMsImages = 0
    foreach ($Images in $DockerImages) 
    {
        $ImageName = $Image | Select-Object -ExpandProperty 'REPOSITORY'
        if (($ImageName) -and ($ImageName.StartsWith("microsoft")))
        {
            $NumberOfMsImages++
        }
    }
    return $NumberOfMsImages
}

Write-Host $Which
if ($Which -eq "Images") 
{
    clearAllDockerImages
}
elseif($Which -eq "Containers")
{
    clearAllDockerContainers
}
else
{ 
    DisplayHelp
}

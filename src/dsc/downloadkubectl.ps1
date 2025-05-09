$architecture = $Args[0]
$configuration = $Args[1]
$destinationPath = ""
$destinationFile = ""

if ( ($architecture -eq "osx-x64") -or ($architecture -eq "osx-arm64") -or ($architecture -eq "linux-x64") -or ($architecture -eq "linux-arm64"))
{
    $destinationFolder = "./bin/" + $configuration + "/net9.0/" + $architecture + "/kubectl/" + $Args[2]
    $destinationFile = $destinationFolder + "/kubectl"
}
else
{
    $destinationFolder = ".\\bin\\" + $configuration + "\\net9.0\\" + $architecture + "\\kubectl\\" + $Args[2]
    $destinationFile = $destinationFolder + "\\kubectl.exe"
}

Write-Output $destinationFile
Write-Output $destinationFolder
if (Test-Path -Path $destinationFile)
{
    Write-Output "kubectl already present. Skipping download"
    Exit
}


New-Item -Path $destinationFolder -ItemType Directory -Force

if ($architecture -eq "osx-x64")
{
    Write-Output "Starting mac download"
    curl https://dl.k8s.io/release/v1.33.0/bin/darwin/amd64/kubectl  -o $destinationFile
    chmod +x $destinationFile
}
elseif ($architecture -eq "osx-arm64")
{
    Write-Output "Starting mac download"
    curl https://dl.k8s.io/release/v1.33.0/bin/darwin/arm64/kubectl  -o $destinationFile
    chmod +x $destinationFile
}
elseif ($architecture -eq "linux-x64")
{
    Write-Output "Starting linux download"
    curl https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl  -o $destinationFile
    chmod +x $destinationFile
}
elseif ($architecture -eq "linux-arm64")
{
    Write-Output "Starting linux download"
    curl https://dl.k8s.io/release/v1.33.0/bin/linux/arm64/kubectl  -o $destinationFile
    chmod +x $destinationFile
}
else
{
    Write-Output "Starting windows download"
    curl https://dl.k8s.io/release/v1.33.0/bin/windows/amd64/kubectl.exe -o $destinationFile
}

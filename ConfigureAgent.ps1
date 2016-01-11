#
# Description : Configures the Visual Studio Team Services Agent on a local machine
# 
# Arguments   : 
#

param
(

)

function Setup-Prerequisite
{

if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}
if(!(Test-Path $env:ChocolateyInstall\lib\Psake*)) { cinst psake -y }
if(!(Test-Path $env:ChocolateyInstall\lib\WindowsAzurePowershell*)) { cinst WindowsAzurePowershell -y }
i
choco install visualstudio2015community -y --force
}

function Install-Agent
{
$shell = New-Object -com shell.application
$zip = $shell.NameSpace((Get-Location).Path + "\agent.zip")
foraech($item in $zip.items())
{
    $shell.Namespace((Get-Location).Path).copyhere($item)
}

}

Setup-Prerequisite
Install-Agent

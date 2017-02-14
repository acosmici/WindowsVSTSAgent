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
if(!(Test-Path $env:ChocolateyInstall\lib\JavaSE*)) { cinst jdk8 -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Maven*)) { cinst maven -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Gradle*)) { cinst gradle -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Ant*)) { cinst ant -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Gulp-Cli*)) { cinst gulp-cli -y }
if(!(Test-Path $env:ChocolateyInstall\lib\NugetPackageManager*)) { cinst nugetpackagemanager -y }
if(!(Test-Path $env:ChocolateyInstall\lib\NodeJS*)) { cinst nodejs.install -y }
if(!(Test-Path $env:ChocolateyInstall\lib\WindowsAzurePowershell*)) { cinst WindowsAzurePowershell -y }
if(!(Test-Path $env:ChocolateyInstall\lib\VisualStudio2015Community*)) { cinst visualstudio2015community -y --force}
}

function Install-Agent
{
$shell = New-Object -com shell.application
$zip = $shell.NameSpace((Get-Location).Path + "\agent.zip")
foreach($item in $zip.items())
{
    $shell.Namespace((Get-Location).Path).copyhere($item)
}

}

Setup-Prerequisite
Install-Agent


param
(

[string] $serverURL,
[string] $PATToken,
[string] $poolName,
[string] $agentName

)

function Setup-Prerequisite
{

if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}
if(!(Test-Path $env:ChocolateyInstall\lib\Psake*)) { cinst psake -y }
if(!(Test-Path $env:ChocolateyInstall\lib\JavaSE*)) { cinst jdk8 -y }
if(!(Test-Path $env:ChocolateyInstall\lib\git*)) { cinst git -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Maven*)) { cinst maven -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Gradle*)) { cinst gradle -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Ant*)) { cinst ant -y }
if(!(Test-Path $env:ChocolateyInstall\lib\Gulp-Cli*)) { cinst gulp-cli -y }
if(!(Test-Path $env:ChocolateyInstall\lib\NugetPackageManager*)) { cinst nugetpackagemanager -y }
if(!(Test-Path $env:ChocolateyInstall\lib\NodeJS*)) { cinst nodejs.install -y }
if(!(Test-Path $env:ChocolateyInstall\lib\bower*)) { cinst bower -y }
if(!(Test-Path $env:ChocolateyInstall\lib\WindowsAzurePowershell*)) { cinst WindowsAzurePowershell -y }
if(!(Test-Path $env:ChocolateyInstall\lib\VisualStudio2015Community*)) { cinst visualstudio2015community -y --force}
}

function Configure-Agent
{
#create the directory that will store the agent.zip file

$agentdir="C:\agent_work\repo"

If (Test-Path $agentdir){

    Write-Output "Agent Directory is present and the creation will be skipped"
         
 }Else{
        
    Write-Output "Agent Directory is not present and it will be created"
	New-Item -ItemType Directory -Force -Path $agentdir 
  
	}

#download the agent.zip file from url
$VSTSAgentsource = "https://raw.githubusercontent.com/acosmici/WindowsVSTSAgent/develop/agent.zip"
$destination = $agentdir + "\agent.zip"
 
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($VSTSAgentsource, $destination)

#unzip files to a target directory
$shell = new-object -com shell.application
$zip = $shell.NameSpace($agentdir + "\agent.zip")
foreach($item in $zip.items())
{
$shell.Namespace($agentdir).copyhere($item) 
}

#configure the agent
$runfile = $agentdir + "\run.cmd"
$configFile = $agentdir + "\config.cmd"


& $configFile  --unattended --url $serverUrl --auth PAT --token $PATToken --pool $poolName --agent $agentName --work C:\agent_work


#run the agent as a windows service
New-Service -Name "VSTSAgent" -BinaryPathName $runfile -DisplayName "VSTSAgent" -StartupType Auto
}

#restart is needed for a full visual studio installation
function Restart-VM
{
	#a restart is needed for a full visual studio installation
	shutdown -f -r
}

Setup-Prerequisite

Configure-Agent

Restart-VM
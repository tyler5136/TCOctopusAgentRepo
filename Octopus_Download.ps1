
<#  #Maybe move these functions to the installer functions ps1
function LogMe {
	Tee-Object -filepath $processLog -Append
}
function addLog {
	param (
		$ContentParameter
	)
	add-content -Path $processLog -Value $ContentParameter
}
<#
#Get password input for 'download4u2' password for download site
addLog 'Console: Type in Credentials for tulsaconnect.com/downloads'
read-host -assecurestring | convertfrom-securestring | out-file .\mysecurestring.txt 
$passwordtc = Get-Content '.\mysecurestring.txt'  | ConvertTo-SecureString 
$downloadcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $usernametc, $passwordtc
#>
$tcDownloadSitePass = 'download4u2'  
$passwordtc = ConvertTo-SecureString $tcDownloadSitePass -AsPlainText -Force
$downloadCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $downloadUsernameTC, $passwordtc

#Get credentials for the download website
addLog "Begginning Octopus_Download.ps1 `n `n"
#$downloadCred = Get-Credential -UserName $downloadUsernameTC -Message 'Type in the credentials for https://tulsaconnect.com/downloads'
addLog "Type in the credentials for https://tulsaconnect.com/downloads"
addLog "User input $downloadUsernameTC as the username and a new password."

#Declare all Download Variables
addLog "Saving ObjVar for download connections."
$SettingsDownload = @{
     	Uri             = 'https://www.tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/configurator.settings.exe'
     	OutFile         = 'C:\Octo SPLA\configurator.settings'
     	Credential      = $downloadCred
}
$ScannerDownload = @{
     	Uri             = 'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/InventoryScan.exe'
     	OutFile         = 'C:\Octo SPLA\InventoryScan.exe'
     	Credential      = $downloadCred
}
$ConfiguratorDownload = @{
     	Uri             = 'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/OC%20SPLA%20Scanner.cfg.exe'
     	OutFile         = 'C:\Octo SPLA\OC SPLA Scanner.cfg' 
     	Credential      = $downloadCred
}
$ScannerConfDownload = @{
     	Uri             =  'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/OctopusConfigurator.exe'
     	OutFile         =  'C:\Octo SPLA\OctopusConfigurator.exe'
     	Credential      = $downloadCred
}
addLog 'Done Saving ObjVar for download connections.'


#Add the Folder for the Octopus Files
if (Test-Path -Path $OctopusFolderPath) {
    addLog "$(Get-Date) - Octopus folder already present on system. Skipping to file download `n" 

} 
else {
	addLog "$(Get-Date) - Adding the Folder for Octopus Files `n" 
	New-Item -Path "C:\" -Name "Octo SPLA" -ItemType "directory" 2>&1| LogMe
}


#Download Octopus files from tulsaconnect.com
addLog "$(Get-Date) - Begining download of Octopus Files"
Invoke-WebRequest @SettingsDownload *>&1 | LogMe
Invoke-WebRequest @ScannerDownload *>&1 | LogMe
Invoke-WebRequest @ConfiguratorDownload *>&1 | LogMe
Invoke-WebRequest @ScannerConfDownload *>&1 | LogMe


addLog "$(Get-Date) - Files downloaded Successfully (Maybe)" | LogMe
#>

<#  #Testing out Functionality
#Declare globals
$PSScriptRoot = 'C:\TCScripts'
Write-Output '$(Get-Date) - Beginning installation of Octopus `n ... `n .. `n . Logging all output to .\LogFile.txt `n `n' | Tee-Object -filepath .\LogFile.txt -Append

$log = ".\LogFile.txt"
function LogMe {
	Tee-Object -filepath .\LogFile.txt -Append
}
function addLog {
	param (
		$ContentParameter
	)
	add-content -Path .\LogFile.txt -Value $ContentParameter
}

$OctopusPassword = 'Octopus99!'
$usernametc = 'download'
#Get password input for 'download4u2' password for download site
Write-Output 'Type in password for tulsaconnect.com/downloads'
addLog 'Console: Type in password for tulsaconnect.com/downloads'
read-host -assecurestring | convertfrom-securestring | out-file .\mysecurestring.txt 
$passwordtc = Get-Content '.\mysecurestring.txt'  | ConvertTo-SecureString 
$downloadcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $usernametc, $passwordtc
#Declare all Download Variables
$SettingsDownload = @{
     	Uri             = 'https://www.tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/configurator.settings.exe'
     	OutFile         = 'C:\Octo SPLA\configurator.settings'
     	Credential      = $downloadcred
}
$ScannerDownload = @{
     	Uri             = 'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/InventoryScan.exe'
     	OutFile         = 'C:\Octo SPLA\InventoryScan.exe'
     	Credential      = $downloadcred
}
$ConfiguratorDownload = @{
     	Uri             = 'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/OC%20SPLA%20Scanner.cfg.exe'
     	OutFile         = 'C:\Octo SPLA\OC SPLA Scanner.cfg' 
     	Credential      = $downloadcred
}
$ScannerConfDownload = @{
     	Uri             =  'https://tulsaconnect.com/downloads/Octopus/Octopus%20SPLA/OctopusConfigurator.exe'
     	OutFile         =  'C:\Octo SPLA\OctopusConfigurator.exe'
     	Credential      = $downloadcred
}

Write-Output "$(Get-Date) - Credentials Saved `n ... `n .. `n . `n `n" | LogMe

#Add the Folder for the Octopus Files
$OctopusFolderPath = 'C:\Octo SPLA'
if (Test-Path -Path $OctopusFolderPath) 
{
    Write-Output "$(Get-Date) - Octopus folder already present on system. Skipping to file download `n" 

} 
else 
{
	Write-Output "$(Get-Date) - Adding the Folder for Octopus Files `n" | LogMe
	New-Item -Path "C:\" -Name "Octo SPLA" -ItemType "directory" 2>&1| LogMe
}



#Download Octopus files from tulsaconnect.com
Write-Output "$(Get-Date) - Begining download of Octopus Files" | LogMe

Invoke-WebRequest @SettingsDownload *> .\ErrorLog.log 
Invoke-WebRequest @ScannerDownload *> .\ErrorLog.log 
Invoke-WebRequest @ConfiguratorDownload *> .\ErrorLog.log
Invoke-WebRequest @ScannerConfDownload *> .\ErrorLog.log 
#>
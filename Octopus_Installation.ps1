#Declare globals
##Declare Paths
$cDrive = 'C:\'
$scriptFolder = $cDrive + 'TCScripts'
$processLog = $scriptFolder + '\LogFile.txt'
$errorLogFile = $scriptFolder + '\ErrorLog.txt'
$installerFunctions = $scriptFolder + '\Installer_Functions.ps1'
$octopusDownloader = $scriptFolder + '\Octopus_Download.ps1'
$userAddProgram = $scriptFolder + '\User_Add.ps1'
#Declare Primary Variables
$localHostGroup = 'TulsaConnect'
#$OctopusPassword = 'Octopus99!'
$downloadUsernameTC = 'download'
$OctopusFolderPath = $cdrive + 'Octo SPLA'
#$LocalHostUsername = '0'
#$LocalHostPassword = '0'


#Objects 
$teeProcess = @{
    FilePath = $processLog
    Append = 1
}


#Load Downloader and userbuilder
. $installerFunctions


#Add Log file and make first log indicating the beginning of the installation process
addLogFile
addLog "Beginning installation of Octopus `n ... `n .. `n . Logging all output to .\LogFile.txt `n `n"

#debug
addLog "Script is operating out of $scriptFolder"
addLog "Process Log is located at $processLog"
addLog "Errors will be logged to $errorLogFile"
addLog "Installer will verify that $localHostGroup is present on the system and assign the current user and any new users created to that group."
addLog "Octopus folder will be created at $octopusFolderPath"


#Run subscript for Octopus Downloader
. $octopusDownloader


#Run subscript for User add
. $userAddProgram

<#  Commenting out to test functionality 
    #Add function for logging data during process.
$cDrive = 'C:\'
$scriptDrive = 'C:\TCScripts'
$processLog = 'C:\TCScripts\LogFile.txt'
$localHostGroup = 'TulsaConnect'
    #Temporarily Removed Variables
#$LocalHostUsername = '0'
#$LocalHostPassword = '0'


#Objects
$teeProcess = @{
    FilePath = $processLog
    Append = 1
}

<#  #Temporarilgy Removed Functions
function addLog {
    Param (
        $contentParameter
    )
    Write-Output $logParameter
	add-content -path $processLog -Value $contentParameter
}
function addLogFile {
    if (Test-Path -Path $processLog) 
    {
        $folderAlreadyThere = "$(Get-Date) - Script folder already in place. Skipping folder creation `n"
        Write-Output $folderAlreadyThere
        Add-Content -path $processLog -Value "####################################################################################################################"
        Add-Content -path $processLog -Value "###### Starting New User Add Program###################"
        Add-Content -path $processLog -Value $folderAlreadyThere
    } 
    else 
    {
        $addFolderMessage = "$(Get-Date) - Adding the Folder for New Script Logs `n"
	    Write-Output $addFolderMessage 
	    New-Item -Path $cDrive -Name "TCScripts" -ItemType "directory" 
        New-Item -Path $scriptDrive -Name "LogFile.txt" -ItemType "file" 
        addLog $addFolderMessage
    }
}


addLogFile
#>



function userCreate {
    #$ErrorActionPreference = 'Stop'
    $VerbosePreference = 'Continue'

    #Declare LocalUser Object
    $ObjLocalUser = $null
    Write-Verbose "Searching for $($LocalHostUsername) in LocalUser DataBase" | Tee-Object @teeProcess


    try {
        $ObjLocalUser = Get-LocalUser -Name $LocalHostUsername #-ErrorAction SilentlyContinue
    }
    catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
        "User $($LocalHostUsername) was not found" | Write-Warning 
    }
    catch {
        "An unspecifed error occured" | Write-Error 
        Write-Output $_
        addlog "An unspecified error occured"
        addlog $_
        return
    }


    #Create the user if it was not found (Example)
    if (!$ObjLocalUser) {
        Write-Verbose "Creating User $LocalHostUsername" | Tee-Object @teeProcess
        New-LocalUser @UserAdd | Tee-Object @teeProcess
    }
    else {
        Write-Verbose "User $($LocalHostUsername) was found"
        addLog "User $localHostUsername was found! Skipping user creation."
    }
}
function tcLocalGroupStandardsValidation {
    #$ErrorActionPreference = 'Stop' #Commenting this out for now I dont want to exit the script on error
    $VerbosePreference = 'Continue'
    #Declare LocalGroup Object
    $ObjLocalGroup = $null

    try {
        Write-Verbose "Searching for $($LocalHostGroup) in LocalGroup DataBase" | Tee-Object @teeProcess
        $ObjLocalGroup = Get-LocalGroup $LocalHostGroup
        Write-Verbose "Group: $($LocalHostGroup) was found" | Tee-Object @teeProcess
        Write-Verbose "Skipping Creation Process" | Tee-Object @teeProcess
    }
    catch [Microsoft.PowerShell.Commands.GroupNotFoundException] {
        "Group $($LocalHostGroup) was not found" | Write-Warning | Tee-Object @teeProcess
    }
    catch {
        "An unspecifed error occured" | Write-Error | Tee-Object @teeProcess
        return
    }

    #Create the group if it was not found (Example)
    if (!$ObjLocalGroup) {
        Write-Verbose "Creating Group $LocalHostGroup" | Tee-Object @teeProcess
        New-LocalGroup -Name $localHostGroup | Tee-Object @teeProcess
    }
}



addLog "Beginning usercreation subscript."
###
##
#Prompt user for username/password input then save a secure credential into the ps window
if ($LocalHostUsername = '0') {
    addLog "Type in username for local user." 
    $LocalHostUsername = Read-Host 
    write-output "New user name is $LocalHostUsername" 
}
else {
    Write-Output "Username has a non-zero value of $localhostusername continuing to next step." | Tee-Object @teeProcess
}
<#  #I wanna try to use a PSCred instead of using this input. I don't like it.
if ($LocalHostPassword = '0') {
    write-output "Type in password for user account $LocalHostUsername" | Tee-Object @teeProcess
    $LocalHostPassword = read-host -AsSecureString
    write-output "Converted password to securestring" | Tee-Object @teeProcess
}
else {
    Write-Output "Password has a non-zero value of $localhostpassword continuing to next step." | Tee-Object @teeProcess
}
#>

#$localHostPassword = Get-Credential -UserName $localHostUsername -Message "Type in Password for $localHostUsername"

$UserAdd 		= @{
	Name		= $LocalHostUsername
	#Password	= $localHostPassword
	Fullname	= 'TC Octopus Account'
	Description 	= 'Service Account for SPLA Auditing Software'
	AccountNeverExpires = 1
	PasswordNeverExpires = 1
}


#Create the user using the parameters input just now
userCreate
#Create the Group TulsaConnect and assign the user to it.
tcLocalGroupStandardsValidation

addLog "Adding $localHostUsername to $localHostGroup"
Add-LocalGroupMember -Group $localHostGroup -Member $LocalHostUsername | Tee-Object @teeProcess
addLog "Removing $localHostUsername from primary user group"
remove-localgroupmember -group 'Users' -Member $localHostUsername  | Tee-Object @teeProcess
addLog "Adding $localHostUsername to Administrators group"
Add-LocalGroupMember -Group 'Administrators' -Member $LocalHostUsername | Tee-Object @teeProcess


<#   #Offer to open user control panel
addLog "Would you like to Open the user Computer Management Local Users and Groups? `n (Y/N) [Leave Black and Press enter to exit without deleting]" | Tee-Object @teeProcess
$openCompMgmtQ = read-host
addLog "Selection $openCompMgmtQ"
if (($openCompMgmtQ = 'Y') -or ($openCompMgmtQ = 'y')) {
    lusrmgr.msc
    Start-Sleep 1
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
    addLog "For TroubleShooting I've opened Local Users and Group from Computer management."
}
else {
    addLog "User declined users and groups window."
}
#>

#Show all details of new User including group membership

#Show all details of current User includeing group membership

addLog "###### Opening User Panel to verify user info ############"
addLog "###### AddUserStandalone Complete! ################### `n##### `n#### `n### `n## `n# `n "

          

#This block is for Troubleshooting purposes.
##Insert <#BLOCK NextLine#>

#Before closing offer to delete this user we just created for testing purposes.
<#
Add-Content -path $processLog -Value "###### Troubleshooting section of Program ############"
Add-Content -path $processLog -Value "###### `n `n ################### `n `n##### `n#### `n### `n## `n# `n "
write-output "Would you like to delete the user you just created? `n (Y/N) [Leave Black and Press enter to exit without deleting]" | Tee-Object @teeProcess
$deleteUserQ = read-host
addLog "Selection $deleteUserQ"
if (($deleteUserQ = 'Y') -or ($deleteUserQ = 'y')) {
    Remove-LocalUser -Name $localhostusername
    addLog "For TroubleShooting This Test user was deleted $localhostusername"
}
else {
    addLog "For TroubleShooting This Test user was *NOT* deleted $localhostusername"
}
write-output "Would you like to delete the group 'TulsaConnect' you just created? `n (Y/N) [Leave Black and Press enter to exit without deleting]" | Tee-Object @teeProcess
$deleteGroupQ = read-host
addLog "Selection $deleteGroupQ"
if (($deleteGroupQ = 'Y') -or ($deleteGroupQ = 'y')) {
    Remove-LocalGroup -name 'TulsaConnect'
    addLog "For troubleShooting this group was deleted $localhostgroup"
}
else {
    addLog "For TroubleShooting This Test group was *NOT* deleted $localhostgroup"
}
Add-Content -path $processLog -Value "######  ############`n"
Add-Content -path $processLog -Value "###### TroubleshootingComplete! ################### `n##### `n#### `n### `n## `n# `n "

<# 
NEXT STEP IS TO ADD FUNCTIONALITY FOR ERROR CODES ABOVE AND ONLY EXECUTE WHAT NEEDS TO BE EXECUTED.
LOG WHAT THE CURRENT SETTINGS ARE AS FAR AS WHAT USERS ARE PRESENT AND WHAT ARE THEIR GROUP MEMBERSHIPS


THEN ADD FUNCTIONALITY FOR ADDING ACTIVE DIRECTORY USERS IF THEY ARE PRESENT
#>
addLog "Usercreation subscript has completed. `n `n `n Fin"
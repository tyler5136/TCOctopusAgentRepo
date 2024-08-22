function LogMe {
	Tee-Object -filepath $processLog -Append
}
function addLog {
	param (
		$contentParameter
	)
    Write-Output "$(Get-Date) $contentParameter"
	add-content -Path $processLog -Value "$(Get-Date) - Console: $contentParameter"
}
function errorLog {
	param (
		$contentParameter
	)
    Write-Output "$(Get-Date) $contentParameter"
	add-content -Path $processLog -Value "$(Get-Date) - Console: $contentParameter"
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

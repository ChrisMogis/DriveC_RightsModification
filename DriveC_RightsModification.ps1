<#
.DESCRIPTION
This script allows you to revoke user rights in C: 
and thus prevent creating folders or files anywhere on the hard disk system.

.NOTES
  Version:        1.0
  Author:         Christopher Mogis
  Creation Date:  07/11/2023
 
#>

#Script Parameters
Param(
[Parameter(Mandatory=$true)]
[ValidateSet("Remove", "Add")]
[String[]]
$Param
)

#Variables
$Date = Get-Date

#Log Folder
Function CreateLogsFolder
  {
    If(!(Test-Path "C:\CCMTune\Logs\"))
    {
    Write-Host "$($Date) : Create logs folder C:\CCMTune\Logs"
    New-Item -Force -Path "C:\CCMTune\Logs\" -ItemType Directory
		}
		else 
		{ 
    Write-Host "$($Date) : The folder C:\CCMTune\Logs\ already exists !"
    }
  }

#Create Log Folder
    CreateLogsFolder

#Remove right
If ($Param -eq "Remove")
  {
  #Righs modification
  $Logs = "C:\CCMTune\Logs\CCMTRemoveRightsOnC.log"
  Remove-Item -Path "C:\CCMTune\Logs\CCMTAddRightsOnC.log" -Force
  Write-Output "$($Date) : Remove user rights on C:" | Tee-Object -FilePath $Logs -Append
  Invoke-Expression -Command "icacls C:\ /remove:g *S-1-5-11" | Tee-Object -FilePath $Logs -Append
  }

#Add right
If ($Param -eq "Add")
  {
  #Righs modification
  $Logs = "C:\CCMTune\Logs\CCMTAddRightsOnC.log"
  Remove-Item -Path "C:\CCMTune\Logs\CCMTRemoveRightsOnC.log" -Force
  Write-Output "$($Date) : Add user rights on C:" | Tee-Object -FilePath $Logs -Append
  Invoke-Expression -Command "icacls C:\ /grant *S-1-5-11:'(AD)'" | Tee-Object -FilePath $Logs -Append
  Invoke-Expression -Command "icacls C:\ /grant *S-1-5-11:'(OI)(CI)(IO)M'" | Tee-Object -FilePath $Logs -Append
  }

##### UCLan Drive Tool 2 Installer #####
#
# Contact: MB

# Set the installation directory
$installationDir = "$env:SystemDrive\uclan\UDT2"

# Create the directory if it does not exist
if(-not(Test-Path $installationDir)){
    mkdir $installationDir -Force
}

# Install the files
cp "$PSSCriptRoot\bin\*" $installationDir

# Create Shortcut
$shortcutLocation = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\UCLan Drive Tool.lnk"
$wscriptShell = New-Object -ComObject WScript.Shell
$shortcutObj = $wscriptShell.CreateShortcut($shortcutLocation)
$targetPath = "powershell.exe"
$shortcutObj.TargetPath = $targetPath
$shortcutObj.Arguments = "-executionpolicy bypass -file $installationDir\main.ps1"
$shortcutObj.IconLocation = "$installationDir\icon.ico"
$shortcutObj.WindowStyle = 7
$shortcutObj.Save()

# Configure VBS Launcher
$vbsFile = Get-Content "$installationDir\silent.vbs"
$vbsCommand = """powershell.exe -executionpolicy bypass -file $installationDir\mainS.ps1"""
$vbsFile[1] = "command = $vbsCommand"
Set-Content "$installationDir\silent.vbs" $vbsFile -Force

# Allow windows FS to catch up 
Start-Sleep 3

# Set Scheduled Task
[xml]$tsXML = Get-Content "$PSScriptRoot\UDTSilent.xml"
$tsXML.Task.Actions.Exec.Arguments = "$installationDir\silent.vbs"
$tsXML.Save("$installationDir\ts.xml")
schtasks.exe /Create /XML "$installationDir\ts.xml" /tn "UDTSilent"
rm "$installationDir\ts.xml" -Force
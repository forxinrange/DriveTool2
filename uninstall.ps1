## UCLan Drive Tool 2.0 Uninstaller ##
#
#
# Contact: MB

$installationDir = "$env:SystemDrive\uclan\UDT2"
$shortcutLocation = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\UCLan Drive Tool.lnk"

# Uninstall Files
if(Test-Path $installationDir){
    rm $installationDir -Recurse -Force
}

# Remove Shortcut
if(Test-Path $shortcutLocation){
    rm $shortcutLocation -Force
}

# Remove task
schtasks.exe /Delete /TN "UDTSilent" /F
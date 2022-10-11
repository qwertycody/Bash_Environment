$FileOrFolderPath = ""

$CMD_PATH = "C:\\WINDOWS\\System32\\cmd.exe"

IF((Test-Path -Path $FileOrFolderPath) -eq $false) {
    Write-Warning "File or directory does not exist."       
}
Else {
    Start-Process -FilePath $CMD_PATH -NoNewWindow -ArgumentList "/trustlevel:0x20000","cmd.exe /C openfiles /query /fo table | find /I ""$FileOrFolderPath"""
}
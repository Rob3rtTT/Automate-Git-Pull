#variables
$shebang='!#/bin/bash'
$move_to_folder='ENTER FOLDER PATH HERE'
$pull='git pull origin develop'
$git_pull_script_path="C:\users\$env:UserName\git_pull.sh"
$git_bash_location="C:\Program Files\Git\git-bash.exe"

$Task_Action = New-ScheduledTaskAction -Execute $git_pull_script_path
$Task_Principal = New-ScheduledTaskPrincipal -UserId $env:UserName
$Task_Settings = New-ScheduledTaskSettingsSet -Hidden
$Task_Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:UserName

#create bash script file and execute it first time

if (!(Test-Path $git_pull_script_path)){
    New-Item -Path $git_pull_script_path
    $shebang, $move_to_folder, $pull | Out-File -FilePath $git_pull_script_path
    Start $git_bash_location $git_pull_script_path -Wait
}
else{
    echo 'Script already exists'
}

#add script file to task scheduler to run every time the computer is started
Register-ScheduledTask `
    -TaskName "Automate Git Pull" `
    -Action $Task_Action `
    -Principal $Task_Principal `
    -Trigger $Task_Trigger `
    -Settings $Task_Settings `
    -Force
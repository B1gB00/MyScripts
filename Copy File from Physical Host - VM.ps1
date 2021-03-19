$VMName = "FILEZ2"
$Source = "C:\ClusterStorage\Volume1\MyScripts\RemoveGhosts.ps1"
$Destination = "C:\MyScripts\RemoveGhosts.ps1"
# Used to copy file from Physical Host -> VM
Copy-VMFile -Name $VMName -SourcePath $Source -DestinationPath $Destination -CreateFullPath -FileSource Host -Force
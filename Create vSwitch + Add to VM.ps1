$vSwitch = "HeartBeet"
$VMName = "NLB-IIS1"
New-VMSwitch -Name $vSwitch -SwitchType Private
Add-VMNetworkAdapter -VMName $VMName -Name $vSwitch -SwitchName $vSwitch
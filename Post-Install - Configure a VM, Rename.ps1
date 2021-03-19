$IP = "192.168.50.10"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "192.168.50.254"
$Dns = "192.168.50.1"
$IPType = "IPv4"
$Rename_NetAdapter1 = "LM"
$Rename_NetAdapter2 = "iSCSI"
$Rename_NetAdapter3 = "HB"
$Rename_NetAdapter4 = "LAN"
$Rename_Admin = "_ITAdmin"
$ComputerName = "SAN"

# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter -Name "Ethernet 4"
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway
# Configure the DNS client server IP addresses
$adapter | Set-DnsClientServerAddress -ServerAddresses $Dns
# Turn on "ICMP - ECHOv4"
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
# Rename the Network Adapter
Rename-NetAdapter -Name "Ethernet" -NewName $Rename_NetAdapter1
# Rename the Network Adapter (2)
Rename-NetAdapter -Name "Ethernet 2" -NewName $Rename_NetAdapter2
# Rename the Network Adapter (2)
Rename-NetAdapter -Name "Ethernet 3" -NewName $Rename_NetAdapter2
# Rename the Network Adapter (2)
Rename-NetAdapter -Name "Ethernet 4" -NewName $Rename_NetAdapter2
# Rename the local Admin Account
Rename-LocalUser -Name "Administrator" -NewName $Rename_Admin
# Rename the local Computer
Rename-Computer -NewName $ComputerName

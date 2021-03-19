$IP = "192.168.50.14"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "192.168.50.254"
$Dns = "192.168.50.1"
$IPType = "IPv4"
$Rename_NetAdapter1 = "ExtHB"
$Rename_NetAdapter2 = "ExtLAN"
$Rename_Admin = "_ITAdmin"
$Domain = "CAP.tsp"
$OUPath = "OU=FileServers,OU=CAPServers,DC=CAP,DC=tsp"

# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter -Name "Ethernet 2"
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
# Rename the Network Adapter2
Rename-NetAdapter -Name "Ethernet 2" -NewName $Rename_NetAdapter2
# Rename the local Admin Account
Rename-LocalUser -Name "Administrator" -NewName $Rename_Admin
# Get credential (Use base Domain username (I.e. _ITAdmin / rkeown)
$cred = Get-Credential rkeown
Add-Computer -DomainName $Domain -Credential $cred -OUPath $OUPath
# Rename the computer with credential (because we are in the domain)
$Computer = Get-WmiObject Win32_ComputerSystem
$r = $Computer.Rename("FILEZ2", $cred.GetNetworkCredential().Password, $cred.Username)
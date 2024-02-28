

# Check if AD module is installed 

if (-not (Get-Module -Name ActiveDirectory -ListAvailable)) {
    # If not installed, install RSAT-AD-Powershell feature
    Write-Host "Active Directory module is not installed. Installing RSAT-AD-Powershell..."
    Install-WindowsFeature -Name RSAT-AD-Powershell
} else {
    Write-Host "Active Directory module is already installed."
}
# import the module 
Import-Module ActiveDirectory

# computer name 
Rename-Computer  DC

# interface index 
$inet_index = Get-NetIPInterface | Where-Object {$_.InterfaceAlias -match 'Loopback*'} | Select-Object -First 1 -ExpandProperty ifIndex 
# Loopback address
$loopback = Get-NetIPAddress | Where-Object {$_.IPAddress -match '127*'} | Select-Object -ExpandProperty IPAddress

# set dns 
Set-DnsClientServerAddress -InterfaceIndex $inet_index -ServerAddresses $loopback

# install AD DS 
Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Host "AD DS feature will be installed right now and the system will be rebooted."
Restart-Computer -Force

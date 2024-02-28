

# install certificate service 
Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools


# turn on network discovery 
Set-NetIPInterface -NeighborDiscoverySupported Yes

# create SMB Share 
New-SmbShare -Name 'Treasure' -Path 'C:\' -FullAccess 'sudo\Domain Users' 

# create ou 
New-ADOrganizationalUnit -Name Lab -Path "DC=sudo,DC=local"



# Search for the "employees.txt" file in the specified path
$filePath = Get-ChildItem -Filter "employees.txt" -Recurse -Path "C:\" -ErrorAction Ignore | Select-Object -ExpandProperty FullName -First 1


# Check if the file exists
if ($filePath) {
    # Import CSV data from the file
    $ADUsers = Import-Csv -Path $filePath
    Write-Host "File found and CSV data imported successfully."
} else {
    Write-Host "File 'employees.txt' not found."
}


# Define UPN
$UPN = "sudo.local"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {
    try {
        # Define the parameters using a hashtable
        $UserParams = @{
            SamAccountName        = $User.Name
            UserPrincipalName     = "$($User.Name)@$UPN"
            Name                  = "$($User.Name)"
            Enabled               = $True
            PasswordNeverExpires  = $true
            DisplayName           = "$($User.Name)"
            Path                  = $User.ou #This field refers to the OU the user account is to be created in
            AccountPassword       = (ConvertTo-secureString $User.Password -AsPlainText -Force)
            ChangePasswordAtLogon = $false

        }

        # Check to see if the user already exists in AD
        if (Get-ADUser -Filter "SamAccountName -eq '$($User.Name)'") {

            # Give a warning if user exists
            Write-Host "A user with username $($User.Name) already exists in Active Directory." -ForegroundColor Yellow
        }
        else {
            # User does not exist then proceed to create the new user account
            # Account will be created in the OU provided by the $User.ou variable read from the CSV file
            New-ADUser @UserParams

            # If user is created, show message.
            Write-Host "The user $($User.Name) is created." -ForegroundColor Green
        }
    }
    catch {
        # Handle any errors that occur during account creation
        Write-Host "Failed to create user $($User.Name) " -ForegroundColor Red
    }
}

# Security Groups 
$groups = @("Administrators", "Domain Admins", "Enterprise Admins", "Schema Admins", "Group Policy Creator Owners")

# List of users to be added to the groups
$users = @("Manager", "SQL SERVICE")

# Loop through each group and add users
foreach ($group in $groups) {
    foreach ($user in $users) {
        try {
            Add-ADGroupMember -Identity $group -Members $user
            Write-Host "Added user $user to group $group"
        } catch {
            Write-Host "Failed to add user $user to group $group"
        }
    }
}

# add the administrator to Lab ou
Get-ADUser -Identity Administrator | Select-Object -ExpandProperty DistinguishedName | Move-ADObject -TargetPath "OU=lab,DC=sudo,DC=local"

# reversable encryption 
Set-ADUser -Identity 'khalid' -AllowReversiblePasswordEncryption 1
# Service Accounts 
Set-ADUser -Identity "SQL SERVICE" -ServicePrincipalNames @{Add = "MSSQL/$(HOSTNAME.EXE).sudo.local"}



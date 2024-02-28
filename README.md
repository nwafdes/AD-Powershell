# AD-Powershell

This repository contains a PowerShell script for configuring Active Directory settings with a focus on creating vulnerable configurations for educational purposes.

## Functionality

The script includes the following functionalities:
- Creation of users with weak passwords
- Creation of service accounts
- Configuration of users with reversible password encryption
- Planned ACL/ACE and DSync attacks (work in progress)
- Creation of an SMB share with full access (LNK Attack)

## Prerequisites

Before running the script, ensure you meet the following prerequisites:

1. **PowerShell Execution Policy**: Ensure PowerShell is running with Administrator privileges.
2. **Active Directory Domain Services (ADDS)**: Install ADDS by executing `Install_AD.ps1`.
3. **Create Forest/Domain**: Run the following command to create the Forest/domain:
   ```powershell
   Install-ADDSForest -DomainName "sudo.local" -SafeModeAdministratorPassword (ConvertTo-SecureString "P@$$w0rd" -AsPlainText -Force) -InstallDns -Force
4. **Download Employees file**: Make sure you downloaded "Employees.txt"
4. **Run The Script**: Now you can run the script `script.ps1`


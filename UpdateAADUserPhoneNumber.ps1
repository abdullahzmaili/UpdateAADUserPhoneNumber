## UpdateAADUserPhoneNumber

# Connect to MSOnline
Connect-MsolService

# Import CSV sheet that contains the list Of users
$CSVPath = Read-Host -Prompt "Please enter Group ID"
$CSVrecords = Import-Csv $CSV -Delimiter ";"

# Create arrays for skipped and failed users
$SkippedUsers = @()
$FailedUsers = @()

foreach ($CSVrecord in $CSVrecords) {
    $upn = $CSVrecord.UserPrincipalName
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$upn'"  
    if ($user) {
        try{
        $user | Set-MsolUser -PhoneNumber $CSVrecord.PhoneNumber
        } catch {
        $FailedUsers += $upn
        Write-Warning "$upn user found, but FAILED to update."
        }
    }
    else {
        Write-Warning "$upn not found, skipped"
        $SkippedUsers += $upn
    }
}

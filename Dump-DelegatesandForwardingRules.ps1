#Import the right module to talk with AAD
import-module MSOnline

######### Prepare Office 365 ##########

$File = $ScriptFolder + "\adminpwd"

[Byte[]] $key = (1..16) 

$Office365Username = "admin@adengroup.onmicrosoft.com"
$SecureOffice365Password = Get-Content $file | ConvertTo-SecureString -Key $Key 
$Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365Password  

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Office365Credentials -Authentication Basic -AllowRedirection
Import-PSSession $exchangeSession -AllowClobber | Out-Null

Connect-MsolService -Credential $Office365Credentials

$allUsers = @()
$AllUsers = Get-MsolUser -All -EnabledFilter EnabledOnly | select ObjectID, UserPrincipalName, FirstName, LastName, StrongAuthenticationRequirements, StsRefreshTokensValidFrom, StrongPasswordRequired, LastPasswordChangeTimestamp | Where-Object {($_.UserPrincipalName -notlike "*#EXT#*")}

$UserInboxRules = @()
$UserDelegates = @()

foreach ($User in $allUsers)
{
    Write-Host "Checking inbox rules and delegates for user: " $User.UserPrincipalName;
    $UserInboxRules += Get-InboxRule -Mailbox $User.UserPrincipalname | Select Name, Description, Enabled, Priority, ForwardTo, ForwardAsAttachmentTo, RedirectTo, DeleteMessage | Where-Object {($_.ForwardTo -ne $null) -or ($_.ForwardAsAttachmentTo -ne $null) -or ($_.RedirectsTo -ne $null)}
    $UserDelegates += Get-MailboxPermission -Identity $User.UserPrincipalName | Where-Object {($_.IsInherited -ne "True") -and ($_.User -notlike "*SELF*")}
}

$SMTPForwarding = Get-Mailbox -ResultSize Unlimited | select DisplayName,ForwardingAddress,ForwardingSMTPAddress,DeliverToMailboxandForward | where {$_.ForwardingSMTPAddress -ne $null}

$UserInboxRules | Export-Csv MailForwardingRulesToExternalDomains.csv
$UserDelegates | Export-Csv MailboxDelegatePermissions.csv
$SMTPForwarding | Export-Csv Mailboxsmtpforwarding.csv
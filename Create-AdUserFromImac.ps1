$AdminUrl = "https://adengroup-admin.sharepoint.com"
$UserName = "admin@adengroup.onmicrosoft.com"
$Password = "pe76XGL#"
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword
$spSite = "https://adengroup.sharepoint.com/sites/flowtest"
$spList = "IMAC-PR"
$ouPath = "OU=IMAC,OU=ADEN-Users,DC=CHOADEN,DC=COM"
#$ouPath = "OU=ADEN-Users,DC=CHOADEN,DC=COM"
$today = Get-Date


$camlQuery = "<View><Query><Where><IsNull><FieldRef Name='Email'></FieldRef></IsNull></Where></Query></View>"

#Install-Module SharePointPnPPowerShellOnline
Import-Module SharePointPnPPowerShellOnline

Connect-PnPOnline -Url $spSite -Credential $Credentials
$newUsers = (Get-PnPListItem -list $spList -Query $camlQuery).FieldValues

foreach ($item in $newUsers)
{
    $id = $item.ID
    $initialAdUserName = $item.FirstName + "." + $item.UserName
    $numberedAdUserName = $initialAdUserName
    $count = 1
    while ((get-aduser $numberedAdUserName) -ne $Null)
    {
        $numberedAdUserName = $initialAdUserName + $count++
    }
    $email = $numberedAdUserName + "@adenservices.com"
    Set-PnPListItem -List $spList -Identity $id -Values @{"Email" = $email}
    New-ADUser $numberedAdUserName `
	    -SamAccountName $numberedAdUserName `
	    -userprincipalname $email `
	    -Surname $FirstName `
	    -GivenName $UserName `
	    -DisplayName $numberedAdUserName `
	    -EmailAddress $email `
	    -AccountPassword (ConvertTo-SecureString "Aden@123" -AsPlainText -Force) `
        -Path $ouPath `
	    -enabled $true -AccountExpirationDate $today.AddDays(3)
    $numberedAdUserName + "`tAD user created."
}

break



$teamsGroups = Get-SPOObject -Username $UserName -password $SecurePassword -Url "https://adengroup.sharepoint.com/sites/flowtest" -Object "web/lists/getbytitle('ApprovalTest')/items" |  select Title, Teampurpose, Status, Department, owner, members
$teamsGroups = Get-SPOObject -Username $UserName -password $SecurePassword -Url "https://adengroup.sharepoint.com/sites/flowtest" -Object "web/lists/getbytitle('ApprovalTest')/items" |  select *
$teamsGroups | ogv
Get-SPOObject -Username $UserName -password $SecurePassword -Url "https://adengroup.sharepoint.com/sites/flowtest" -Object "web/lists/getbytitle('ApprovalTest')/items" | select * | ogv
$teamsGroups | ft
$teamsGroups | where {$_.status -eq "Approved"}
$group1.Title

New-UnifiedGroup –DisplayName SUP-ALL –Alias SUP-ALL -Owner nolwenn.ji@adenservices.com -AccessType Private -Members billy.zhou@adenservices.com,mike.yang@adenservices.com
Add-UnifiedGroupLinks –Identity SUP-ALL –LinkType Member –Links billy.zhou@adenserices.com

New-UnifiedGroup –DisplayName EDU-ALL –Alias EDU-ALL -AccessType Private
Add-UnifiedGroupLink –Identity auto-test –LinkType Member –Links Farren@ThatLazyAdmin.com,Renjith@ThatlazyAdmin.com

Get-SPOObject -Username $UserName -password $SecurePassword -Url "https://adengroup.sharepoint.com/sites/flowtest" -Object "web/siteusers" | ogv
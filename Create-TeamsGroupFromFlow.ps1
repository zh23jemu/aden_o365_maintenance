Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$AdminUrl = "https://adengroup-admin.sharepoint.com"
$UserName = "admin@adengroup.onmicrosoft.com"
$Password = "pe76XGL#"
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword
$spSite = "https://adengroup.sharepoint.com/sites/flowtest"
$spSiteList = "web/lists/getbytitle('ApprovalTest')/items"

#Retrieve all site collection infos
Connect-SPOService -Url $AdminUrl -Credential $Credentials
Import-Module D:\PSModules\GetSPOObjects.psm1

Get-SPOObject -Url $AdminUrl  -Object $spSiteList | select UserName, FirstName, CompanyName, Department, LineManager, BoardDate, CostCenter | ft
Get-SPOObject -Username $UserName -password $SecurePassword -Url $AdminUrl  -Object $spSiteList | select UserName, FirstName, CompanyName, Department, LineManager, BoardDate, CostCenter | ft

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
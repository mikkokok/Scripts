# Print Azure management groups in treeview
function GetGroupProperties ($group) {
    return Get-AzureRmManagementGroup -GroupName $group.Name
}
function GetPropertiesForGroups ($groups) {
    $tempGroup = @()
    foreach ($group in $groups) {
        $tempGroup += GetGroupProperties -group $group
    }
    Write-Host "Properties fetched"
    return $tempGroup
}
function GetSubGroups ($AllGroups, $ParentGroup, $level) {
    $tempGroups = $AllGroups | Where-Object {$_.ParentName -eq $ParentGroup.Name}
    $level = $level + "--"
    foreach ($group in $tempGroups) {
        $baseString = $level.replace("-", " ") + "|--"
        Write-Host "$($baseString) $($group.DisplayName)"
        GetSubGroups -AllGroups $AllGroups -ParentGroup $group -level $level
    }
}
$groups = GetPropertiesForGroups -groups (Get-AzureRmManagementGroup)
$tenantRoot = $groups | Where-Object {$_.DisplayName -eq "Tenant Root Group"}
Write-Host "$($tenantRoot.DisplayName)"
GetSubGroups -AllGroups $groups -ParentGroup $tenantRoot -level "-"
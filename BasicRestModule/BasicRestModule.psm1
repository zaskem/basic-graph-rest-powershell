<# 
    Nothing fancy about this module; use as a starter point for working with Graph API.
#>
function Get-BearerToken {
    param(
        [string] $tenantId,
        [string] $clientId,
        [string] $clientSecret
    )
    $invokeRestMethodSplat = @{
        Uri    = 'https://login.microsoftonline.com/{0}/oauth2/v2.0/token' -f $tenantId
        Method = 'POST'
        Headers = @{
            "Content-Type"        = "application/x-www-form-urlencoded"
        }
        Body   = @{
            client_id             = $clientId
            client_secret         = $clientSecret
            scope                 = 'https://graph.microsoft.com/.default'
            grant_type            = 'client_credentials'
        }
    }
    $access_token = Invoke-RestMethod @invokeRestMethodSplat
    $access_token.access_token
}

function Get-AllDevicesAllData {
    param(
        [string] $bearerToken
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod 'https://graph.microsoft.com/v1.0/devices' -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-AllDevicesSelectData {
    param(
        [string] $bearerToken
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod 'https://graph.microsoft.com/v1.0/devices?$select=id,deviceId,displayName,manufacturer,model' -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-AllSecurityGroups {
    param(
        [string] $bearerToken
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod 'https://graph.microsoft.com/v1.0/groups?$select=id,displayName,securityEnabled,groupTypes,createdDateTime&$filter=(securityEnabled eq true)' -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-GroupMembers {
    param(
        [string] $bearerToken,
        [string] $groupId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/groups/$groupId/transitiveMembers?`$select=id,displayName,deviceId" -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-AllUsersSelectData {
    param(
        [string] $bearerToken
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod 'https://graph.microsoft.com/v1.0/users?$select=id,displayName,mail,userPrincipalName' -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-DeviceGroupMemberships {
    param(
        [string] $bearerToken,
        [string] $deviceId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/devices/$deviceId/memberOf/$/microsoft.graph.group?`$select=displayName" -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-DevicesOwnedByUser {
    param(
        [string] $bearerToken,
        [string] $userId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/users/$userId/ownedDevices?`$select=displayName" -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Get-DeviceDetails {
    param(
        [string] $bearerToken,
        [string] $deviceId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/devices/$deviceId" -Method 'GET' -Headers $headers | ConvertTo-Json
}

function Update-DeviceDetails {
    param(
        [string] $bearerToken,
        [string] $deviceId,
        [string] $updateJson
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
        "Content-Type"  = "application/json"
    }
    $body = "$updateJson"
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/devices/$deviceId" -Method 'PATCH' -Headers $headers -Body $body | ConvertTo-Json
}

function Get-DeviceBitlockerRecoveryKey {
    param(
        [string] $bearerToken,
        [string] $deviceId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    $keyResponse = Invoke-RestMethod "https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys?`$filter=deviceId eq '$deviceId'" -Method 'GET' -Headers $headers

    $keyResponse.value | Foreach-Object {
        Get-BLRecoveryKey -bearerToken $bearerToken -rKeyId $_.id | ConvertTo-Json
    }
}

function Get-BLRecoveryKey {
    param(
        [string] $bearerToken,
        [string] $rKeyId
    )
    $headers = @{
        "Authorization" = "Bearer $bearerToken"
    }
    $keyResponse = Invoke-RestMethod "https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys/$rKeyId/?`$select=key" -Method 'GET' -Headers $headers -UserAgent 'Dsreg/10.0'
    $keyResponse.key
}

Export-ModuleMember -Function Get-BearerToken
Export-ModuleMember -Function Get-AllDevicesAllData
Export-ModuleMember -Function Get-AllDevicesSelectData
Export-ModuleMember -Function Get-AllSecurityGroups
Export-ModuleMember -Function Get-GroupMembers
Export-ModuleMember -Function Get-AllUsersSelectData
Export-ModuleMember -Function Get-DeviceGroupMemberships
Export-ModuleMember -Function Get-DevicesOwnedByUser
Export-ModuleMember -Function Get-DeviceDetails
Export-ModuleMember -Function Update-DeviceDetails
Export-ModuleMember -Function Get-DeviceBitlockerRecoveryKey

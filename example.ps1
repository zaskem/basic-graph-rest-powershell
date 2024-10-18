# Include some stuff
. ".\RestSecrets.ps1"
Import-Module RestModule

# Set example runtime variables
$runtimeGroupId = 'groupIdStringGoesHere'
$runtimeUserId = 'userIdStringGoesHere'
$runtimeDeviceId = 'deviceObjectIdStringGoesHere'
$runtimeUpdateDeviceId = 'deviceObjectIdStringGoesHere'
$deviceUpdateData = '{
  "extensionAttributes": {
      "extensionAttribute1": "Recycled-Object"
  }
}'
$runtimeBitlockerDeviceId = 'deviceIdStringGoesHere'

# Generate a Bearer Token
Write-Host "Get a Bearer Token..."
$bearerToken = Get-BearerToken -tenantId $tenantId -clientId $clientId -clientSecret $clientSecret

# Get All Properties Device Data
Get-AllDevicesAllData -bearerToken $bearerToken

# Get Selected Properties Device Data
Get-AllDevicesSelectData -bearerToken $bearerToken

# Get List of All Security Group
Get-AllSecurityGroups -bearerToken $bearerToken

# Get All Members of a Group
Get-GroupMembers -bearerToken $bearerToken -groupId $runtimeGroupId

# Get Selected Properties User Data
Get-AllUsersSelectData -bearerToken $bearerToken

# Get Group Memberships for a Device
Get-DeviceGroupMemberships -bearerToken $bearerToken -deviceId $runtimeDeviceId

# Get List of Devices Owned by User
Get-DevicesOwnedByUser -bearerToken $bearerToken -userId $runtimeUserId

# Show, Update, Show All Device Properties Before/After Updating Device
Get-DeviceDetails -bearerToken $bearerToken -deviceId $runtimeUpdateDeviceId
Update-DeviceDetails -bearerToken $bearerToken -deviceId $runtimeUpdateDeviceId -updateJson $deviceUpdateData
Get-DeviceDetails -bearerToken $bearerToken -deviceId $runtimeUpdateDeviceId

# Get a Device's Bitlocker Recovery Key
Get-DeviceBitlockerRecoveryKey -bearerToken $bearerToken -deviceId $runtimeBitlockerDeviceId

$azureRMUri = "https://management.azure.com/subscriptions/"
$providerUri = "/providers/microsoft.insights/logprofiles/default?api-version=2016-03-01"

$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzSubscription -SubscriptionId $subscriptionId).TenantId
$currentContext = Get-AzContext
$accessToken = $currentContext.TokenCache.ReadItems() | Where-Object { $_.TenantId -eq $tenantId } | Sort-Object -Property ExpiresOn -Descending | Select-Object -First 1

if (!$accessToken) {
    Write-Host "No accesstoken found. Exiting"
    exit
}

$uri = $azureRMUri + $subscriptionId + $providerUri
$params = @{
    ContentType = 'application/json'
    Headers = @{
        "Authorization" = "Bearer " + $accessToken.AccessToken
        }
    Method = 'GET'
    URI = $uri
}
Invoke-RestMethod @params | ConvertTo-Json

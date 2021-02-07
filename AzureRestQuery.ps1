$azureRMUri = "https://management.azure.com/subscriptions/"
$providerUri = "/providers/microsoft.insights/logprofiles/default?api-version=2016-03-01"

$subscriptionId = (Get-AzContext).Subscription.Id

$currentContext = Get-AzContext
$accessToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate(
    $AzContext.'Account',
    $AzContext.'Environment',
    $AzContext.'Tenant'.'Id',
    $null,
    [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never,
    $null,
    'https://management.azure.com/'
).AccessToken

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

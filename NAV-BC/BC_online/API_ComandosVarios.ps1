
# Crear entorno
$tenantName = 'terroir.onmicrosoft.com'
$ctx = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext]::new("https://login.windows.net/$tenantName")
   $redirectUri = New-Object -TypeName System.Uri -ArgumentList <Redirect URL>
   $platformParameters = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters -ArgumentList ([Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always)
   $token = $ctx.AcquireTokenAsync("https://api.businesscentral.dynamics.com", <Application ID>, $redirectUri, $platformParameters).GetAwaiter().GetResult().AccessToken


# Nueva empresa
POST https://api.businesscentral.dynamics.com/v2.0/{environment name}/api/microsoft/automation/v2.0/companies({companyId})/automationCompanies
Content-type: application/json
{
    "name": "CRONUS",
    "evaluationCompany": false,
    "displayName": "CRONUS",
    "businessProfileId": ""
}

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/appmanagement/app-management-overview

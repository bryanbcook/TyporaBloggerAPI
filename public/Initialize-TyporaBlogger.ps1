<#
.SYNOPSIS
Initialize the local system to use Typora + Blogger together

.DESCRIPTION
This prepares your system to use Typora + Blogger together by obtaining an authtoken that is authorized to communicate with blogger.

.PARAMETER clientId
Google API Client ID. A default value is provided, but you can provide your own if you don't trust me.

.PARAMETER clientSecret
Google API Client Secret. A default value is provided, but you can provide your own if you don't trust me.

.PARAMETER redirectUri
The oAuth redirect URL specifed in the Google API Consent Form. 

.PARAMETER code
This is the auth code provided

.EXAMPLE
Initiate a login flow with Google

    Initialize-TyporaBlogger

.EXAMPLE
After successfully logging in, copy the "code" query string parameter from the callback window

    Initialize-TyporaBlogger -code <auth-code>

#>
Function Initialize-TyporaBlogger 
{
    Param(

        [Parameter(HelpMessage="Google API ClientId")]
        [string]$clientId = "284606892422-ribvo7oodlbtd70e8onn8rg4hm58mluj.apps.googleusercontent.com",

        [Parameter(HelpMessage="Google API Client Secret")]
        [string]$clientSecret = "PUK0j9ig-GHcSByQao2i1aIa",

        [Parameter(HelpMessage="Redirect Uri specified in Google API Consent Form")]
        [string]$redirectUri = "http://localhost/oauth2callback",

        [Parameter(Mandatory=$false,HelpMessage="This is the code that you receive after an interactive login. If you don't have this value, leave it blank and we'll launch an interactive window. Copy the &code= value from the redirect url")]
        [string]$code
    )

    if ([System.String]::IsNullOrEmpty($code))
    {

        Write-Information "Let's get an auth-code."

        $url = "https://accounts.google.com/o/oauth2/auth?client_id=$clientId&scope=https://www.googleapis.com/auth/blogger&response_type=code&redirect_uri=$redirectUri&access_type=offline&approval_prompt=force"

        Start-Process $url
    }
    else {

        # trade the auth-code for an token that has a short-lived expiry
        $expiringToken = Get-GoogleAccessToken -clientId $clientId -clientSecret $clientSecret -redirectUri $redirectUri -code $code

        # use the refresh-token to get an updated access-token
        $token = Update-GoogleAccessToken -clientId $clientId -clientSecret $clientSecret -refreshToken $expiringToken.refresh_token

        # save the token in the credential_cache.json
        Set-CredentialCache -clientId $clientId -clientSecret $clientSecret -refreshToken $expiringToken -token $token
    }
}
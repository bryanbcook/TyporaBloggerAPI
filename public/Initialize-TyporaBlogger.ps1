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
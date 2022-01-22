
function Get-CredentialCache()
{
    (Get-Content $TyporaBloggerSession.CredentialCache) | ConvertFrom-Json
}

function Set-CredentialCache
{
    Param(
        [string]$clientId,
        [string]$clientSecret,
        [psobject]$refreshToken,
        [psobject]$token
    )

    $cache = @{
        client_id=$clientId
        client_secret=$clientSecret
        access_token=$token.access_token
        refresh_token=$refreshToken.refresh_token
    }

    $parentFolder = Split-Path $TyporaBloggerSession.CredentialCache -Parent

    if (-not (Test-Path $parentFolder)) {
        New-Item -ItemType Directory -Path $parentFolder -Force
    }

    Set-Content $TyporaBloggerSession.CredentialCache -Value ($cache | ConvertTo-Json) -Force

    # reset previously loaded auth tokens / force reload + validation for next api call
    $TyporaBloggerSession.AccessToken = $null
    $TyporaBloggerSession.RefreshToken = $null
}

function Update-CredentialCache
{
    param(
        [psobject]$token
    )

    Write-Verbose "Updating credential cache with: $token"

    $credentialCache = Get-CredentialCache
    $credentialCache.access_token = $token.access_token

    $TyporaBloggerSession.AccessToken = $token.access_token

    Set-Content $TyporaBloggerSession.CredentialCache -Value ($credentialCache | ConvertTo-Json)

}

function Assert-CredentialCache
{
    if ($null -eq $TyporaBloggerSession.AccessToken)
    {
        if (-not (Test-Path $TyporaBloggerSession.CredentialCache)) {
            throw "Cached credentials not found. Please call Initialize-TyporaBlogger"
        }

        $cache = Get-CredentialCache

        $TyporaBloggerSession.AccessToken  = $cache.access_token
        $TyporaBloggerSession.RefreshToken = $cache.refresh_token
    }
}
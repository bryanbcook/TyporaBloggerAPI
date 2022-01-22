function Get-AuthHeader()
{
    Assert-CredentialCache

    if (!(Test-GoogleAccessToken $TyporaBloggerSession.AccessToken))
    {
        $token = Update-GoogleAccessToken -refreshToken $TyporaBloggerSession.RefreshToken
        Update-CredentialCache -token $token
    }

    $header= @{ Authorization = "Bearer $($TyporaBloggerSession.AccessToken)"}

    $header
}

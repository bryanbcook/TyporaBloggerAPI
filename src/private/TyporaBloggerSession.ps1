Function Get-TyporaBloggerSession
{
  $session =   
    [ordered]@{
      CredentialCache = "$($env:USERPROFILE)\\.typorabloggerapi\\credentialcache.json"
      UserPreferences = "$($env:USERPROFILE)\\.typorabloggerapi\\settings.json"
      AccessToken = $null
      RefreshToken = $null
      PandocMarkdownFormat = "markdown+emoji"
      PandocHtmlFormat = "html"
      PandocTemplate = "$($env:USERPROFILE)\\.typorabloggerapi\\template.html"
      PandocAdditionalArgs = "--html-q-tags --ascii"
      BlogId = $null
    }

  if (Test-Path $session.UserPreferences)
  {
    $prefs = Get-Content $session.UserPreferences | ConvertFrom-Json
    $prefs.PSObject.Properties | ForEach-Object {
      $session[$_.Name] = $_.Value
    }
  }

  $session
}
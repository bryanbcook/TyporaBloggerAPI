Function Set-TyporaBloggerConfig
{
  [CmdletBinding()]
  Param(
    [ValidateSet("BlogId","PandocAdditionalArgs","PandocHtmlFormat","PandocMarkdownFormat")]
    [string]$Name,

    [string]$Value
  )

  $userPreferences = @{}

  if (Test-Path $TyporaBloggerSession.UserPreferences)
  {
    Write-Verbose "Loading preferences from $($TyporaBloggerSession.UserPreferences)"
    $userPreferences = Get-Content $TyporaBloggerSession.UserPreferences | ConvertFrom-Json
  }

  if ($userPreferences.PsObject.Properties.Name -notcontains $Name)
  {
    Write-Verbose "Adding Property $Name"
    $userPreferences | Add-Member -Name $Name -Value $Value -MemberType NoteProperty
  }
  else {
    Write-Verbose "Updating Propery $Name"
    $userPreferences.$Name = $Value
  }  

  Set-Content -Path $TyporaBloggerSession.UserPreferences -Value ($userPreferences | ConvertTo-Json)
  $TyporaBloggerSession.$Name = $Value
}
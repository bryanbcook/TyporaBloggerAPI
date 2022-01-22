<#
.SYNOPSIS
Obtains the current TyporaBlogger configuration for the session

#>
Function Get-TyporaBloggerConfig
{
  @{
    Template = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TyporaBloggerSession.PandocTemplate)
    PandocMarkdownFormat = $TyporaBloggerSession.PandocMarkdownFormat
    PandocHtmlFormat = $TyporaBloggerSession.PandocHtmlFormat
    PandocAdditionalArgs = $TyporaBloggerSession.PandocAdditionalArgs
    BlogId = $TyporaBloggerSession.BlogId
  }
}
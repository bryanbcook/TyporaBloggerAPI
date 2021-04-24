<#
.SYNOPSIS
Convert a file to Markdown using Pandoc

.PARAMETER File
The file path of the markdown file

.PARAMETER OutFile
The resulting html. If this parameter is not specified an HTML file with the same name of the markdown file will be created.

#>
function ConvertTo-HtmlFromMarkdown
{
    param(
        [Parameter(Mandatory=$true, HelpMessage="Path to Markdown file")]
        [ValidateScript({ Test-Path $_ -PathType Leaf})]
        [string]$File,

        [Parameter(HelpMessage="File path to create")]
        #[ValidateScript({ Test-Path $_ -Include "*.html" -PathType Container})]
        [string]$OutFile
    )

    # Use pandoc to convert the markdown to Html 
    $pandocArgs =  "`{0}` " -f $File
    $pandocArgs += "-f {0} " -f $TyporaBloggerSession.PandocMarkdownFormat
    $pandocArgs += "-t {0} " -f $TyporaBloggerSession.PandocHtmlFormat

    # add template and toc if template is available
    if (Test-Path $TyporaBloggerSession.PandocTemplate) {
        Write-Verobse "Using template"
        $pandocArgs += "--template {0} --toc " -f $TyporaBloggerSession.PandocTemplate
    }
    # add additional command-line arguments
    if ($TyporaBloggerSession.PandocAdditionalArgs) {
        Write-Verbose "Using additional args"
        $pandocArgs += "{0} " -f $TyporaBloggerSession.PandocAdditionalArgs
    }

    if (!($OutFile))
    {
        $OutFile = Join-Path (Split-Path $File -Parent) ((Split-Path $File -LeafBase) + ".html")
        Write-Verbose "Using OutFile: $OutFile"
    }

    $pandocArgs += "-o {0} " -f $OutFile

    Write-Verbose ">> pandoc $($pandocArgs)"
    Start-Process pandoc -ArgumentList $pandocArgs -NoNewWindow -Wait

    # Apply additional transforms
    $content = Get-Content $OutFile -Raw
    
    ## TEMP: My blog doesn't support <pre><code> yet, so I'm trimming it out.
    # convert <pre><code> -> <pre>
    $content = $content -replace '<pre(.*)><code>','<pre$1>'
    # convert </code></pre> -> </pre>
    $content = $content -replace '</code></pre>','</pre>'

    Set-Content -Path $OutFile -Value $content
    return $content
}
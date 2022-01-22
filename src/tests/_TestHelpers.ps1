function Set-MarkdownFile($path, $content) {
  <#
    .SYNOPSIS
    Set the content of a markdown file
  #>
  Set-Content -Path $path -Value $content
}

function New-BlogPost($id) {
  <#
    .SYNOPSIS
    Blogger Blog post
  #>
  @{ id=$id }
}


Function New-FrontMatter([string[]]$lines) {
  return "---`n" + ($lines -join "`n") + "`n---`n"
}
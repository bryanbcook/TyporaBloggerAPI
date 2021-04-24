<#

#>
Function Publish-MarkdownBloggerPost
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$File,

    [Parameter(Mandatory=$false)]
    [int]$BlogId,

    [Parameter(Mandatory=$false)]
    [switch]$Draft
  )

  if (!$PSBoundParameters.ContainsKey("BlogId"))
  {
    $BlogId = $TyporaBloggerSession.BlogId
    if (0 -eq $BlogId) {
      throw "BlogId not specified."
    }
  }

  # grab the front matter
  $postInfo = Get-MarkdownFrontMatter -File $File
    
  # convert from markdown to html file
  $content = ConvertTo-HtmlFromMarkdown -File $File

  # construct args
  $postArgs = @{
    BlogId = $BlogId
    Title = $postInfo.title
    Content = $content
    Draft = $Draft
  }

  if ($postInfo["postId"]) {
    $postArgs.PostId = $postInfo.postid
  }
  
  $post = Publish-BloggerPost @postArgs

  # # update post id
  $postInfo["postId"] = $post.id
  if ($Draft) {
    $postInfo["wip"] = $true
  } else {
    if ($postInfo["wip"]) {
      $postInfo.Remove("wip")
    }
  }

  Set-MarkdownFrontMatter -File $File -Replace $postInfo

  return $post
}
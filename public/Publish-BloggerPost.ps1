Function Publish-BloggerPost
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$BlogId,

        [Parameter()]
        [string]$PostId,

        [Parameter(Mandatory=$true)]
        [string]$Title,

        [Parameter(Mandatory=$true)]
        [string]$Content,

        [string[]]$labels,

        [switch]$Draft
    )

    $uri = "https://www.googleapis.com/blogger/v3/blogs/$BlogId/posts"

    # if the postId exists, we're performing an update
    if ($PostId)
    {
        $uri += "/$PostId"
    }
    else {
        if ($Draft) {
            $uri += "?isDraft=true"
        }
    }

    $body = @{
        kind= "blogger#post"
        blog = @{
            id = $BlogId
        }
        title = $Title
        content = $Content
        labels = $labels
    }

    $body | ConvertTo-Json | Write-Verbose

    $post = Invoke-GApi -Uri $uri -Body ($body | ConvertTo-Json)

    $previewUrl = "https://www.blogger.com/blog/post/edit/preview/$BlogId/$($post.id)"

    Start-Process $previewUrl

    return $post
}
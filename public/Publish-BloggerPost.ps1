Function Publish-BloggerPost
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$blogid,

        [Parameter()]
        [string]$postId,

        [Parameter(Mandatory=$true)]
        [string]$title,

        [Parameter(Mandatory=$true)]
        [string]$content,

        [string[]]$labels,

        [switch]$Draft
    )

    $uri = "https://www.googleapis.com/blogger/v3/blogs/$blogId/posts"

    # if the postId exists, we're performing an update
    if ($postId)
    {
        $uri += "/$postId"
    }
    else {
        if ($Draft) {
            $uri += "?isDraft=true"
        }
    }

    $body = @{
        kind= "blogger#post"
        blog = @{
            id = $blogId
        }
        title = $title
        content = $content
        labels = $labels
    }

    Invoke-GApi -Uri $uri -Body ($body | ConvertTo-Json)
}
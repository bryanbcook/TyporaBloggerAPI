Function Get-BloggerBlogs
{
    [CmdletBinding()]
    param(

    )

    try {
        $uri = "https://www.googleapis.com/blogger/v3/users/self/blogs"
    
        $result = Invoke-GApi -uri $uri
    
        $result.items            
    }
    catch {
        Write-Error $_.ToString()
    }
}
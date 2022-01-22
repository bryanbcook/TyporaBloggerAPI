Function Invoke-GApi
{
    param(
        [Parameter(Mandatory)]
        [string]$uri,

        [string]$body,

        [string]$method = "GET"
    )

    # obtain the auth-header
    $headers = Get-AuthHeader

    $invokeArgs = @{
        Uri = $uri
        Method = $method
        ContentType = "application/json"
        Headers = $headers
    }

    if ($body) {

        if ($method -eq "GET") {
            $invokeArgs.Method = "POST"
        }
        $invokeArgs.Body = $body
    }

    Invoke-RestMethod @invokeArgs
}
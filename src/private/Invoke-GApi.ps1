Function Invoke-GApi
{
    param(
        [Parameter(Mandatory)]
        [string]$uri,

        [string]$body,

        [string]$method = "GET",

        [string]$ContentType = "application/json"
    )

    # obtain the auth-header
    $headers = Get-AuthHeader

    $invokeArgs = @{
        Uri = $uri
        Method = $method
        ContentType = $ContentType
        Headers = $headers
    }

    if ($body) {

        if ($method -eq "GET") {
            $invokeArgs.Method = "POST"
        }
        $invokeArgs.Body = $body
    }

    Write-Verbose $Body

    Invoke-RestMethod @invokeArgs -Verbose
}
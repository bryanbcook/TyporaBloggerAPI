Function Invoke-GApi
{
    param(
        [string]$uri,

        [string]$body,

        [string]$method = "GET"
    )

    # obtain the auth-header
    $headers = Get-AuthHeader

    if ($body) {

        if ($method -eq "GET") {
            $method = "POST"
        }

        Write-Verbose "body:`n$body"

        Invoke-RestMethod -Uri $uri -Body $body -Method $method -ContentType "application/json" -Headers $headers
    }
    else 
    {
        Invoke-RestMethod -Uri $uri -Method $method -ContentType "application/json" -Headers $headers
    }
}
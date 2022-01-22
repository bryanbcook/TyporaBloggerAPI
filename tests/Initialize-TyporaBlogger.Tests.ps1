Describe "Initialize-TyporaBlogger" {

  BeforeEach {
    Import-Module $PSScriptRoot\..\TyporaBloggerApi.psm1 -Force
  }

  Context "User provides AuthCode" {

    BeforeEach {
      InModuleScope -ModuleName TyporaBloggerAPI {
        # simulate valid auth token
        Mock Get-GoogleAccessToken { return @{ refresh_token = "refresh_token" } }
        # simulate valid offline token
        Mock Update-GoogleAccessToken { return @{ access_token = "access_token" } }
      }
    }

    It "Should persist credentials" {
      
      # test variable inside loaded module
      InModuleScope -ModuleName TyporaBloggerAPI {
        # arrange
        $credentialCache = "TestDrive:\credentialcache.json"
        $TyporaBloggerSession.CredentialCache = $credentialCache

        # act
        Initialize-TyporaBlogger -code "simulatedcode"
        
        # assert
        $credentials = Get-Content -Path $credentialCache | ConvertFrom-Json
        $credentials.access_token | Should -Be "access_token"
      }
    }

    It "Should reset previous auth tokens" {
      # test variable inside loaded module
      InModuleScope -ModuleName TyporaBloggerAPI {
        # arrange
        $credentialCache = "TestDrive:\credentialcache.json"
        $TyporaBloggerSession.CredentialCache = $credentialCache
        
        $TyporaBloggerSession.AccessToken = "invalid"
        $TyporaBloggerSession.RefreshToken = "invalid"

        # act
        Initialize-TyporaBlogger -code "simulatedcode"
        
        # assert
        $TyporaBloggerSession.AccessToken | Should -Be $null
        $TyporaBloggerSession.RefreshToken | Should -Be $null
      }
    }

  }

}
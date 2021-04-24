Describe "Publish-MarkdownBloggerPost" {
  BeforeAll {

    Import-Module $PSScriptRoot\_TestHelpers.ps1 -Force

    # dummy result 
    Mock Publish-BloggerPost {return @{ id="123"}}
    
    $validFile = "TestDrive:\validfile.md"
    Set-MarkdownFile $validFile "# hello world"
    
  }
  BeforeEach {
    Import-Module $PSScriptRoot\..\TyporaBloggerApi.psm1 -Force

    # avoid pandoc for now
    Mock ConvertTo-HtmlFromMarkdown { "<div>dummy</div>" }
  }

  Context "Blog Id Preference has not been set" {

    BeforeEach {
      # clear blogid
      InModuleScope TyporaBloggerAPI {
        $TyporaBloggerSession.BlogId = $null
      }      
    }

    It "Should complain when blog id is not specified" {
      # act / assert
      {
        Publish-MarkdownBloggerPost -File $validFile 
      } | Should -Throw -ExpectedMessage "BlogId not specified."
    }

    It "Should publish to blog when blog id is specified" {
      # arrange
      Mock Publish-BloggerPost -Verifiable { return @{ id=123; } }
      Mock Set-MarkdownFrontMatter -Verifiable {}

      # act
      Publish-MarkdownBloggerPost -File $validFile -BlogId 1234

      Should -InvokeVerifiable
    }
  }

  Context "Publishing with Draft setting enabled" {

    It "Should mark the file as wip" {
      # arrange
      $testFile = "TestDrive:\testfile.md"
      Set-Content -Path $testFile -Value "# hello world"

      # act
      Publish-MarkdownBloggerPost -File $testFile -BlogId 1234 -Draft

      #assert
      $result = Get-MarkdownFrontMatter -File $testFile
      $result['wip'] | Should -Not -BeNullOrEmpty
      $result.wip | Should -Be $true
    }
  }

  Context "Publishing with Draft setting removed" {
    It "Should remove the wip flag from existing front-matter" {
      # arrange
      $testFile = "TestDrive:\valid.md"
      Set-Content -Path $testFile -Value @"
---
wip: true
---
# helloworld
"@

      # act
      Publish-MarkdownBloggerPost -File $testFile -BlogId 1234

      # arrange
      $frontMatter = Get-MarkdownFrontMatter $testFile
      $frontMatter['wip'] | Should -Be $null
    }
  }

  
  It "Should update front matter with postid after publishing" {
    # arrange
    Mock Publish-BloggerPost { return New-BlogPost "post1" }

    # act
    Publish-MarkdownBloggerPost -File $validFile -BlogId "123"

    # assert
    $postInfo = Get-MarkdownFrontMatter $validFile
    $postInfo.postid | Should -Be "post1" -Because "Markdown file should be updated with post id after publishing for the first time."
  }
}

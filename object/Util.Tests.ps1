Describe '[Util]' {
  Context 'help()' {
    It 'display README.md' {
      Invoke-Command help | Should -be '...'
    }
  }
}

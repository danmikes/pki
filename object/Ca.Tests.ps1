Describe '[CA]' {
  Context '[CA]::new' {
    It 'create CA dev' {
      { [CA]::new([CAType]::win)} | Should -Throw
    }

    It 'create CA azure' {
      [CA]::new([CAType]::root) | Should -BeOfType [CAType]
    }
  }
}

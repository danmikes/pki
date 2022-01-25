Describe '[Util]' {
  Context 'help()' {
    It 'display README.md' {
      Invoke-Command help | Should -be '
  -------------------------------------------
    input        ->  output
  -------------------------------------------
    help         ->  these instructions
  -------------------------------------------
    setApp       ->  initialise application
    testApp      ->  run all tests
  -------------------------------------------
    addUsers     ->  add admin & resto
    deleteUsers  ->  delete admin & resto
    showAdmin    ->  display name & pass
  -------------------------------------------
    addCA        ->  install RootCA
    checkCA      ->  check RootCA
    restoreCA    ->  restore RootCA
    deleteCA     ->  remove RootCA
  -------------------------------------------
    '
    }
  }

  Context 'appToPen()' {
    It 'copy application to pendrive' {
      $destination = "D:\rootca"
      Invoke-Command appToPen
      Test-Path $destination | Should -Not -BeNullOrEmpty
    }
  }
}

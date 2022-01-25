# TODO : fix search string
Describe '[Util]' {
  Context 'calling function <help>' {
    It 'should display file <readme.md>' {
      '.\README.md' | should -FileContentMatch '  ---------------------------------------------    input        ->  output  ---------------------------------------------    help         ->  instructions  ---------------------------------------------    makeUser     ->  create users    showUser     ->  display users    drop User    ->  remove users  ---------------------------------------------    makeCA       ->  create RootCA    showCA       ->  display rootca    saveCA       ->  backup RootCA    restoreCA    ->  restore RootCA    dropCA       ->  remove RootCA  ---------------------------------------------    setEnv       ->  load environment default    setEnv <?>   ->  load environment <?>    setMod       ->  set DebugMode <?>    getEnv <?>   ->  get Environment <?>    getVar <?>   ->  get Variables <?>  ---------------------------------------------'
    }
  }

  Context "appToPen()" {
    It "Copy app : disk -> pen" {
    }
  }
}

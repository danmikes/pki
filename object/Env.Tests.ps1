Describe '[Env]' {
  Context '[Env]::new' {
    It 'create env dev' {
      { [Env]::new([EnvType]::dev)} | Should -Throw
    }

    It 'create env azure' {
      [Env]::new([EnvType]::azure) | Should -BeOfType [EnvType]
    }

    It 'create env local' {
      [Env]::new([EnvType]::azure) | Should -BeOfType [EnvType]
    }

    It 'create env npo' {
      [Env]::new([EnvType]::azure) | Should -BeOfType [EnvType]
    }

    It 'create env prd' {
      [Env]::new([EnvType]::azure) | Should -BeOfType [EnvType]
    }

    It 'create env tst' {
      [Env]::new([EnvType]::azure) | Should -BeOfType [EnvType]
    }
  }
}

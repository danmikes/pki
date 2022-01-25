<# remote session #>

# define session
$user = Get-Content "$PSScriptRoot\admin.txt"
$name = $user.split(' ')[0]
$pass = [regex]::Escape($user.split(' ')[1]) | ConvertTo-SecureString -AsPlainText -Force
$credential = [pscredential]::new($name,$pass)
$session = New-PSSession -ComputerName rootca $credential

# enter session
Enter-PSSession -Session $session

# exit session
Exit-PSSession -Session $session

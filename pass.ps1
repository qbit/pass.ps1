$clearTime = 45

function List () {
    Push-Location -Path ~/.password-store
    (& tree /F /A) -replace ".gpg", ""
    Pop-Location
}

function Decrypt ($name) {
    $fn="c:\{0}\.password-store\{1}.gpg" -f $env:HOMEPATH, ($name).Replace('/','\')

    if (Test-Path -Path $fn) {
        $out = (& gpg2 -d $fn)
        $out | Select-Object -First 1 | Set-Clipboard
        Write-Host ("{0} coppied to clipboard! Clearing in {1} seconds" -f $name, 45)

	$null = $fork = [System.Management.Automation.PowerShell]::Create()
	$null = $fork.AddScript(( {
		param ($clearTime)
		Start-Sleep -Seconds $clearTime
		$null|clip
	}))

	$null = $fork.AddParameter('clearTime', $clearTime)
	$null = $fork.BeginInvoke()
    } else {
        Write-Host ("{0} doesn't exist!" -f $fn)
    }
}

if ($args.Length -gt 0) {
    Decrypt($args[0])
} else {
    List
}

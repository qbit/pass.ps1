$clearTime = 5
function List () {
    Push-Location -Path ~/.password-store
    (& tree /F /A) -replace ".gpg", ""
    Pop-Location
}

function Decrypt ($name) {
    $fn=("c:\{0}\.password-store\{1}.gpg" -f $env:HOMEPATH, ($name).Replace('/','\'))

    if (Test-Path -Path $fn) {
        $out = (& gpg2 -d $fn)
        $out | Select-Object -First 1 | Set-Clipboard
        Write-Host ("{0} coppied to clipboard! Clearing in {1} seconds" -f $name, 45)
        $ignored = (Start-Job {
            Start-Sleep -Seconds 45
            Write-Host "Clearing clipboard"
            # TODO hopefully there is a better way to do this!
            Start-Process Powershell.exe -argumentlist ("-sta -NoProfile -Command {0}" -f 'Set-Clipboard -Value "pass.ps1"')
        })
    } else {
        Write-Host ("{0} doesn't exist!" -f $fn)
    }
}

if ($args.Length -gt 0) {
    Decrypt($args[0])
} else {
    List
}

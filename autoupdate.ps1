param (
    [switch]$Push = $false,
    [string]$CompareBranch = ''
)

$ErrorActionPreference = "Stop"

if ($CompareBranch) {
	git diff-index --quiet "$CompareBranch"
	if ($LastExitCode) {
		Write-Error "Not at branch $CompareBranch. Exiting."
		exit
	}
	try { git checkout "$CompareBranch" } catch {}
}

& $env:USERPROFILE\scoop\apps\scoop\current\bin\checkver.ps1 -dir ./ * -u

git diff-index --quiet HEAD
if (-not $LastExitCode) {
	Write-Host "No changes."
	exit
}

git commit -am "Auto Update $(Get-Date -UFormat "%Y-%m-%d")"
if ($Push) {
	try { git push } catch {}
}

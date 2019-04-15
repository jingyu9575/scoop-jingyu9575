param (
	[switch]$Push = $false,
	[string]$CompareBranch = ''
)

$ErrorActionPreference = "Stop"

if ($CompareBranch) {
	git.exe diff-index --quiet "$CompareBranch"
	if ($LastExitCode) {
		Write-Error "Not at branch $CompareBranch. Exiting."
		exit
	}
	try { git.exe checkout "$CompareBranch" } catch { Write-Output $_ }
}

& $env:USERPROFILE\scoop\apps\scoop\current\bin\checkver.ps1 -dir bucket * -u

$changes = (git.exe diff-index HEAD |
	% { (($_ -split '\s+')[-1] -replace 'bucket/(.*).json', '$1' ) }) -join ', '
if (-not $changes) {
	Write-Output "No changes."
	exit
}

git.exe commit -am "Auto Update $(Get-Date -UFormat "%Y-%m-%d"): $changes"
if ($Push) {
	try { git.exe push } catch { Write-Output $_ }
}

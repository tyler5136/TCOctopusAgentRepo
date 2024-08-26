param(
  [switch]$fail,
  [switch]$exitCode,
  $Parameter1
)

if ($Fail) {
  throw "This script fails!"
}

if () {
  exit 5
}

$Env:MyVariable
$Parameter1
$PSVersionTable

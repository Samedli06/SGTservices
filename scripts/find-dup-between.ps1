param(
  [Parameter(Mandatory=$true)] [string]$DirA,
  [Parameter(Mandatory=$true)] [string]$DirB
)

$ErrorActionPreference = 'Stop'

if (!(Test-Path $DirA) -or !(Test-Path $DirB)) {
  Write-Output 'NO_FILES'
  exit 0
}

$hashA = @{}
Get-ChildItem -Path $DirA -File | ForEach-Object {
  $h = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
  if (-not $hashA.ContainsKey($h)) { $hashA[$h] = @() }
  $hashA[$h] += $_.FullName
}

$dups = @()
Get-ChildItem -Path $DirB -File | ForEach-Object {
  $h = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
  if ($hashA.ContainsKey($h)) {
    foreach ($src in $hashA[$h]) {
      $dups += [pscustomobject]@{ B=$_.FullName; A=$src; Hash=$h }
    }
  }
}

if ($dups.Count -gt 0) {
  $dups | Sort-Object B | ForEach-Object {
    Write-Output ("B={0}; A={1}" -f (Split-Path $_.B -Leaf), (Split-Path $_.A -Leaf))
  }
} else {
  Write-Output 'NO_CROSS_DIR_DUPES'
}



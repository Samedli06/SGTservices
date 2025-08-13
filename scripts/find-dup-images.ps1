$ErrorActionPreference = 'Stop'

$dir12 = Join-Path $PSScriptRoot '..\SGTservices\vbaconstructionltd.net\assets\galleries\12'
$dir13 = Join-Path $PSScriptRoot '..\SGTservices\vbaconstructionltd.net\assets\galleries\13'

if (!(Test-Path $dir12) -or !(Test-Path $dir13)) {
  Write-Output 'NO_FILES'
  exit 0
}

$h12 = @{}
Get-ChildItem -Path $dir12 -File | ForEach-Object {
  $hash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
  if (-not $h12.ContainsKey($hash)) { $h12[$hash] = @() }
  $h12[$hash] += $_.FullName
}

$dups = @()
Get-ChildItem -Path $dir13 -File | ForEach-Object {
  $h = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
  if ($h12.ContainsKey($h)) {
    foreach ($src in $h12[$h]) {
      $dups += [pscustomobject]@{ Proj2 = $_.FullName; Proj1 = $src; Hash = $h }
    }
  }
}

if ($dups.Count -gt 0) {
  $dups | Sort-Object Proj2 | ForEach-Object {
    $p2 = Split-Path $_.Proj2 -Leaf
    $p1 = Split-Path $_.Proj1 -Leaf
    Write-Output ("P2={0}; P1={1}" -f $p2, $p1)
  }
} else {
  Write-Output 'NO_CROSS_DIR_DUPES'
}



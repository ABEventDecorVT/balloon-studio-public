<#
.SYNOPSIS
    Downloads the Qt and Qt for Python corresponding-source archives, verifies
    them against the checksums published upstream, and writes a SHA256SUMS.txt
    to attach alongside them as release assets.

.DESCRIPTION
    Run this once per Qt version that ships in a release of The Ultimate
    Balloon Studio. The archives land in a local folder that is gitignored;
    they are published as GitHub release assets, never committed to git.

    Downloads resume if interrupted, which matters because the Qt archive is
    roughly 1 GB.

.EXAMPLE
    .\fetch_and_verify_source.ps1 -QtVersion 6.9.3
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$QtVersion = "6.9.3",

    [Parameter()]
    [string]$Dest = (Join-Path $PSScriptRoot "..\mirror")
)

$ErrorActionPreference = "Stop"

$parts = $QtVersion.Split(".")
if ($parts.Count -lt 2) { throw "QtVersion must look like 6.11.2" }
$qtSeries = "$($parts[0]).$($parts[1])"

$qtBase = "https://download.qt.io/official_releases/qt/$qtSeries/$QtVersion/single"
$pysideBase = "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-$QtVersion-src"

$qtArchive = "qt-everywhere-src-$QtVersion.tar.xz"
$pysideArchive = "pyside-setup-everywhere-src-$QtVersion.tar.xz"

$Dest = [System.IO.Path]::GetFullPath($Dest)
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Write-Host "Working folder: $Dest" -ForegroundColor Cyan

function Get-RemoteFile {
    param([string]$Url, [string]$OutFile)

    Write-Host "  fetching $Url" -ForegroundColor DarkGray
    # curl.exe ships with Windows 10+ and supports resume (-C -), which
    # Invoke-WebRequest does not.
    & curl.exe --location --fail --retry 3 --continue-at - --output $OutFile $Url
    if ($LASTEXITCODE -ne 0) { throw "Download failed ($LASTEXITCODE): $Url" }
}

function Get-UpstreamMd5Table {
    param([string]$Path)

    $table = @{}
    if (-not (Test-Path $Path)) { return $table }
    foreach ($line in Get-Content $Path) {
        # Upstream format: "<md5><whitespace>[*]<filename>"
        if ($line -match '^\s*([0-9a-fA-F]{32})\s+\*?(\S+)\s*$') {
            $table[$Matches[2]] = $Matches[1].ToLower()
        }
    }
    return $table
}

Write-Host "`n[1/4] Downloading upstream checksum manifests" -ForegroundColor Cyan
$qtMd5File = Join-Path $Dest "upstream-md5sums-qt.txt"
Get-RemoteFile -Url "$qtBase/md5sums.txt" -OutFile $qtMd5File

$pysideMd5File = Join-Path $Dest "upstream-md5sums-pyside.txt"
try {
    Get-RemoteFile -Url "$pysideBase/md5sums.txt" -OutFile $pysideMd5File
}
catch {
    Write-Warning "No md5sums.txt published for PySide6 $QtVersion. The PySide archive will be hashed but not cross-checked."
    Remove-Item $pysideMd5File -ErrorAction SilentlyContinue
}

Write-Host "`n[2/4] Downloading source archives (this takes a while)" -ForegroundColor Cyan
Get-RemoteFile -Url "$qtBase/$qtArchive" -OutFile (Join-Path $Dest $qtArchive)
Get-RemoteFile -Url "$pysideBase/$pysideArchive" -OutFile (Join-Path $Dest $pysideArchive)

Write-Host "`n[3/4] Verifying against upstream MD5" -ForegroundColor Cyan
$expected = Get-UpstreamMd5Table -Path $qtMd5File
$expected += Get-UpstreamMd5Table -Path $pysideMd5File

$failures = @()
foreach ($name in @($qtArchive, $pysideArchive)) {
    $full = Join-Path $Dest $name
    $actual = (Get-FileHash -Algorithm MD5 -Path $full).Hash.ToLower()

    if ($expected.ContainsKey($name)) {
        if ($actual -eq $expected[$name]) {
            Write-Host "  OK       $name" -ForegroundColor Green
        }
        else {
            Write-Host "  MISMATCH $name" -ForegroundColor Red
            Write-Host "           expected $($expected[$name])" -ForegroundColor Red
            Write-Host "           actual   $actual" -ForegroundColor Red
            $failures += $name
        }
    }
    else {
        Write-Host "  UNCHECKED $name (md5 $actual)" -ForegroundColor Yellow
    }
}

if ($failures.Count -gt 0) {
    throw "Checksum mismatch. Do NOT publish these archives; re-download and re-verify."
}

Write-Host "`n[4/4] Writing SHA256SUMS.txt" -ForegroundColor Cyan
$sumsPath = Join-Path $Dest "SHA256SUMS.txt"
$lines = @(
    "# Corresponding source archives for The Ultimate Balloon Studio",
    "# Qt $QtVersion / Qt for Python $QtVersion",
    "# Unmodified upstream releases, retained and republished by AB Event Decor LLC.",
    "# Generated $(Get-Date -Format 'yyyy-MM-dd')",
    ""
)
foreach ($name in @($qtArchive, $pysideArchive)) {
    $hash = (Get-FileHash -Algorithm SHA256 -Path (Join-Path $Dest $name)).Hash.ToLower()
    $lines += "$hash  $name"
}
$lines | Set-Content -Path $sumsPath -Encoding ascii
Get-Content $sumsPath | Write-Host

Write-Host "`nDone. Publish with:" -ForegroundColor Cyan
Write-Host "  gh release create corresponding-source-$QtVersion ``" -ForegroundColor White
Write-Host "    `"$Dest\$qtArchive`" ``" -ForegroundColor White
Write-Host "    `"$Dest\$pysideArchive`" ``" -ForegroundColor White
Write-Host "    `"$sumsPath`" ``" -ForegroundColor White
Write-Host "    --title `"Corresponding source - Qt $QtVersion / Qt for Python $QtVersion`" ``" -ForegroundColor White
Write-Host "    --notes-file RELEASE_NOTES_$QtVersion.md" -ForegroundColor White

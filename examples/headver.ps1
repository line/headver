<#
.SYNOPSIS
    PowerShell script to get HeadVer value
.DESCRIPTION
    Use current DateTime and Calendar to generation HeadVer string.

.PARAMETER Head
    The first component of the version. Zero-based.
.PARAMETER Build
    The last component of the version. Zero-based.
.PARAMETER Suffix
    Short string to be attached at the end of version string.
.PARAMETER CurrentDate
    Datetime to calculate the version value

.OUTPUTS
    System.String "${Head}.${yearweek}.${Build}"

.EXAMPLE
    PS> headver.ps1 -Head 2
    2.2146.0
.EXAMPLE
    PS> headver.ps1 -Head 0 -Build 3
    0.2146.3
.EXAMPLE
    PS> headver.ps1 -Build 11 -Suffix "dev"
    0.2146.11+dev
.EXAMPLE
    PS> headver.ps1 -CurrentDate $(Get-Date -Year 2018 -Month 12 -Day 31)
    0.1901.0
.EXAMPLE
    PS> headver.ps1 -CurrentDate $(Get-Date -Date "2007-12-31")
    0.0801.0
.EXAMPLE
    PS> headver.ps1 -CurrentDate $(Get-Date -Date "2005-01-01")
    0.0453.0
#>
using namespace System
using namespace System.Globalization
param
(
    [Uint32]$Head = 0,
    [Uint32]$Build = 0,
    [String]$Suffix = "",
    [System.DateTime]$CurrentDate = (Get-Date)
)

[Int]$year = $CurrentDate.Year % 100

[DateTime]$start = [ISOWeek]::GetYearStart($CurrentDate.Year)
if (($CurrentDate -lt $start)) {
    $year = $year - 1
}
[DateTime]$end = [ISOWeek]::GetYearEnd($CurrentDate.Year)
if (($CurrentDate -gt $end)) {
    $year = $year + 1
}

[Int]$week = [ISOWeek]::GetWeekOfYear($CurrentDate)
[Int]$yearweek = $year * 100 + $week
[String]$version = [String]::Format("{0}.{1:D4}.{2}", $Head, $yearweek, $Build)
if ($Suffix.Length -gt 0) {
    $version = [String]::Format("{0}+{1}", $version, $Suffix)
}
Write-Output $version

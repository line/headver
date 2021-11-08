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
    0.2146.11-dev
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

$culture = Get-Culture
[Calendar]$calendar = $culture.Calendar
[DateTimeFormatInfo]$format = $culture.DateTimeFormat

$week = $calendar.GetWeekOfYear($CurrentDate, $format.CalendarWeekRule, $calendar.GetDayOfWeek($CurrentDate))
$year = $CurrentDate.Year % 100
$yearweek = $year * 100 + $week

[string]$version = [String]::Format("{0}.{1}.{2}", $Head, $yearweek, $Build)
if ($Suffix.Length -gt 0) {
    $version = [String]::Format("{0}-{1}", $version, $Suffix)
}
Write-Output $version

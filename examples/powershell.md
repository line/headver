# PowerShell Script

## Introduction

PowerShell is a cross-platform shell that runs on Windows, Linux, and macOS.

This document targets [PowerShell 7.1](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-71?view=powershell-7.1)+

## How to Use

```
PS /path/to/workspace> ./headver.ps1 -Head 1 -Build 2 -Suffix "dev"
1.2146.2-dev
```
```
PS /path/to/workspace> ./headver.ps1
0.2146.0
```
```
PS /path/to/workspace> ./headver.ps1 -CurrentDate $(Get-Date -Date "2018-12-31")
0.1901.0
```
```
PS /path/to/workspace> ./headver.ps1 -CurrentDate $(Get-Date -Year 2005 -Month 1 -Day 1)
0.0453.0
```

```ps1
Get-Help -Detailed ./headver.ps1
```

## Code

```ps1
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
    $version = [String]::Format("{0}-{1}", $version, $Suffix)
}
Write-Output $version
```

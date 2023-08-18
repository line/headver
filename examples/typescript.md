# TypeScript

## Introduction

This is a HeadVer module written in TypeScript that runs on Deno or NodeJS.

It requires `date-fns` and `semver` modules.

## How to Use

You can use a HeadVer module on your build script.

```typescript
import { getNextVersion } from './headver.ts'

const nextVersion = getNextVersion({
  currentVersion: '3.0.0',
  date: new Date('2019-06-14'),
  build: 59,
})

// nextVersion => '3.1924.59'

buildMyApp({ version: nextVersion })
```

## Code

### Deno

```typescript
import * as semver from 'https://deno.land/std@0.195.0/semver/mod.ts'
import { format } from 'npm:date-fns@2.30.0'

/**
 * Get a `yearweek` string that complainant with the HeadVer specification.
 * @param date day of target
 * @returns yearweek
 * @see https://github.com/line/headver
 */
export function getYearWeek(date: Date): string {
  // We want only a suffix 2-digits of the year, but date-fns doesn't support it.
  // Therefore, we get a 4-digits year and then cut it.
  // https://date-fns.org/v2.30.0/docs/format
  // cSpell:ignore RRRRII
  return format(date, 'RRRRII').slice(2)
}

/**
 * Get a version string that complainant with the HeadVer specification.
 * @param head Zero-based number
 * @param date For generating `yearweek` string
 * @param build Incremental number from a build server
 * @param suffix Suffix string for a version string that joins with `+`.
 * @returns HeadVer string like a `3.1924.59`
 * @see https://github.com/line/headver
 */
export function getHeadVer(args: {
  head: number
  date: Date
  build: number
  suffix?: string
}): string {
  const headVer = `${args.head}.${getYearWeek(args.date)}.${args.build}`
  if (args.suffix) {
    return `${headVer}+${args.suffix}`
  }
  return headVer
}

/**
 * Get a next HeadVer that keeps the `major` and updates `minor` and `patch`.
 * If `currentVersion` has a suffix, it will be attached same suffix.
 * @param currentVersion A version string that is compatible with HeadVer or SemVer
 * @param date For generating `yearweek` string
 * @param build Incremental number from a build server
 * @param suffix Suffix string for a version string that joins with `+`
 * <ul>
 *   <li>If unset, keeps `currentVersion` suffix</li>
 *   <li>If set a string, update suffix</li>
 *   <li>If set a empty string, remove suffix</li>
 * </ul>
 * @returns HeadVer string like a `3.1924.59`
 * @see https://github.com/line/headver
 */
export function getNextVersion(args: {
  currentVersion: string
  date: Date
  build: number
  suffix?: string
}): string {
  const current = semver.parse(args.currentVersion)
  let newSuffix
  if (args.suffix || args.suffix === '') {
    newSuffix = args.suffix
  } else {
    newSuffix = current.build.join('')
  }
  return getHeadVer({
    head: current.major,
    date: args.date,
    build: args.build,
    suffix: newSuffix,
  })
}
```

### NodeJS

If you use NodeJS, please replace the import URLs with the following instructions.

1. Add dependencies to your `package.json`

```json
{
  "dependencies": {
    "date-fns": "2.30.0",
    "semver": "7.5.4"
  }
}
```

2. Replace the import URLs

```typescript
import * as semver from 'semver'
import { format } from 'date-fns'
```

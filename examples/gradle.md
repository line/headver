# Gradle Script

## Introduction

Gradle script is useful when we try to apply HeadVer to an Android build.

## How to Use

Android build can be applied as below example.

`gradlew assembleRelease -Pversion.head=1 -Pversion.build=67`

```groovy

ext {
    head = (rootProject.properties.get("version.head") as Integer)
    build = (rootProject.properties.get("version.build") as Integer)
}

android {
    defaultConfig {
        versionName "${project.head}.${new version().getYearWeek()}.${project.build}"
        // ...
    }
}
```

## Code

```groovy
class version {
    static def getYearWeek() {
        getYearWeek(Calendar.getInstance())
    }

    static def getYearWeek(Calendar calendar) {
        calendar.setMinimalDaysInFirstWeek(4)
        calendar.setFirstDayOfWeek(Calendar.MONDAY)
        calendar.setTimeZone(TimeZone.getTimeZone("UTC"))

        int year = calendar.get(Calendar.YEAR) % 100
        int week = calendar.get(Calendar.WEEK_OF_YEAR)

        // this prevents from having 1801 at the last week of the year 2019. It should be 1901
        if (week == 1 && calendar.get(Calendar.DATE) > 20) {
            year += 1
        }
        // this prevents from having 1053 at the last week of the year 2010. It should be 0953
        if (week >= 52 && calendar.get(Calendar.DATE) <= 7) {
            year -= 1
        }
        return "${String.format("%02d", year)}${String.format("%02d", week)}"
    }
}
```

The `getYearWeek()` method gives two usages as below.

```groovy
// generates middle value based on today
new version().getYearWeek()

// generates middle value based on Calendar data
new version().getYearWeek(Calendar calendar)
```

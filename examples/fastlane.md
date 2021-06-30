# Fastlane Script

## Introduction

Fastlane is a toolkit to automate build related processes which is especially friendly to iOS developers.

The introduced code in this page is a set of methods to adopt to iOS production.

## How to Use

```ruby

lane :run_your_environment do |options|

    if _increment_build_number
        increment_version()
    end

    # omit...
end
```

## Code

```ruby

# global variables
_version = get_version_number(target: _target)
_build_header = ENV["pm_build_header"]
_build_number = ENV["pm_build_number"]

lane :increment_version do |options|
    v_1 = _version.split(".")[0]
    v_2 = get_year_week(Date.today)
    v_3 = 0
    if _build_header
        v_1 = _build_header
    end
    if _build_number
        v_3 = _build_number
    elsif
        increment_build_number
        v_3 = get_build_number()
    end
    v_123 = v_1 + '.' + v_2 + '.' + v_3

    increment_build_number(build_number: v_3)
    increment_version_number(version_number: v_123)

    # renew env variable
    _version = v_123
end

 
def get_year_week(date)
  year = date.year % 100
  month = date.month
  cweek = date.cweek
  if month == 1 && cweek > 50 # Adjust year. In case of 2010.1.1, this date is last week of 2009.
    year -= 1
  elsif month == 12 && cweek == 1 # Adjust year. In case of 2018.12.31, this date is 1st week of 2019.
    year += 1
  end
  "%02d%02d" % [year, cweek]
end
```

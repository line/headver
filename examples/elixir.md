# Elixir Script 

## Introduction 

Elixir is programming language running on top Erlang Virtual Machine.

This script below requires to run on Elixir 1.13+ since it's uses `Mix.install` feature.

## How to use 

```
elixir headver.exs --head 1 --build 0 --suffix dev --current-date 2018-12-31
1.1901.0+dev
```

## Code

```elixir
Mix.install([
  {:timex, "~> 3.7"}
])

{options, _} =
  OptionParser.parse!(System.argv(),
    strict: [
      head: :integer,
      build: :integer,
      suffix: :string,
      current_date: :string
    ]
  )

head = Keyword.get(options, :head, 1)
build = Keyword.get(options, :build, 0)
suffix = Keyword.get(options, :suffix, "")

current_date =
  case Keyword.get(options, :current_date) do
    nil -> Date.utc_today()
    date -> Date.from_iso8601!(date)
  end

{year, weeknumber} = Timex.iso_week(current_date)
year = year |> rem(100) |> to_string() |> String.pad_leading(2, "0")
weeknumber = weeknumber |> to_string() |> String.pad_leading(2, "0")
yearweek = "#{year}#{weeknumber}"

version = "#{head}.#{yearweek}.#{build}"

version =
  if String.length(suffix) != 0 do
    "#{version}+#{suffix}"
  else
    version
  end

IO.puts(version)
```

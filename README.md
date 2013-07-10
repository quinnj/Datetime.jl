Datetime.jl
=======

A Date and DateTime implementation for Julia

Open the test/test.jl file for more examples of code to run and functionality.

Installation/Usage
--
Installation through the Julia package manager:
```julia
julia> Pkg.init()          # Creates julia package repository (only runs once for all packages)
julia> Pkg.add("Datetime") # Creates the Datetime repo folder and downloads the Datetime package
julia> using Datetime      # Loads the Datetime module for use (needs to be run with each new Julia instance)
```

###Creating Dates/DateTimes
```julia
julia> t = now()
2013-07-09T19:56:20 UTC

julia> t = now(CST)
2013-07-09T14:56:24 CDT

julia> t = datetime(2013,7,9,14,56,24,CST)
2013-07-09T14:56:24 CDT

julia> t = date(2013,7,9)
2013-07-09

julia> y,m,d = year(2013),month(7),day(9)
(2013,7,9)

julia> t = date(y,m,d)
2013-07-09

julia> t = datetime(y,m,d,0,0,0)
2013-07-09T00:00:00 UTC
```
Currently parsing dates (i.e. `ymd("2013-7-9")`) is not supported, but planned.
####Timezones
As shown above, timezones can be specified for datetimes (Date types are timezone-independent). Timezones can be specified
with common timezone abbreviations (CST, PST, UTC, etc.) or through the standard timezone name as a String. A DateTime
can also have its timezone modified by calling the `timezone` function as shown below.
```julia
julia> t = datetime(2013,7,9,14,56,24,CST)
2013-07-09T14:56:24 CDT

julia> t = datetime(2013,7,9,14,56,24,"Pacific/Honolulu")
2013-07-09T14:56:24 HST

julia> t = timezone(t,CST)
2013-07-09T19:56:24 CDT
```
Timezone data is based on the [Olsen](http://www.iana.org/time-zones) database for timezone information and updated from source frequently.

###Date/DateTime Accessors
```julia
julia> t = now(CST)
2013-07-09T15:11:19 CDT

julia> year(t)
2013

julia> month(t)
7

julia> day(t)
9

julia> hour(t)
15

julia> minute(t)
11

julia> second(t)
19

julia> calendar(t)
ISOCalendar

julia> lastday(t) #what is last day of month
31

julia> dayofweek(t)
2

julia> dayofyear(t)
190

julia> week(t)
28
```
###Date Arithmetic
Date arithmetic is implemented as normal and supports accurate precision to the day level (useful for ignoring timezone
and leap second variations). DateTime arithmetic is supported through the shift operators (`<<`, `>>`) and use standard
second-period conversions for shifting (i.e. 86400s/day, 31536000s/year, etc.). 
```julia
julia> dt = date(2012,2,29)
2012-02-29

julia> dt2 = date(2000,2,1)
2000-02-01

julia> dt2 - year(3)
1997-02-01

julia> dt + year(1)
2013-02-28

julia> dt2 - months(3)
1999-11-01

julia> dt2 + days(4411)
2012-02-29

julia> dt2 - month(1) + days(366)
2001-01-01

julia> dt - dt2
4411
```
###Periods
Periods are relative durations that can be useful in arithmetic. Period types are bits types in Julia and support inter-period
arithmetic as well (i.e. `day(1) + year(1) == days(366)`). Periods promote "downwards" to greater precision. 
```julia
julia> y = year(1)
1

julia> m = month(1)
1

julia> w = week(1)
1

julia> d = day(1)
1

julia> y + m
13

julia> y + w
53

julia> y + d
366

julia> y - m
11

julia> y - w
51

julia> y - d
364

julia> y > m
true

julia> d < w
true
```
###Date Ranges
Date ranges can be useful for generating sequences of dates. Date ranges inherit from Julia's numeric ranges and are 
used similarly. 
```julia
julia> dt1 = date(2000,1,1)
2000-01-01

julia> dt2 = date(2010,1,1)
2010-01-01

julia> y = year(1)
1

julia> r = dt1:y:dt2
2000-01-01:years(1):2010-01-01

julia> first(r)
2000-01-01

julia> last(r)
2010-01-01

julia> typeof(r.step)
Year{ISOCalendar}

julia> length(r)
11

julia> [r]
11-element Date{ISOCalendar} Array:
 2000-01-01
 2001-01-01
 2002-01-01
 2003-01-01
 2004-01-01
 2005-01-01
 2006-01-01
 2007-01-01
 2008-01-01
 2009-01-01
 2010-01-01

julia> dt2 = date(2000,3,1)
2000-03-01

julia> r = dt2:day(-1):dt1
2000-03-01:days(-1):2000-01-01

julia> [r]
61-element Date{ISOCalendar} Array:
 2000-03-01
 2000-02-29
 2000-02-28
 2000-02-27
 2000-02-26
 2000-02-25
 2000-02-24
 2000-02-23
 2000-02-22
 2000-02-21
 â‹®         
 2000-01-10
 2000-01-09
 2000-01-08
 2000-01-07
 2000-01-06
 2000-01-05
 2000-01-04
 2000-01-03
 2000-01-02
 2000-01-01
 ```
 ###Planned Features/Known Issues
 * Parsing string dates
 * DateTime ranges
 * Faster timezone support (certain timezones are 3x-4x slower than using default "UTC")
 * Possibly changing (<<,>>) operators with DateTimes to more normal (+,-)
 * Possibly a Time type that would be field-based similar to the Date type for Hour, Minute, and Second
 * Possibly implement "Rational division" for periods (e.g. 3/4 days)
 * Temporal expressions a la [runt](https://github.com/mlipper/runt/blob/master/doc/tutorial_te.md)
 * More extensive accuracy testing (there are a LOT of excpetions to potentially check for with dates)

module Datetime

importall Base

export Calendar, ISOCalendar, TimeZone, Date, DateTime, DateRange1,
    Year, Month, Week, Day, Hour, Minute, Second,
    year, month, week, day, hour, minute, second,
    years,months,weeks,days,hours,minutes,seconds,
    addwrap, subwrap, Date, date, unix2datetime, datetime,
    isleap, isleapday, lastday, dayofweek, dayofyear, week, isdate,
    now, calendar, timezone, setcalendar, settimezone

abstract AbstractTime
abstract Calendar <: AbstractTime
abstract ISOCalendar <: Calendar
#Set the default calendar to use; overriding this will affect module-wide defaults
CALENDAR = ISOCalendar
setcalendar{C<:Calendar}(cal::Type{C}) = global CALENDAR = cal

abstract TimeZone <: AbstractTime
include("timezone.jl")
#Set the default timezone to use; overriding this will affect module-wide defaults
#typealias UTC Zone0
TIMEZONE = UTC
settimezone{T<:TimeZone}(tz::Type{T}) = global TIMEZONE = tz

abstract TimeType <: AbstractTime
#immutable Date{C <: Calendar}						<: TimeType
#immutable Time{C <: Calendar}			 			<: TimeType
#bitstype 64 DateTime{C <: Calendar, T <: TimeZone} <: TimeType

abstract Period 	<: AbstractTime
abstract DatePeriod <: Period
abstract TimePeriod <: Period
typealias PeriodMath   Union(Real,Period)
typealias DateMath     Union(Real,DatePeriod)
typealias TimeMath     Union(Real,TimePeriod)

bitstype 32 Year{C<:Calendar}   <: DatePeriod
bitstype 32 Month{C<:Calendar}  <: DatePeriod
bitstype 32 Week{C<:Calendar}   <: DatePeriod
bitstype 32 Day{C<:Calendar}    <: DatePeriod
bitstype 32 Hour{C<:Calendar}   <: TimePeriod
bitstype 32 Minute{C<:Calendar} <: TimePeriod
bitstype 32 Second{C<:Calendar} <: TimePeriod

#Conversion/Promotion
convert{P<:Period}(::Type{P},x::Int32) = Base.box(P,Base.unbox(Int32,x))
convert{P<:Period}(::Type{Int32},x::P) = Base.box(Int32,Base.unbox(P,x))
convert{P<:Period}(::Type{P},x::Real) = convert(P,int32(x))
convert{R<:Real}(::Type{R},x::Period) = convert(R,int32(x))
promote_rule{P<:Period,R<:Real}(::Type{P},::Type{R}) = R
promote_rule{A<:DatePeriod,B<:DatePeriod}(::Type{A},::Type{B}) = 
	A == Day{CALENDAR}    || B == Day{CALENDAR}    ? Day{CALENDAR}    : 
    A == Week{CALENDAR}   || B == Week{CALENDAR}   ? Week{CALENDAR}   : Month{CALENDAR}
promote_rule{A<:TimePeriod,B<:TimePeriod}(::Type{A},::Type{B}) = 
	A == Second{CALENDAR} || B == Second{CALENDAR} ? Second{CALENDAR} :
    A == Minute{CALENDAR} || B == Minute{CALENDAR} ? Minute{CALENDAR} : Hour{CALENDAR}
#conversion rules between periods; ISO/Greg/Julian-specific, but we define as the catchall for all Calendars
convert{C<:Calendar}(::Type{Month{C}},x::Year{C})    = convert(Month{C},int32(x)*12)
convert{C<:Calendar}(::Type{Week{C}},x::Year{C})     = (info("Default conversion used: 1 year => 52 weeks"); convert(Week{C},int32(x)*52))
convert{C<:Calendar}(::Type{Day{C}},x::Year{C})      = (info("Default conversion used: 1 year => 365 days"); convert(Day{C},int32(x)*365))
convert{C<:Calendar}(::Type{Week{C}},x::Month{C})    = (info("Default conversion used: 1 month => 4 weeks"); convert(Week{C},int32(x)*4))
convert{C<:Calendar}(::Type{Day{C}},x::Month{C})     = (info("Default conversion used: 1 month => 30 days"); convert(Day{C},int32(x)*30))
convert{C<:Calendar}(::Type{Day{C}},x::Week{C})      = convert(Day{C},int32(x)*7)
convert{C<:Calendar}(::Type{Minute{C}},x::Hour{C})   = convert(Minute{C},int32(x)*60)
convert{C<:Calendar}(::Type{Second{C}},x::Hour{C})   = convert(Second{C},int32(x)*3600)
convert{C<:Calendar}(::Type{Second{C}},x::Minute{C}) = convert(Second{C},int32(x)*60)
#Constructors; default to CALENDAR; with (s) too cutesy? seems natural/expected though
years   = (year(n::DateMath)    = convert(Year{CALENDAR},n))
months  = (month(n::DateMath)   = convert(Month{CALENDAR},n))
weeks   = (week(n::DateMath)    = convert(Week{CALENDAR},n))
days    = (day(n::DateMath) 	= convert(Day{CALENDAR},n))
hours   = (hour(n::TimeMath)    = convert(Hour{CALENDAR},n))
minutes = (minute(n::TimeMath)  = convert(Minute{CALENDAR},n))
seconds = (second(n::TimeMath)  = convert(Second{CALENDAR},n))
#Print/show/traits
print(x::Period) = print(int32(x))
show(io::IO,x::Period) = print(x)
string(x::Period) = string(int32(x))
typemin{P<:Period}(::Type{P}) = convert(P,typemin(Int32))
typemax{P<:Period}(::Type{P}) = convert(P,typemax(Int32))
zero{P<:Period}(::Union(Type{P},P)) = convert(P,0)
one{P<:Period}(::Union(Type{P},P)) = convert(P,1)
#Period Arithmetic:
isless{P<:Period}(x::P,y::P) = isless(int32(x),int32(y))
isless(x::PeriodMath,y::PeriodMath) = isless(promote(x,y)...)
isequal(x::Period,y::Real) = isequal(promote(x,y)...)
isequal(x::Real,y::Period) = isequal(promote(x,y)...)
(-){P<:Period}(x::P) = convert(P,-int32(x))
for op in (:+,:-,:*,:/,:%,:fld)
	@eval begin
	($op){P<:DatePeriod}(x::P,y::P) = convert(P,($op)(int32(x),int32(y)))
	($op){P<:TimePeriod}(x::P,y::P) = convert(P,($op)(int32(x),int32(y)))
	($op){P<:Period}(x::P,y::Real) = convert(P,($op)(promote(x,y)...))
	($op){P<:Period}(x::Real,y::P) = convert(P,($op)(promote(x,y)...))
	!contains((/,%,fld),$op) && ( ($op)(x::Period,y::Period) = ($op)(promote(x,y)...) )
	!contains((/,%,fld),$op) && @vectorize_2arg Period ($op)
	end
end
#wrapping arithmetic
addwrap{C<:Calendar}(x::Month{C},y::Month{C}) = (v = (x + y)      % 12; return v == 0 ? 12 : v)
subwrap{C<:Calendar}(x::Month{C},y::Month{C}) = (v = (x - y + 12) % 12; return v == 0 ? 12 : v)
addwrap{C<:Calendar}(x::Year{C},y::Month{C},z::Month{C}) = year(x + (y + z > 12 ? int(max(1, fld(z,12)) ) : 0))
subwrap{C<:Calendar}(x::Year{C},y::Month{C},z::Month{C}) = year(x - (y - z < 1  ? int(max(1, fld(z,12)) ) : 0))

#Field-based Date type parameterized by Calendar; timezone independent (no hours,minutes,seconds)
immutable Date{C<:Calendar} <: TimeType
	year::Year{C}
	month::Month{C}
	day::Day{C}
end
year{C<:Calendar}(dt::Date{C})  = dt.year
month{C<:Calendar}(dt::Date{C}) = dt.month
day{C<:Calendar}(dt::Date{C})   = dt.day
#ISO-compliant constructor
_isleap{C<:Calendar}(y::Year{C}) = (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0))
_lastday{C<:Calendar}(y::Year{C},m::Month{C}) = (m == 2 ? 28 : 31 - (int(m) - 1) % 7 % 2) + (m == 2 && _isleap(y))
function Date{C<:ISOCalendar}(y::Year{C},m::Month{C},d::Day{C},::Type{C})
	-1 < d < _lastday(y,m) + 1 || error("Invalid date")
	0 < m < 13 || error("Invalid date")
	y == 0 && d == 0 && error("Only yyyy-mm and mm-dd partial dates allowed")
	return Date{C}(y,m,d)
end
#Default constructors; should we keep both? they both seem natural; what about ymd() family?
Date(y::DateMath,m::DateMath,d::DateMath) = Date(year(y),month(m),day(d),CALENDAR)
date(y::DateMath=1,m::DateMath=1,d::DateMath=1) = Date(year(y),month(m),day(d),CALENDAR)
#parsedate(); @datef, @sdatef macros?
##Print/show/traits; add + for years > 4 digits = ISO standard
function print{C<:Calendar}(dt::Date{C})
	y = dt.year == 0 ? "" : @sprintf("%04d",int(dt.year))
	m = dt.year == 0 ? @sprintf("%02d",int(dt.month)) : "-" * @sprintf("%02d",int(dt.month))
	dd = dt.day == 0 ? "" : "-" * @sprintf("%02d",int(dt.day))
	print(y,m,dd)
end
show{C<:Calendar}(io::IO,dt::Date{C}) = print(dt)
#Array{Date} prints dates twice; how to fix?
function string{C<:Calendar}(dt::Date{C})
	y = dt.year == 0 ? "" : @sprintf("%04d",int(dt.year))
	m = dt.year == 0 ? @sprintf("%02d",int(dt.month)) : "-" * @sprintf("%02d",int(dt.month))
	dd = dt.day == 0 ? "" : "-" * @sprintf("%02d",int(dt.day))
	return string(y,m,dd)
end
#format()
typemax{C<:Calendar}(::Type{Date{C}}) = date(typemax(Year),12,31)
typemin{C<:Calendar}(::Type{Date{C}}) = date(typemin(Year),1,1)
isequal{C<:Calendar}(x::Date{C},y::Date{C}) = isequal(x.year,y.year) && isequal(x.month,y.month) && isequal(x.day,y.day)
isless{C<:Calendar}(x::Date{C},y::Date{C}) = isless(_daynumbers(x),_daynumbers(y))
hash{C<:Calendar}(dt::Date{C}) = bitmix(bitmix(hash(dt.year),hash(dt.month)),hash(dt.day))
# needed by DataFrames
length(::Date) = 1
isdate(n) = typeof(n) <: Date
calendar{C<:Calendar}(dt::Date{C}) = C

#Generic Accessor and Date functions
isleap{C<:Calendar}(dt::Date{C}) = isleap(dt.year)
isleapday{C<:Calendar}(dt::Date{C}) = isleapday(dt.month,dt.day)
lastday{C<:Calendar}(dt::Date{C}) = lastday(dt.year,dt.month)
_yeardays{C<:Calendar}(dt::Date{C}) = _yeardays(dt.year)
_monthdays{C<:Calendar}(dt::Date{C}) = _monthdays(dt.month)
_daynumbers{C<:Calendar}(dt::Date{C}) = _daynumbers(dt.year,dt.month,dt.day)
dayofweek{C<:Calendar}(dt::Date{C}) = dayofweek(dt.year,dt.month,dt.day)
dayofyear{C<:Calendar}(dt::Date{C}) = dayofyear(dt.year,dt.month,dt.day)
week{C<:Calendar}(dt::Date{C}) = week(dt.year,dt.month,dt.day)
@vectorize_1arg Date isleap
@vectorize_1arg Date isleapday
@vectorize_1arg Date lastday
@vectorize_1arg Date dayofweek
@vectorize_1arg Date dayofyear
@vectorize_1arg Date week

isleap(y::DateMath) = isleap(year(y))
isleapday(m::DateMath,d::DateMath) = isleapday(month(m),day(d))
lastday(y::DateMath,m::DateMath) = lastday(year(y),month(m))
_yeardays(y::DateMath) = _yeardays(year(y))
_monthdays(m::DateMath) = _monthdays(month(m))
_daynumbers(y::DateMath,m::DateMath,d::DateMath) = _daynumbers(year(y),month(m),day(d))
dayofweek(y::DateMath,m::DateMath,d::DateMath) = dayofweek(year(y),month(m),day(d))
_day2date(x::DateMath) = _day2date(day(x),CALENDAR)
dayofyear(y::DateMath,m::DateMath,d::DateMath) = dayofyear(year(y),month(m),day(d))
week(y::DateMath,m::DateMath,d::DateMath) = week(year(y),month(m),day(d))

#ISO implementation of generic date functions
#Most are generic, but the _day2date algorithm comes from Peter Baum
#http://mysite.verizon.net/aesir_research/date/date0.htm
#Based on the ISO standard, which uses the proleptic Gregorian calendar
#which is the normal one everyone thinks of applied continously retroactively
#(though it was officially accepted in 1582 when they had to fast-forward 11 days)
isleap{C<:Calendar}(y::Year{C}) = _isleap(y)
isleapday{C<:Calendar}(m::Month{C},d::Day{C}) = m == 2 && d == 29
lastday{C<:Calendar}(y::Year{C},m::Month{C}) = _lastday(y,m)
_yeardays{C<:Calendar}(y::Year{C}) = int(365*y + fld(y,4) - fld(y,100) + fld(y,400))
_monthdays{C<:Calendar}(m::Month{C}) = [0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337][int(m)-2]
_daynumbers{C<:Calendar}(y::Year{C},m::Month{C},d::Day{C}) = int(d) + _monthdays(m < 3 ? m + 12 : m) + _yeardays(m < 3 ? y - 1 : y) - 307
dayofweek{C<:Calendar}(y::Year{C},m::Month{C},d::Day{C}) = _daynumbers(y,m,d) % 7 + 1
dayofyear{C<:Calendar}(y::Year{C},m::Month{C},d::Day{C}) = _daynumbers(y,m,d) - _daynumbers(y,month(1),day(1)) + 1
function _day2date{C<:Calendar}(x::Day{C},::Type{C})
	z = int(x) + 307
	h = z - .25	
	centdays = fld(h,36524.25)	
	centdays -= fld(centdays,4)
	yy = fld(centdays+h,365.25)
	c = centdays + z - itrunc(365.25*yy)
	mm = div(5*c+456,153)
	dd = c - _monthdays(mm)
	return mm > 12 ? date(yy+1,mm-12,dd) : date(yy,mm,dd)
end
function week{C<:Calendar}(y::Year{C},m::Month{C},d::Day{C})
	rdn = _daynumbers(y,m,d)
	w = fld(rdn,7) % 20871 #20871 = # of weeks in 400 years
	c = fld((w + (w >= 10435)),5218) #need # of centuries to choose right intercept below
	w = (w + (w >= 10435)) % 5218 #5218 = # of weeks in century
	w = (w*28+(15,23,3,11)[c+1]) % 1461
	return fld(w,28) + 1
end

#Date arithmetic
(-){C<:Calendar}(dt::Date{C}) = date(-dt.year,dt.month,dt.day)
(+){C<:Calendar}(dt::Date{C}) = dt
#Date-Date operations: +, *, and / are meaningless; (-) return duration in days
#no_op_err(name, T) = error(name," not defined for ",T)
(+){C<:Calendar}(x::Date{C},y::Date{C}) = Base.no_op_err("+","Date")
(*){C<:Calendar}(x::Date{C},y::Date{C}) = Base.no_op_err("*","Date")
(/){C<:Calendar}(x::Date{C},y::Date{C}) = Base.no_op_err("/","Date")
#Date difference is half-open, includes earliest date, excludes latter; should these return abs()?
(-){C<:Calendar}(x::Date{C},y::Date{C}) = days(abs( _daynumbers(x) - _daynumbers(y) ) )

#Date-Period operations: Date-Hour/Min/Sec, *, /, <, and > are meaningless; Date-Year/Month/Week/Day -, + return dates
for op in (:*,:/,:<,:>), period in (Hour,Minute,Second)
	@eval ($op){C<:Calendar}(x::Date{C},y::$period) = Base.no_op_err($op,"Date-$period")
end
(+){C<:Calendar}(x::Date{C},y::Year{C}) = (ny = x.year+y; return date(ny,x.month,x.day <= lastday(ny,x.month) ? x.day : lastday(ny,x.month)))
(+){C<:Calendar}(y::Year{C},x::Date{C}) = +(x,y)
(-){C<:Calendar}(x::Date{C},y::Year{C}) = (ny = x.year-y; return date(ny,x.month,x.day <= lastday(ny,x.month) ? x.day : lastday(ny,x.month)))
(-){C<:Calendar}(y::Year{C},x::Date{C}) = -(x,y)
function (+){C<:Calendar}(x::Date{C},y::Month{C}) 
	ny = addwrap(x.year,x.month,y)
	mm = addwrap(x.month,y)
	dd = x.day <= lastday(ny,mm) ? x.day : lastday(ny,mm)
	return date(ny,mm,dd)
end
(+){C<:Calendar}(y::Month{C},x::Date{C}) = x + y
function (-){C<:Calendar}(x::Date{C},y::Month{C})
	ny = subwrap(x.year,x.month,y)
	mm = subwrap(x.month,y)
	dd = x.day <= lastday(ny,mm) ? x.day : lastday(ny,mm)
	return date(ny,mm,dd)
end
(-){C<:Calendar}(y::Month{C},x::Date{C}) = x - y
(+){C<:Calendar}(x::Date{C},y::Week{C}) = _day2date(_daynumbers(x) + days(y))
(+){C<:Calendar}(y::Week{C},x::Date{C}) = x + y
(-){C<:Calendar}(x::Date{C},y::Week{C}) = _day2date(_daynumbers(x) - days(y))
(-){C<:Calendar}(y::Week{C},x::Date{C}) = x - y
(+){C<:Calendar}(x::Date{C},y::Day{C})  = _day2date(_daynumbers(x) + y)
(+){C<:Calendar}(y::Day{C},x::Date{C})  = x + y
(-){C<:Calendar}(x::Date{C},y::Day{C})  = _day2date(_daynumbers(x) - y)
(-){C<:Calendar}(y::Day{C},x::Date{C})  = x - y

typealias DatePeriodDate Union(DatePeriod,Date)
@vectorize_2arg DatePeriodDate (-)
@vectorize_2arg DatePeriodDate (+)

#Date ranges: start date, end date, period as step; for creating frequencies
immutable DateRange1{C<:Calendar} <: Ranges{Date{C}}
	start::Date{C}
	step::DatePeriod
	len::Int
end

size{C<:Calendar}(r::DateRange1{C}) = (r.len,)
length{C<:Calendar}(r::DateRange1{C}) = r.len
step{C<:Calendar}(r::DateRange1{C})  = r.step
start{C<:Calendar}(r::DateRange1{C}) = 0
first{C<:Calendar}(r::DateRange1{C}) = r.start
last{C<:Calendar}(r::DateRange1{C}) = r.start + (r.len-1)*r.step
next{C<:Calendar}(r::DateRange1{C}, i) = (r.start + i*r.step, i+1)
done{C<:Calendar}(r::DateRange1{C}, i) = length(r) <= i

_units(x::Period) = lowercase(string(typeof(x).name)) * "s($(string(x)))"
function show{C<:Calendar}(io::IO,r::DateRange1{C})
	print(io, r.start, ':', _units(r.step), ':', last(r))
end

colon{C<:Calendar}(t1::Date{C}, y::Year{C}, t2::Date{C}) = DateRange1{C}(t1, y, int(fld((t2.year - t1.year),y) + 1) )
colon{C<:Calendar}(t1::Date{C}, m::Month{C}, t2::Date{C}) = DateRange1{C}(t1, m, int(fld(int(t2.year-t1.year)*12+int(t2.month-t1.month),m) + 1) )
colon{C<:Calendar}(t1::Date{C}, w::Week{C}, t2::Date{C}) = DateRange1{C}(t1, w, int(fld(_daynumbers(t2)-_daynumbers(t1),days(w)) + 1) )
colon{C<:Calendar}(t1::Date{C}, d::Day{C}, t2::Date{C}) = DateRange1{C}(t1, d, int(fld(_daynumbers(t2)-_daynumbers(t1),d) + 1) )
(+){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start+p,r.step,r.len)
(-){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start-p,r.step,r.len)

#DateTime type
bitstype 64 DateTime{C <: Calendar,T <: TimeZone} <: TimeType
typealias DateTimeMath Union(DateTime,Real)
typealias DateTimeDate Union(DateTime,Date)

#bits functions
convert{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},x::Int64) = Base.box(DateTime{C,T},Base.unbox(Int64,x))
convert{C<:Calendar,T<:TimeZone}(::Type{Int64},x::DateTime{C,T}) = Base.box(Int64,Base.unbox(DateTime{C,T},x))
convert{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},x::Real) = convert(DateTime{C,T},int64(x))
convert{C<:Calendar,T<:TimeZone,R<:Real}(::Type{R}, x::DateTime{C,T}) = convert(R,int64(x))
promote_rule{C<:Calendar,T<:TimeZone,R<:Real}(::Type{DateTime{C,T}},::Type{R}) = R
promote_rule{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},::Type{Date{C}}) = Date{C}
convert{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},x::Date{C}) = datetime(x.year,x.month,x.day,0,0,0,C,TIMEZONE)
convert{C<:Calendar,T<:TimeZone}(::Type{Date{C}},x::DateTime{C,T}) = date(year(x),month(x),day(x))
#need to define inter-TimeZone arithmetic (currently crashes)
isless{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isless(int64(x),int64(y))
isequal{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isequal(int64(x),int64(y))
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = -(int64(x),int64(y))
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T}) = _datetime(-(int64(x)))
for op in (:+,:*,:/)
    @eval ($op)(x::DateTime,y::DateTime) = Base.no_op_err($op,"DateTime")
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = Base.no_op_err($op,"DateTime-Date")
end
isequal(x::DateTime,y::Real) = isequal(promote(x,y)...)
isequal(x::Real,y::DateTime) = isequal(promote(x,y)...)
for op in (:-,:isless,:isequal)
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = ($op)(promote(x,y)...)
end
(+){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DatePeriod) = convert(Date{C},x) + y
(+){C<:Calendar,T<:TimeZone}(y::DatePeriod,x::DateTime{C,T}) = convert(Date{C},x) + y
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DatePeriod) = convert(Date{C},x) - y
(-){C<:Calendar,T<:TimeZone}(y::DatePeriod,x::DateTime{C,T}) = convert(Date{C},x) - y
#default internal constructor
_datetime{C<:Calendar,T<:TimeZone}(x::Real,::Type{C}=CALENDAR,::Type{T}=TIMEZONE) = convert(DateTime{C,T},int64(x))
#ISO-compliant constructor; internal, overloaded for different Calendars
const _juneleap = [1972,1981,1982,1983,1985,1992,1993,1994,1997,2012]
const _decleap = [1972,1973,1974,1975,1976,1977,1978,1979,1987,1989,1990,1995,1998,2005,2008]
const _leaps = [62214393599,62230291199,62261827199,62293363199,62324899199,62356521599,62388057599,62419593599,62451129599,62498390399,62529926399,62561462399,62624620799,62703590399,62766748799,62798284799,62845545599,62877081599,62908617599,62956051199,63003311999,63050745599,63271670399,63366364799,63476697599,9223372036854775807]
const _leaps1 = [62214393600,62230291201,62261827202,62293363203,62324899204,62356521605,62388057606,62419593607,62451129608,62498390409,62529926410,62561462411,62624620812,62703590413,62766748814,62798284815,62845545616,62877081617,62908617618,62956051219,63003312020,63050745621,63271670422,63366364823,63476697624,9223372036854775807]
#what's a faster way of doing leapseconds? some version of searchsorted? binary search?
leaps(secs::DateTimeMath)  = findfirst(x::Int64->x>=int64(secs),_leaps) - 1
leaps1(secs::DateTimeMath) = findfirst(x::Int64->x>=int64(secs),_leaps1) - 1
function datetime{T<:TimeZone}(y::PeriodMath,m::PeriodMath,d::PeriodMath,h::PeriodMath,mi::PeriodMath,s::PeriodMath,tz::Type{T}=TIMEZONE)
    -1 < s < 61 || error("Invalid datetime")
    s == 60 && ((m == 6 && contains(_juneleap,y)) || (m == 12 && contains(_decleap,y)) || error("Invalid leapsecond"))
    -1 < mi < 60 || error("Invalid datetime")
    -1 < h < 24 || error("Invalid datetime")
    0 < d < _lastday(year(y),month(m)) +  1 || error("Invalid datetime")
    0 < m < 13 || error("Invalid datetime")
    secs = int(s) + int(60mi) + int(3600h) + int(86400 * _daynumbers(y,m,d))
    secs -= utcoffset(tz,secs)
    secs += y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs)
    return _datetime(secs,ISOCalendar,tz) #represents Rata Die seconds since 0001/1/1:00:00:00 + any elapsed leap seconds
end
datetime{C<:Calendar}(d::Date{C}) = datetime(d.year,d.month,d.day,0,0,0,C,TIMEZONE)
unix2datetime{T<:TimeZone}(x::Real,tz::Type{T}=TIMEZONE) = (s = UNIXEPOCH + x; _datetime(s - leaps(s),CALENDAR,tz))
@vectorize_1arg Real unix2datetime
#@vectorize_1arg Real TmStruct #just for testing
now() = unix2datetime(time())
now{T<:TimeZone}(tz::Type{T}) = unix2datetime(time(),tz)
# datetime{C<:Calendar,T<:TimeZone}(d::Date{C},t::Time{T}) = datetime(d.year,d.month,d.day,t.hour,t.minute,t.second,C,T)
#Accessors/Traits/Print/Show
function string{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})
    y,m,d,h,mi,s,tz = year(dt),month(dt),day(dt),hour(dt),minute(dt),second(dt),abbreviation(T,dt)
    y =  @sprintf("%04d",int(y))   * "-"
    m =  @sprintf("%02d",int(m))   * "-"
    d =  @sprintf("%02d",int(d))   * "T"
    h =  @sprintf("%02d",int(h))   * ":"
   mi =  @sprintf("%02d",int(mi))  * ":"
    s =  @sprintf("%02d",int(s))   * " " * tz
    return string(y,m,d,h,mi,s)
end
print{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = print(string(dt))
show{C<:Calendar,T<:TimeZone}(io::IO,dt::DateTime{C,T}) = print(io,string(dt))
#Adapted from our _day2date function for efficiency (avoid full Date construction)
function _day2year(x::Int64)
    z = int(x) + 307
    h = z - .25 
    centdays = fld(h,36524.25)  
    centdays -= fld(centdays,4)
    return fld(centdays+h,365.25)
end
function _day2month(x::Int64)
    z = int(x) + 307
    h = z - .25 
    centdays = fld(h,36524.25)  
    centdays -= fld(centdays,4)
    c = centdays + z - itrunc(365.25*fld(centdays+h,365.25))
    mm = div(5*c+456,153)
    return mm > 12 ? mm - 12 : mm
end
function _day2day(x::Int64)
    z = int(x) + 307
    h = z - .25 
    centdays = fld(h,36524.25)  
    centdays -= fld(centdays,4)
    c = centdays + z - itrunc(365.25*fld(centdays+h,365.25))
    mm = div(5*c+456,153)
    return c - _monthdays(mm)
end
year{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = _day2date(fld(int64(dt)-leaps(dt)+utcoffset(T,dt),86400)).year
month{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})    = _day2month(fld(int64(dt)-leaps(dt)+utcoffset(T,dt),86400))
day{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})      = _day2day(fld(int64(dt)-leaps(dt)+utcoffset(T,dt),86400))
hour{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = fld((int64(dt) - leaps(dt)+utcoffset(T,dt)),3600) % 24
minute{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = fld((int64(dt) - leaps(dt)+utcoffset(T,dt)) % 3600, 60)
second{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = (s = ((int64(dt) - leaps1(dt)+utcoffset(T,dt)) % 60); return s != 0 ? s : contains(_leaps1,dt) ? 60 : 0)
calendar{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = C
timezone{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = T

isleap{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = isleap(year(dt))
isleapday{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = isleapday(month(dt),day(dt))
lastday{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})    = lastday(year(dt),month(dt))
dayofweek{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = (fld(int64(dt),86400) + 1) % 7
dayofyear{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = dayofyear(year(dt),month(dt),day(dt))
week{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})       = week(year(dt),month(dt),day(dt))
@vectorize_1arg DateTime isleap
@vectorize_1arg DateTime isleapday
@vectorize_1arg DateTime lastday
@vectorize_1arg DateTime dayofweek
@vectorize_1arg DateTime dayofyear
@vectorize_1arg DateTime week

#DateTime-Period arithmetic: <<, >>
end #module
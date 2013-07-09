module Datetime

importall Base

export Calendar, ISOCalendar, TimeZone, Date, DateTime, DateRange1,
    Year, Month, Week, Day, Hour, Minute, Second,
    year, month, week, day, hour, minute, second,
    years,months,weeks,days,hours,minutes,seconds,
    addwrap, subwrap, Date, date, unix2datetime, datetime,
    isleap, isleapday, lastday, dayofweek, dayofyear, week, isdate,
    now, calendar, timezone, setcalendar, settimezone, timezone

abstract AbstractTime
abstract Calendar <: AbstractTime
abstract ISOCalendar <: Calendar
#Set the default calendar to use; overriding this will affect module-wide defaults
const CALENDAR = ISOCalendar
setcalendar{C<:Calendar}(cal::Type{C}) = (global CALENDAR = cal)

abstract TimeZone <: AbstractTime
include("timezone.jl")
#Set the default timezone to use; overriding this will affect module-wide defaults
#typealias UTC Zone0
const TIMEZONE = UTC
settimezone{T<:TimeZone}(tz::Type{T}) = (global TIMEZONE = tz)

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
convert{P<:Period}(::Type{P},x::P) = x
promote_rule{P<:Period,R<:Real}(::Type{P},::Type{R}) = R
promote_rule{A<:Period,B<:Period}(::Type{A},::Type{B}) =
	A == Second{CALENDAR} || B == Second{CALENDAR} ? Second{CALENDAR} :
    A == Minute{CALENDAR} || B == Minute{CALENDAR} ? Minute{CALENDAR} : 
    A == Hour{CALENDAR}   || B == Hour{CALENDAR}   ? Hour{CALENDAR}   :
	A == Day{CALENDAR}    || B == Day{CALENDAR}    ? Day{CALENDAR}    : 
    A == Week{CALENDAR}   || B == Week{CALENDAR}   ? Week{CALENDAR}   : Month{CALENDAR}
#conversion rules between periods; ISO/Greg/Julian-specific, but we define as the catchall for all Calendars
convert{C<:Calendar}(::Type{Month{C}},x::Year{C})    = convert(Month{C},  int32(12x))
convert{C<:Calendar}(::Type{Week{C}},x::Year{C})     = convert(Week{C},   int32(52x))
convert{C<:Calendar}(::Type{Day{C}},x::Year{C})      = convert(Day{C},    int32(365x))
convert{C<:Calendar}(::Type{Day{C}},x::Week{C})      = convert(Day{C},    int32(7x))
convert{C<:Calendar}(::Type{Hour{C}},x::Year{C})     = convert(Hour{C},   int32(8760x))
convert{C<:Calendar}(::Type{Hour{C}},x::Week{C})     = convert(Hour{C},   int32(168x))
convert{C<:Calendar}(::Type{Hour{C}},x::Day{C})      = convert(Hour{C},   int32(24x))
convert{C<:Calendar}(::Type{Minute{C}},x::Year{C})   = convert(Minute{C}, int32(525600x)) #Rent anybody?
convert{C<:Calendar}(::Type{Minute{C}},x::Week{C})   = convert(Minute{C}, int32(10080x))
convert{C<:Calendar}(::Type{Minute{C}},x::Day{C})    = convert(Minute{C}, int32(1440x))
convert{C<:Calendar}(::Type{Minute{C}},x::Hour{C})   = convert(Minute{C}, int32(60x))
convert{C<:Calendar}(::Type{Second{C}},x::Year{C})   = convert(Second{C}, int32(31536000x))
convert{C<:Calendar}(::Type{Second{C}},x::Week{C})   = convert(Second{C}, int32(604800x))
convert{C<:Calendar}(::Type{Second{C}},x::Day{C})    = convert(Second{C}, int32(86400x))
convert{C<:Calendar}(::Type{Second{C}},x::Hour{C})   = convert(Second{C}, int32(3600x))
convert{C<:Calendar}(::Type{Second{C}},x::Minute{C}) = convert(Second{C}, int32(60x))
#Constructors; default to CALENDAR; with (s) too cutesy? seems natural/expected though
years   = (year(x::PeriodMath)    = convert(Year{CALENDAR},x))
months  = (month(x::PeriodMath)   = convert(Month{CALENDAR},x))
weeks   = (week(x::PeriodMath)    = convert(Week{CALENDAR},x))
days    = (day(x::PeriodMath) 	  = convert(Day{CALENDAR},x))
hours   = (hour(x::PeriodMath)    = convert(Hour{CALENDAR},x))
minutes = (minute(x::PeriodMath)  = convert(Minute{CALENDAR},x))
seconds = (second(x::PeriodMath)  = convert(Second{CALENDAR},x))
#Print/show/traits
print(x::Period) = print(int32(x))
show(io::IO,x::Period) = print(x)
string(x::Period) = string(int32(x))
typemin{P<:Period}(::Type{P}) = convert(P,typemin(Int32))
typemax{P<:Period}(::Type{P}) = convert(P,typemax(Int32))
zero{P<:Period}(::Union(Type{P},P)) = convert(P,int32(0))
one{P<:Period}(::Union(Type{P},P)) = convert(P,int32(1))
#Period Arithmetic:
isless{P<:Period}(x::P,y::P) = isless(int32(x),int32(y))
isless(x::PeriodMath,y::PeriodMath) = isless(promote(x,y)...)
isequal(x::Period,y::Real) = isequal(promote(x,y)...)
isequal(x::Real,y::Period) = isequal(promote(x,y)...)
(-){P<:Period}(x::P) = convert(P,-int32(x))
for op in (:+,:-,:*,:/,:%,:fld)
	@eval begin
	($op){P<:Period}(x::P,y::P) = convert(P,($op)(int32(x),int32(y)))
	($op){P<:Period}(x::P,y::Real) = ($op)(promote(x,y)...)
	($op){P<:Period}(x::Real,y::P) = ($op)(promote(x,y)...)
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
year(dt::Date)  = dt.year
month(dt::Date) = dt.month
day(dt::Date)   = dt.day
#ISO-compliant constructor
_isleap(y::Year) = (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0))
const DAYSINMONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
_lastday(y::Year,m::Month) = DAYSINMONTH[int(m)] + (m == 2 && _isleap(y))
function Date{C<:ISOCalendar}(y::Year{C},m::Month{C},d::Day{C},::Type{C})
	-1 < d < _lastday(y,m) + 1 || error("Invalid day")
	0 < m < 13 || error("Invalid month")
	return Date{C}(y,m,d)
end
#Default constructors; should we keep both? they both seem natural; what about ymd() family?
Date(y::DateMath,m::DateMath,d::DateMath) = Date(year(y),month(m),day(d),CALENDAR)
date(y::DateMath=1,m::DateMath=1,d::DateMath=1) = Date(year(y),month(m),day(d),CALENDAR)
#parsedate(); @datef, @sdatef macros?
##Print/show/traits; add + for years > 4 digits = ISO standard
function string{C<:Calendar}(dt::Date{C})
	y = dt.year == 0 ? "" : @sprintf("%04d",int(dt.year))
	m = dt.year == 0 ? @sprintf("%02d",int(dt.month)) : "-" * @sprintf("%02d",int(dt.month))
	dd = dt.day == 0 ? "" : "-" * @sprintf("%02d",int(dt.day))
	return string(y,m,dd)
end
print(dt::Date) = print(string(dt))
show(io::IO,dt::Date) = print(io,string(dt))
#format()
typemax{C<:Calendar}(::Type{Date{C}}) = date(typemax(Year),12,31)
typemin{C<:Calendar}(::Type{Date{C}}) = date(typemin(Year),1,1)
isequal{C<:Calendar}(x::Date{C},y::Date{C}) = isequal(x.year,y.year) && isequal(x.month,y.month) && isequal(x.day,y.day)
isless{C<:Calendar}(x::Date{C},y::Date{C}) = isless(_daynumbers(x),_daynumbers(y))
hash{C<:Calendar}(dt::Date{C}) = bitmix(bitmix(hash(dt.year),hash(dt.month)),hash(dt.day))
length(::Date) = 1
isdate(n) = typeof(n) <: Date
calendar{C<:Calendar}(dt::Date{C}) = C

#Generic Accessor and Date functions
isleap{C<:Calendar}(dt::Date{C}) = isleap(dt.year)
isleapday{C<:Calendar}(dt::Date{C}) = isleapday(dt.month,dt.day)
lastday{C<:Calendar}(dt::Date{C}) = lastday(dt.year,dt.month)
_yeardays{C<:Calendar}(dt::Date{C}) = _yeardays(dt.year)
_monthdays{C<:Calendar}(dt::Date{C}) = (m = dt.month < 3 ? dt.month+12 : dt.month; return _monthdays(month(m)))
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
_monthdays(m::DateMath) = (m = m < 3 ? m+12 : m; _monthdays(month(m)))
_daynumbers(y::DateMath,m::DateMath,d::DateMath) = _daynumbers(year(y),month(m),day(d))
dayofweek(y::DateMath,m::DateMath,d::DateMath) = dayofweek(year(y),month(m),day(d))
dayofyear(y::DateMath,m::DateMath,d::DateMath) = dayofyear(year(y),month(m),day(d))
week(y::DateMath,m::DateMath,d::DateMath) = week(year(y),month(m),day(d))

#ISO implementation of generic date functions
#Most are generic, but the _day2date algorithm comes from Peter Baum
#http://mysite.verizon.net/aesir_research/date/date0.htm
#Based on the ISO standard, which uses the proleptic Gregorian calendar
#which is the normal one everyone thinks of applied retroactively
#(though it was officially accepted in 1582 when they had to fast-forward 11 days)
isleap(y::Year) = _isleap(y)
isleapday(m::Month,d::Day) = m == 2 && d == 29
lastday(y::Year,m::Month) = _lastday(y,m)
_yeardays(y::Year) = 365*y + fld(y,4) - fld(y,100) + fld(y,400)
const MONTHDAYS = [0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337]
_monthdays(m::Month) = (ind = m-2; return MONTHDAYS[ind])
_daynumbers(y::Year,m::Month,d::Day) = d + _monthdays(m<3 ? m+12 : m) + _yeardays(m<3 ? y-1 : y) - 307
dayofweek(y::Year,m::Month,d::Day) = _daynumbers(y,m,d) % 7 + 1
dayofyear(y::Year,m::Month,d::Day) = _daynumbers(y,m,d) - _daynumbers(y,month(1),day(1)) + 1
function _day2date(x::DateMath)
	z = x + 307
	h = z - .25	
	centdays = fld(h,36524.25)	
	centdays -= fld(centdays,4)
	yy = fld(centdays+h,365.25)
	c = centdays + z - itrunc(365.25*yy)
	mm = div(5*c+456,153)
	dd = c - _monthdays(mm)
	return mm > 12 ? date(yy+1,mm-12,dd) : date(yy,mm,dd)
end
function week(y::Year,m::Month,d::Day)
	rdn = _daynumbers(y,m,d)
	w = fld(rdn,7) % 20871 #20871 = # of weeks in 400 years
	c = fld((w + (w >= 10435)),5218) #need # of centuries to choose right intercept below
	w = (w + (w >= 10435)) % 5218 #5218 = # of weeks in century
	w = (w*28+(15,23,3,11)[c+1]) % 1461
	return fld(w,28) + 1
end

#Date arithmetic
(-)(dt::Date) = date(-dt.year,dt.month,dt.day)
(+)(dt::Date) = dt
#Date-Date operations: +, *, and / are meaningless; (-) return duration in days
#no_op_err(name, T) = error(name," not defined for ",T)
(+)(x::Date,y::Date) = Base.no_op_err("+","Date")
(*)(x::Date,y::Date) = Base.no_op_err("*","Date")
(/)(x::Date,y::Date) = Base.no_op_err("/","Date")
#Date difference is half-open, includes earliest date, excludes latter; should these return abs()?
(-)(x::Date,y::Date) = _daynumbers(x) - _daynumbers(y)

#Date-Period operations: Date-Hour/Min/Sec, *, /, <, and > are meaningless; Date-Year/Month/Week/Day -, + return dates
for op in (:*,:/,:<,:>), period in (Hour,Minute,Second)
	@eval ($op)(x::Date,y::$period) = Base.no_op_err($op,"Date-$period")
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
(+){C<:Calendar}(x::Date{C},y::Week{C}) = _day2date(_daynumbers(x) + 7y)
(+){C<:Calendar}(y::Week{C},x::Date{C}) = x + y
(-){C<:Calendar}(x::Date{C},y::Week{C}) = _day2date(_daynumbers(x) - 7y)
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
size(r::DateRange1) = (r.len,)
length(r::DateRange1) = r.len
step(r::DateRange1)  = r.step
start(r::DateRange1) = 0
first(r::DateRange1) = r.start
last(r::DateRange1) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
next(r::DateRange1, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
done(r::DateRange1, i) = length(r) <= i
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
promote_rule{C<:Calendar,T<:TimeZone,TT<:TimeZone}(::Type{DateTime{C,T}},::Type{DateTime{C,TT}}) = DateTime{C,Zone0}
convert{C<:Calendar,T<:TimeZone,TT<:TimeZone}(::Type{DateTime{C,T}},x::DateTime{C,TT}) = _datetime(int64(x),C,T)
promote_rule{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},::Type{Date{C}}) = Date{C}
convert{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},x::Date{C}) = datetime(x.year,x.month,x.day,0,0,0,C,TIMEZONE)
convert{C<:Calendar,T<:TimeZone}(::Type{Date{C}},x::DateTime{C,T}) = date(year(x),month(x),day(x))
isless{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isless(int64(x),int64(y))
isless(x::DateTime,y::Real) = isless(int64(x),int64(y))
isless(x::Real,y::DateTime) = isless(int64(x),int64(y))
isequal{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isequal(int64(x),int64(y))
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = seconds(-(int64(x),int64(y)))
(+)(x::DateTime) = x
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T}) = datetime(-year(x),month(x),day(x),hour(x),minute(x),second(x),T)
for op in (:+,:*,:/)
    @eval ($op)(x::DateTime,y::DateTime) = Base.no_op_err($op,"DateTime")
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = Base.no_op_err($op,"DateTime-Date")
end
isequal(x::DateTime,y::Real) = isequal(promote(x,y)...)
isequal(x::Real,y::DateTime) = isequal(promote(x,y)...)
for op in (:-,:isless,:isequal)
	@eval ($op){C<:Calendar,T<:TimeZone,TT<:TimeZone}(x::DateTime{C,T},y::DateTime{C,TT}) = ($op)(promote(x,y)...)
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = ($op)(promote(x,y)...)
end
(+){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DatePeriod) = convert(Date{C},x) + y
(+){C<:Calendar,T<:TimeZone}(y::DatePeriod,x::DateTime{C,T}) = convert(Date{C},x) + y
(-){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DatePeriod) = convert(Date{C},x) - y
(-){C<:Calendar,T<:TimeZone}(y::DatePeriod,x::DateTime{C,T}) = convert(Date{C},x) - y
#default internal constructor
_datetime{C<:Calendar,T<:TimeZone}(x::Real,::Type{C}=CALENDAR,::Type{T}=TIMEZONE) = convert(DateTime{C,T},int64(x))
timezone{C<:Calendar,T<:TimeZone,TT<:TimeZone}(dt::DateTime{C,T},tz::Type{TT}) = _datetime(int64(dt),C,TT)
#ISO-compliant constructor; internal, overloaded for different Calendars
const _leaps = [62214393599,62230291199,62261827199,62293363199,62324899199,62356521599,62388057599,62419593599,62451129599,62498390399,62529926399,62561462399,62624620799,62703590399,62766748799,62798284799,62845545599,62877081599,62908617599,62956051199,63003311999,63050745599,63271670399,63366364799,63476697599,9223372036854775807]
const _leaps1 = [62214393600,62230291201,62261827202,62293363203,62324899204,62356521605,62388057606,62419593607,62451129608,62498390409,62529926410,62561462411,62624620812,62703590413,62766748814,62798284815,62845545616,62877081617,62908617618,62956051219,63003312020,63050745621,63271670422,63366364823,63476697624,9223372036854775807]
leaps(secs::DateTimeMath)  = (i = 1; while true; @inbounds (_leaps[i]  >= secs && break); i+=1 end; return i-1)
leaps1(secs::DateTimeMath) = (i = 1; while true; @inbounds (_leaps1[i] >= secs && break); i+=1 end; return i-1)
function datetime{T<:TimeZone}(y::PeriodMath,m::PeriodMath,d::PeriodMath,h::PeriodMath,mi::PeriodMath,s::PeriodMath,tz::Type{T}=TIMEZONE)
    secs = int(s) + 60mi + 3600h + 86400*_daynumbers(y,m,d)
    secs -= 1902 < y < 2038 ? getoffset(T,secs) : 0
    secs += y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs)
    return _datetime(secs,CALENDAR,tz) #represents Rata Die seconds since 0001/1/1:00:00:00 + any elapsed leap seconds
end
datetime(y::PeriodMath,m::PeriodMath,d::PeriodMath,h::PeriodMath,mi::PeriodMath,s::PeriodMath,tz::String) = datetime(y,m,d,h,mi,s,timezone(tz))
datetime{C<:Calendar}(d::Date{C}) = datetime(d.year,d.month,d.day,0,0,0,TIMEZONE)
unix2datetime{T<:TimeZone}(x::Real,tz::Type{T}=TIMEZONE) = (s = UNIXEPOCH + x; _datetime(s + leaps(s),CALENDAR,tz))
@vectorize_1arg Real unix2datetime
now() = unix2datetime(time())
now{T<:TimeZone}(tz::Type{T}) = unix2datetime(time(),tz)
# datetime{C<:Calendar,T<:TimeZone}(d::Date{C},t::Time{T}) = datetime(d.year,d.month,d.day,t.hour,t.minute,t.second,C,T)
#Accessors/Traits/Print/Show
function string{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})
    y,m,d,h,mi,s,tz = year(dt),month(dt),day(dt),hour(dt),minute(dt),second(dt),getabr(T,dt)
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
	z = x + 307
	h = z - .25	
	centdays = fld(h,36524.25)	
	centdays -= fld(centdays,4)
	yy = fld(centdays+h,365.25)
	c = centdays + z - itrunc(365.25*yy)
	mm = div(5*c+456,153)
	return mm > 12 ? yy+1 : yy
end
function _day2month(x::Int64)
    z = x + 307
    h = z - .25 
    centdays = fld(h,36524.25)  
    centdays -= fld(centdays,4)
    c = centdays + z - itrunc(365.25*fld(centdays+h,365.25))
    mm = div(5*c+456,153)
    return mm > 12 ? mm - 12 : mm
end
function _day2day(x::Int64)
    z = x + 307
    h = z - .25 
    centdays = fld(h,36524.25)  
    centdays -= fld(centdays,4)
    c = centdays + z - itrunc(365.25*fld(centdays+h,365.25))
    mm = div(5*c+456,153)
    return c - _monthdays(mm)
end
year{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = _day2year(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400)) #fld(t,31536000)
month{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})    = _day2month(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
day{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})      = _day2day(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
hour{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = fld((int64(dt) - leaps(dt)+getoffset(T,dt)),3600) % 24
minute{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = fld((int64(dt) - leaps(dt)+getoffset(T,dt)) % 3600, 60)
second{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = (s = ((int64(dt) - leaps1(dt)+getoffset(T,dt)) % 60); return s != 0 ? s : contains(_leaps1,dt) ? 60 : 0)
calendar{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = C
timezone{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = T

isleap{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = isleap(year(dt))
isleapday{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = isleapday(month(dt),day(dt))
lastday{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})    = lastday(year(dt),month(dt))
dayofweek{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = (fld(int64(dt),86400) + 1) % 7
dayofyear{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})  = int64(fld(int64(dt)-_yearsecs(year(dt)),86400))+1
function week{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})
	rdn = fld(int64(dt),86400)
	w = fld(rdn,7) % 20871 #20871 = # of weeks in 400 years
	c = fld((w + (w >= 10435)),5218) #need # of centuries to choose right intercept below
	w = (w + (w >= 10435)) % 5218 #5218 = # of weeks in century
	w = (w*28+(15,23,3,11)[c+1]) % 1461
	return fld(w,28) + 1
end
@vectorize_1arg DateTime isleap
@vectorize_1arg DateTime isleapday
@vectorize_1arg DateTime lastday
@vectorize_1arg DateTime dayofweek
@vectorize_1arg DateTime dayofyear
@vectorize_1arg DateTime week

_yearsecs(y) = 86400*((y-1)*365 + fld(y,4) - fld(y,100) + fld(y,400))
#DateTime-Period arithmetic: <<, >>
function (>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Year{C})
	#need to correct leap seconds
	oy = year(x)
	ny = oy + y
	oy,ny = _yearsecs(oy),_yearsecs(ny)
	return _datetime(int64(x)-oy+ny,C,T)
end
(>>){C<:Calendar,T<:TimeZone}(y::Year{C},x::DateTime{C,T}) = >>(x,y)
# (<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Year{C}) = (ny = x.year-y; return date(ny,x.month,x.day <= lastday(ny,x.month) ? x.day : lastday(ny,x.month)))
# (<<){C<:Calendar,T<:TimeZone}(y::Year{C},x::DateTime{C,T}) = -(x,y)
# function (>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Month{C}) 
# 	ny = addwrap(x.year,x.month,y)
# 	mm = addwrap(x.month,y)
# 	dd = x.day <= lastday(ny,mm) ? x.day : lastday(ny,mm)
# 	return date(ny,mm,dd)
# end
# (>>){C<:Calendar,T<:TimeZone}(y::Month{C},x::DateTime{C,T}) = x + y
# function (<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Month{C})
# 	ny = subwrap(x.year,x.month,y)
# 	mm = subwrap(x.month,y)
# 	dd = x.day <= lastday(ny,mm) ? x.day : lastday(ny,mm)
# 	return date(ny,mm,dd)
# end
# (<<){C<:Calendar,T<:TimeZone}(y::Month{C},x::DateTime{C,T}) = x - y
(>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Week{C}) = convert(DateTime{C,T},int64(x)+604800y)
(>>){C<:Calendar,T<:TimeZone}(y::Week{C},x::DateTime{C,T}) = x >> y
(<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Week{C}) = convert(DateTime{C,T},int64(x)-604800y)
(<<){C<:Calendar,T<:TimeZone}(y::Week{C},x::DateTime{C,T}) = x << y
(>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Day{C}) = convert(DateTime{C,T},int64(x)+86400y)
(>>){C<:Calendar,T<:TimeZone}(y::Day{C},x::DateTime{C,T}) = x >> y
(<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Day{C}) = convert(DateTime{C,T},int64(x)-86400y)
(<<){C<:Calendar,T<:TimeZone}(y::Day{C},x::DateTime{C,T}) = x << y
(>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Hour{C}) = convert(DateTime{C,T},int64(x)+3600y)
(>>){C<:Calendar,T<:TimeZone}(y::Hour{C},x::DateTime{C,T}) = x >> y
(<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Hour{C}) = convert(DateTime{C,T},int64(x)-3600y)
(<<){C<:Calendar,T<:TimeZone}(y::Hour{C},x::DateTime{C,T}) = x << y
(>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Minute{C}) = convert(DateTime{C,T},int64(x)+60y)
(>>){C<:Calendar,T<:TimeZone}(y::Minute{C},x::DateTime{C,T}) = x >> y
(<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Minute{C}) = convert(DateTime{C,T},int64(x)-60y)
(<<){C<:Calendar,T<:TimeZone}(y::Minute{C},x::DateTime{C,T}) = x << y
(>>){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)+y)
(>>){C<:Calendar,T<:TimeZone}(y::Second{C},x::DateTime{C,T}) = x >> y
(<<){C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)-y)
(<<){C<:Calendar,T<:TimeZone}(y::Second{C},x::DateTime{C,T}) = x << y
# typealias DatePeriodDate Union(DatePeriod,Date)
# @vectorize_2arg DatePeriodDate (<<)
# @vectorize_2arg DatePeriodDate (>>)

end #module
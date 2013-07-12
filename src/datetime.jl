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
CALENDAR = ISOCalendar
setcalendar{C<:Calendar}(cal::Type{C}) = (global CALENDAR = cal)

abstract TimeZone <: AbstractTime
include("timezone.jl")
#Set the default timezone to use; overriding this will affect module-wide defaults
#typealias UTC Zone0
TIMEZONE = UTC
settimezone{T<:TimeZone}(tz::Type{T}) = (global TIMEZONE = tz)

abstract TimeType <: AbstractTime
#bitstype 64 Date{C <: Calendar}					<: TimeType
#bitstype 64 Time{C <: Calendar}			 		<: TimeType
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
for period in (Year,Month,Week,Day,Hour,Minute,Second)
	@eval convert(::Type{$period},x::Int32) = convert($period{CALENDAR},int32(x))
end
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
print(io::IO,x::Period) = print(io,int32(x))
show(io::IO,x::Period) = print(io,int32(x))
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
addwrap(x::Int64,y::Int64) = (v = (x + y)      % 12; return v == 0 ? 12 : v)
subwrap(x::Int64,y::Int64) = (v = (x - y + 12) % 12; return v == 0 ? 12 : v)
addwrap(x::Int64,y::Int64,z::Int64) = x + (y + z > 12 ? max(1, fld(z,12)) : 0)
subwrap(x::Int64,y::Int64,z::Int64) = x - (y - z < 1  ? max(1, fld(z,12)) : 0)

#Date bitstype parameterized by Calendar; timezone independent (no hours,minutes,seconds)
bitstype 64 Date{C <: Calendar}	<: TimeType

#bits functions
convert{C<:Calendar}(::Type{Date{C}},x::Int64) = Base.box(Date{C},Base.unbox(Int64,x))
convert{C<:Calendar}(::Type{Int64},x::Date{C}) = Base.box(Int64,Base.unbox(Date{C},x))
convert{C<:Calendar}(::Type{Date{C}},x::Real) = convert(Date{C},int64(x))
convert{C<:Calendar,R<:Real}(::Type{R}, x::Date{C}) = convert(R,int64(x))
convert(::Type{Date},x::Real) = convert(Date{CALENDAR},int64(x))
promote_rule{C<:Calendar,R<:Real}(::Type{Date{C}},::Type{R}) = R
isless{C<:Calendar}(x::Date{C},y::Date{C}) = isless(int64(x),int64(y))
isequal{C<:Calendar}(x::Date{C},y::Date{C}) = isequal(int64(x),int64(y))
#Internal constructor
_date{C<:Calendar}(x::Int64,::Type{C}=CALENDAR) = convert(Date{C},x)

#ISO-compliant constructor
const DAYSINMONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
lastday(y::Int64,m::Int64) = DAYSINMONTH[m] + (m == 2 && (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)))
_yeardays(y::Int64) = 365y + fld(y,4) - fld(y,100) + fld(y,400)
const MONTHDAYS = [306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275]
_daynumbers(y::Int64,m::Int64,d::Int64) = d + MONTHDAYS[m] + _yeardays(m<3 ? y-1 : y) - 307
date(y::Int64,m::Int64,d::Int64,cal::Type{ISOCalendar}=ISOCalendar) = _date(_daynumbers(y,m,d),cal)
#Default constructor
date(y::DateMath=1,m::DateMath=1,d::DateMath=1,cal=CALENDAR) = date(int64(y),int64(m),int64(d),cal)
#date(s::String)? ymd family?

function _year(dt::Int64)
	z = dt + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); return m > 12 ? y+1 : y	
end
function _month(dt::Int64)
	z = dt + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); return m > 12 ? m-12 : m
end
function _week(dt::Int64)
	w = fld(dt,7) % 20871 #20871 = # of weeks in 400 years
	c = fld((w + (w >= 10435)),5218) #need # of centuries to choose right intercept below
	w = (w + (w >= 10435)) % 5218 #5218 = # of weeks in century
	w = (w*28+(15,23,3,11)[c+1]) % 1461
	return fld(w,28) + 1
end
function _day(dt::Int64)
	z = dt + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); d = c - div(153m-457,5); return d
end
function _day2date(dt::Date)
	z = int64(dt) + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); d = c - div(153m-457,5); return m > 12 ? (y+1,m-12,d) : (y,m,d)
end
year(dt::Date) = _year(int64(dt))
month(dt::Date) = _month(int64(dt))
day(dt::Date) = _day(int64(dt))
#Print/show/traits; add + for years > 4 digits = ISO standard
function string(dt::Date)
	y,m,d = _day2date(dt)
	y = y == 0 ? "" : @sprintf("%04d",y)
	m = y == 0 ? @sprintf("%02d",m) : "-" * @sprintf("%02d",m)
	d = d == 0 ? "" : "-" * @sprintf("%02d",d)
	return string(y,m,d)
end
print(dt::Date) = print(string(dt))
show(io::IO,dt::Date) = print(io,string(dt))
#format()
typemax{C<:Calendar}(::Type{Date{C}}) = date(100000000000000,12,31)
typemin{C<:Calendar}(::Type{Date{C}}) = date(-100000000000000,1,1)
hash(dt::Date) = hash(int64(dt))
length(::Date) = 1
isdate(n) = typeof(n) <: Date
calendar{C<:Calendar}(dt::Date{C}) = C

#ISO implementation of generic date functions
#Most are generic, but the _day2date algorithm comes from Peter Baum
#http://mysite.verizon.net/aesir_research/date/date0.htm
#Based on the ISO standard, which uses the proleptic Gregorian calendar
#which is the normal one everyone thinks of applied retroactively
#(though it was officially accepted in 1582 when they had to fast-forward 11 days)
isleap(dt::Date) = (y = year(dt); (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)))
lastday(dt::Date) = lastday(year(dt),month(dt))
dayofweek(dt::Date) = int64(dt) % 7 + 1
#dayofweekofmonth(dt::Date) = 
dayofyear(dt::Date) = int64(dt) - _daynumbers(year(dt),1,1) + 1
week(dt::Date) = _week(int64(dt))
@vectorize_1arg Date isleap
@vectorize_1arg Date lastday
@vectorize_1arg Date dayofweek
#@vectorize_1arg Date dayofweekofmonth
@vectorize_1arg Date dayofyear
@vectorize_1arg Date week

#Date-Date operations: +, *, and / are meaningless; (-) return duration in days
(-){C<:Calendar}(x::Date{C},y::Date{C}) = days(-(int64(x),int64(y)))
(+)(x::Date) = x
(-)(x::Date) = date(-int64(year(x)),month(x),day(x))
for op in (:+,:*,:/)
    @eval ($op)(x::Date,y::Date) = Base.no_op_err($op,"Date")
end
for op in (:*,:/,:<,:>), period in (Hour,Minute,Second)
	@eval ($op)(x::Date,y::$period) = Base.no_op_err($op,"Date-$period")
end
function (+){C<:Calendar}(dt::Date{C},y::Year{C})
	oy,m,d = _day2date(dt); ny = oy+int64(y); ld = lastday(ny,m)
	return date(ny,m,d <= ld ? d : ld,C)
end
(+){C<:Calendar}(y::Year{C},x::Date{C}) = +(x,y)
function (-){C<:Calendar}(dt::Date{C},y::Year{C})
	oy,m,d = _day2date(dt); ny = oy-int64(y); ld = lastday(ny,m)
	return date(ny,m,d <= ld ? d : ld,C)
end
(-){C<:Calendar}(y::Year{C},x::Date{C}) = -(x,y)
function (+){C<:Calendar}(dt::Date{C},z::Month{C}) 
	y,m,d = _day2date(dt)
	ny = addwrap(y,m,int64(z))
	mm = addwrap(m,int64(z)); ld = lastday(ny,mm)
	return date(ny,mm,d <= ld ? d : ld)
end
(+){C<:Calendar}(y::Month{C},x::Date{C}) = x + y
function (-){C<:Calendar}(dt::Date{C},z::Month{C})
	y,m,d = _day2date(dt)
	ny = subwrap(y,m,int64(z))
	mm = subwrap(m,int64(z)); ld = lastday(ny,mm)
	return date(ny,mm,d <= ld ? d : ld)
end
(-){C<:Calendar}(y::Month{C},x::Date{C}) = x - y
(+){C<:Calendar}(x::Date{C},y::Week{C}) = _date(int64(x) + 7y,C)
(+){C<:Calendar}(y::Week{C},x::Date{C}) = x + y
(-){C<:Calendar}(x::Date{C},y::Week{C}) = _date(int64(x) - 7y,C)
(-){C<:Calendar}(y::Week{C},x::Date{C}) = x - y
(+){C<:Calendar}(x::Date{C},y::Day{C})  = _date(int64(x) + y,C)
(+){C<:Calendar}(y::Day{C},x::Date{C})  = x + y
(-){C<:Calendar}(x::Date{C},y::Day{C})  = _date(int64(x) - y,C)
(-){C<:Calendar}(y::Day{C},x::Date{C})  = x - y

typealias DatePeriodDate Union(DatePeriod,Date)
@vectorize_2arg DatePeriodDate (-)
@vectorize_2arg DatePeriodDate (+)

#Date ranges: start date, end date, period as step; for creating frequencies
# immutable DateRange1{C<:Calendar} <: Ranges{Date{C}}
# 	start::Date{C}
# 	step::DatePeriod
# 	len::Int
# end
# size(r::DateRange1) = (r.len,)
# length(r::DateRange1) = r.len
# step(r::DateRange1)  = r.step
# start(r::DateRange1) = 0
# first(r::DateRange1) = r.start
# last(r::DateRange1) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
# next(r::DateRange1, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
# done(r::DateRange1, i) = length(r) <= i
# _units(x::Period) = lowercase(string(typeof(x).name)) * "s($(string(x)))"
# function show{C<:Calendar}(io::IO,r::DateRange1{C})
# 	print(io, r.start, ':', _units(r.step), ':', last(r))
# end
# colon{C<:Calendar}(t1::Date{C}, y::Year{C}, t2::Date{C}) = DateRange1{C}(t1, y, int(fld((t2.year - t1.year),y) + 1) )
# colon{C<:Calendar}(t1::Date{C}, m::Month{C}, t2::Date{C}) = DateRange1{C}(t1, m, int(fld(int(t2.year-t1.year)*12+int(t2.month-t1.month),m) + 1) )
# colon{C<:Calendar}(t1::Date{C}, w::Week{C}, t2::Date{C}) = DateRange1{C}(t1, w, int(fld(_daynumbers(t2)-_daynumbers(t1),days(w)) + 1) )
# colon{C<:Calendar}(t1::Date{C}, d::Day{C}, t2::Date{C}) = DateRange1{C}(t1, d, int(fld(_daynumbers(t2)-_daynumbers(t1),d) + 1) )
# (+){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start+p,r.step,r.len)
# (-){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start-p,r.step,r.len)

#DateTime type
bitstype 64 DateTime{C <: Calendar,T <: TimeZone} <: TimeType
typealias DateTimeMath Union(DateTime,Real)
typealias DateTimeDate Union(DateTime,Date)

#bits functions
convert{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},x::Int64) = Base.box(DateTime{C,T},Base.unbox(Int64,x))
convert{C<:Calendar,T<:TimeZone}(::Type{Int64},x::DateTime{C,T}) = Base.box(Int64,Base.unbox(DateTime{C,T},x))
convert{C<:Calendar,T<:TimeZone,R<:Real}(::Type{R}, x::DateTime{C,T}) = convert(R,int64(x))
convert(::Type{DateTime},x::Int64) = convert(DateTime{CALENDAR,TIMEZONE},x)
convert{C<:Calendar}(::Type{DateTime},d::Date{C}) = datetime(year(d),month(d),day(d),0,0,0,TIMEZONE)
convert{C<:Calendar,T<:TimeZone}(::Type{Date{C}},d::DateTime{C,T}) = date(year(d),month(d),day(d))
promote_rule{C<:Calendar,T<:TimeZone,R<:Real}(::Type{DateTime{C,T}},::Type{R}) = R
promote_rule{C<:Calendar,T<:TimeZone,TT<:TimeZone}(::Type{DateTime{C,T}},::Type{DateTime{C,TT}}) = DateTime{C,Zone0} #does this work?
convert{C<:Calendar,T<:TimeZone,TT<:TimeZone}(::Type{DateTime{C,T}},x::DateTime{C,TT}) = _datetime(int64(x),C,T)
promote_rule{C<:Calendar,T<:TimeZone}(::Type{DateTime{C,T}},::Type{Date{C}}) = Date{C}
isless{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isless(int64(x),int64(y))
isequal{C<:Calendar,T<:TimeZone}(x::DateTime{C,T},y::DateTime{C,T}) = isequal(int64(x),int64(y))
isless(x::DateTime,y::Real) = isless(int64(x),int64(y))
isless(x::Real,y::DateTime) = isless(int64(x),int64(y))
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
_datetime{C<:Calendar,T<:TimeZone}(x::Int64,::Type{C}=CALENDAR,::Type{T}=TIMEZONE) = convert(DateTime{C,T},x)
timezone{C<:Calendar,T<:TimeZone,TT<:TimeZone}(dt::DateTime{C,T},tz::Type{TT}) = _datetime(int64(dt),C,TT)
timezone{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T},tz::String) = timezone(dt,timezone(tz))
#ISO-compliant constructor; internal, overloaded for different Calendars
const _leaps = [62214393599,62230291199,62261827199,62293363199,62324899199,62356521599,62388057599,62419593599,62451129599,62498390399,62529926399,62561462399,62624620799,62703590399,62766748799,62798284799,62845545599,62877081599,62908617599,62956051199,63003311999,63050745599,63271670399,63366364799,63476697599,9223372036854775807]
const _leaps1 = [62214393600,62230291201,62261827202,62293363203,62324899204,62356521605,62388057606,62419593607,62451129608,62498390409,62529926410,62561462411,62624620812,62703590413,62766748814,62798284815,62845545616,62877081617,62908617618,62956051219,63003312020,63050745621,63271670422,63366364823,63476697624,9223372036854775807]
leaps(secs::DateTimeMath)  = (i = 1; while true; @inbounds (_leaps[i]  >= secs && break); i+=1 end; return i-1)
leaps1(secs::DateTimeMath) = (i = 1; while true; @inbounds (_leaps1[i] >= secs && break); i+=1 end; return i-1)
function datetime{T<:TimeZone}(y::Int64,m::Int64,d::Int64,h::Int64,mi::Int64,s::Int64,tz::Type{T}=TIMEZONE)
    secs = s + 60mi + 3600h + 86400*_daynumbers(y,m,d)
    secs -= 1902 < y < 2038 ? setoffset(T,secs) : get(OFFSETS,T,0)
    secs += y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs)
    return _datetime(secs,CALENDAR,tz) #represents Rata Die seconds since 0001/1/1:00:00:00 + any elapsed leap seconds
end
datetime{T<:TimeZone}(y::PeriodMath,m::PeriodMath,d::PeriodMath,h::PeriodMath,mi::PeriodMath,s::PeriodMath,tz::Type{T}) = datetime(y,m,d,h,mi,s,tz)
datetime(y::PeriodMath,m::PeriodMath,d::PeriodMath,h::PeriodMath,mi::PeriodMath,s::PeriodMath,tz::String) = datetime(y,m,d,h,mi,s,timezone(tz))
datetime{C<:Calendar}(d::Date{C}) = datetime(d.year,d.month,d.day,0,0,0,TIMEZONE)
date(x::DateTime) = date(year(x),month(x),day(x))
unix2datetime{T<:TimeZone}(x::Int64,tz::Type{T}=TIMEZONE) = (s = UNIXEPOCH + x; _datetime(s + leaps(s),CALENDAR,tz))
@vectorize_1arg Real unix2datetime
now() = unix2datetime(int64(time()))
now{T<:TimeZone}(tz::Type{T}) = unix2datetime(int64(time()),tz)
# datetime{C<:Calendar,T<:TimeZone}(d::Date{C},t::Time{T}) = datetime(d.year,d.month,d.day,t.hour,t.minute,t.second,C,T)
#Accessors/Traits/Print/Show
function string{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})
    y,m,d,h,mi,s = year(dt),month(dt),day(dt),hour(dt),minute(dt),second(dt)
    tz = 1902 < y < 2038 ? getabr(T,dt) : get(ABBREVIATIONS,T,"UTC")
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
#Accessor/generics
year{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = _year(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
month{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})    = _month(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
day{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})      = _day(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
hour{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})     = fld((int64(dt)-leaps(dt)+getoffset(T,dt)),3600) % 24
minute{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = fld((int64(dt)-leaps(dt)+getoffset(T,dt)) % 3600, 60)
second{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T})   = (s = ((int64(dt)-leaps1(dt)+getoffset(T,dt)) % 60); return s != 0 ? s : contains(_leaps1,dt) ? 60 : 0)
calendar{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = C
timezone{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = T
isleap(dt::DateTime)     = isleap(year(dt))
lastday(dt::DateTime)    = lastday(year(dt),month(dt))
dayofweek(dt::DateTime)  = (fld(int64(dt),86400) + 1) % 7
dayofyear(dt::DateTime)  = fld(int64(dt)-_yearsecs(year(dt)),86400)+1
week{C<:Calendar,T<:TimeZone}(dt::DateTime{C,T}) = _week(fld(int64(dt)-leaps(dt)+getoffset(T,dt),86400))
@vectorize_1arg DateTime isleap
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

# #Date ranges: start date, end date, period as step; for creating frequencies
# immutable DateTimeRange1{C<:Calendar,T<:TimeZone} <: Ranges{DateTime{C,T}}
# 	start::DateTime{C,T}
# 	step::Period
# 	len::Int
# end
# size(r::DateTimeRange1) = (r.len,)
# length(r::DateTimeRange1) = r.len
# step(r::DateTimeRange1)  = r.step
# start(r::DateTimeRange1) = 0
# first(r::DateTimeRange1) = r.start
# last(r::DateTimeRange1) = r.start >> convert(typeof(r.step),(r.len-1)*r.step)
# next(r::DateTimeRange1, i) = (r.start >> convert(typeof(r.step),i*r.step), i+1)
# done(r::DateTimeRange1, i) = length(r) <= i
# _units(x::Period) = lowercase(string(typeof(x).name)) * "s($(string(x)))"
# function show{C<:Calendar,T<:TimeZone}(io::IO,r::DateTimeRange1{C,T})
# 	print(io, r.start, ':', _units(r.step), ':', last(r))
# end
# colon{C<:Calendar,T<:TimeZone}(t1::DateTime{C,T}, y::Year{C}, t2::DateTime{C,T}) = DateTimeRange1{C,T}(t1, y, int(fld((year(t2) - year(t1)),y) + 1) )
# colon{C<:Calendar,T<:TimeZone}(t1::DateTime{C,T}, m::Month{C}, t2::DateTime{C,T}) = DateTimeRange1{C,T}(t1, m, int(fld(int(year(t2) - year(t1))*12+int(month(t2)-month(t1)),m) + 1) )
# # colon{C<:Calendar,T<:TimeZone}(t1::DateTime{C,T}, w::Week{C}, t2::DateTime{C,T}) = DateTimeRange1{C,T}(t1, w, int(fld(_daynumbers(t2)-_daynumbers(t1),days(w)) + 1) )
# # colon{C<:Calendar,T<:TimeZone}(t1::DateTime{C,T}, d::Day{C}, t2::DateTime{C,T}) = DateTimeRange1{C,T}(t1, d, int(fld(_daynumbers(t2)-_daynumbers(t1),d) + 1) )
# (+){C<:Calendar,T<:TimeZone}(r::DateTimeRange1{C,T},p::Period) = DateTimeRange1{C,T}(r.start+p,r.step,r.len)
# (-){C<:Calendar,T<:TimeZone}(r::DateTimeRange1{C,T},p::Period) = DateTimeRange1{C,T}(r.start-p,r.step,r.len)

end #module
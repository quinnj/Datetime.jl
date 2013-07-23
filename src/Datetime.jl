module Datetime

importall Base

export Calendar, ISOCalendar, Offsets, TimeZone, Offset, CALENDAR, OFFSET, Period,
	Date, DateTime, DateRange, DateRange1, DateTimeRange, DateTimeRange1,
    Year, Month, Week, Day, Hour, Minute, Second,
    year, month, week, day, hour, minute, second,
    years,months,weeks,days,hours,minutes,seconds,
    addwrap, subwrap, date, datetime, unix2datetime, totaldays,
    isleap, lastdayofmonth, dayofweek, dayofyear, isdate, isdatetime,
    dayofweekinmonth, daysofweekinmonth, firstdayofweek, lastdayofweek,
    recur, now, today, calendar, timezone, setcalendar, settimezone,
    Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday,
    January, February, March, April, May, June, July,
    August, September, October, November, December

abstract AbstractTime
abstract Calendar <: AbstractTime
abstract ISOCalendar <: Calendar
#Set the default calendar to use; overriding this will affect module-wide defaults
CALENDAR = ISOCalendar
setcalendar{C<:Calendar}(cal::Type{C}) = (global CALENDAR = cal)

abstract Offsets <: AbstractTime
abstract Offset{n} <: Offsets
abstract TimeZone <: Offsets
include("Timezone.jl")
#Set the default timezone to use; overriding this will affect module-wide defaults
OFFSET = UTC
settimezone{T<:Offsets}(tz::Type{T}) = (global OFFSET = tz)

abstract TimeType <: AbstractTime
bitstype 64 Date{C <: Calendar}						<: TimeType
bitstype 64 DateTime{C <: Calendar, T <: Offsets} 	<: TimeType

abstract Period 	<: AbstractTime
abstract DatePeriod <: Period
abstract TimePeriod <: Period
typealias PeriodMath   Union(Real,Period)

bitstype 32 Year{C<:Calendar}   <: DatePeriod
bitstype 32 Month{C<:Calendar}  <: DatePeriod
bitstype 32 Week{C<:Calendar}   <: DatePeriod
bitstype 32 Day{C<:Calendar}    <: DatePeriod
bitstype 32 Hour{C<:Calendar}   <: TimePeriod
bitstype 32 Minute{C<:Calendar} <: TimePeriod
bitstype 32 Second{C<:Calendar} <: TimePeriod

#Conversion/Promotion
convert{T<:TimeType}(::Type{T},x::Int64) = Base.box(T,Base.unbox(Int64,x))
convert{T<:TimeType}(::Type{Int64},x::T) = Base.box(Int64,Base.unbox(T,x))
promote_rule{T<:TimeType,R<:Real}(::Type{T},::Type{R}) = R
convert{T<:TimeType}(::Type{T},x::Real) = convert(T,int64(x))
convert{R<:Real}(::Type{R}, x::TimeType) = convert(R,int64(x))
convert(::Type{Date},x::Int64) = convert(Date{CALENDAR},x)
promote_rule{D<:Date}(::Type{D},::Type{D}) = D{CALENDAR}
convert{D<:Date}(::Type{Date{ISOCalendar}},x::D) = convert(Date{ISOCalendar},int64(x))
convert(::Type{DateTime},x::Int64) = convert(DateTime{CALENDAR,OFFSET},x)
promote_rule{D<:DateTime}(::Type{D},::Type{D}) = D{CALENDAR,UTC}
convert{D<:DateTime}(::Type{DateTime{ISOCalendar,UTC}},x::D) = convert(DateTime{ISOCalendar,UTC},int64(x))
promote_rule{D<:Date,DD<:DateTime}(::Type{D},::Type{DD}) = D{CALENDAR}
convert{D<:DateTime}(::Type{Date},x::D) = convert(Date{CALENDAR},_days(x))
convert{D<:Date}(::Type{DateTime},x::D) = convert(DateTime{CALENDAR,OFFSET},86400000000*x)
hash(x::TimeType) = hash(int64(x))
length(::TimeType) = 1
isless{T<:TimeType}(x::T,y::T) = isless(int64(x),int64(y))
isless(x::TimeType,y::TimeType) = isless(promote(x,y)...)
isless(x::TimeType,y::Real) = isless(int64(x),int64(y))
isless(x::Real,y::TimeType) = isless(int64(x),int64(y))
isequal{T<:TimeType}(x::T,y::T) = isequal(int64(x),int64(y))
isequal(x::TimeType,y::Real) = isequal(int64(x),int64(y))
isequal(x::Real,y::TimeType) = isequal(int64(x),int64(y))
isequal(x::TimeType,y::TimeType) = isequal(promote(x,y)...)

#Date algorithm implementations
#Source: Peter Baum - http://mysite.verizon.net/aesir_research/date/date0.htm
#Convert y,m,d to # of Rata Die days
yeardays(y::Int64) = 365y + fld(y,4) - fld(y,100) + fld(y,400)
const monthdays = [306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275]
totaldays(y::Int64,m::Int64,d::Int64) = d + monthdays[m] + yeardays(m<3 ? y-1 : y) - 307
#Convert # of Rata Die days to proleptic Gregorian calendar y,m,d,w
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
function _day(dt::Int64)
	z = dt + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); d = c - div(153m-457,5); return d
end
function _day2date(dt::Int64)
	z = dt + 307; h = 100z - 25;	a = fld(h,3652425)
	b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
	m = div(5c+456,153); d = c - div(153m-457,5); return m > 12 ? (y+1,m-12,d) : (y,m,d)
end
function _week(dt::Int64)
	w = fld(dt,7) % 20871
	c = fld((w + (w >= 10435)),5218)
	w = (w + (w >= 10435)) % 5218
	w = (w*28+(15,23,3,11)[c+1]) % 1461
	return fld(w,28) + 1
end
const DAYSINMONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
isleap(y::Int64) = ((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)
lastdayofmonth(y::Int64,m::Int64) = DAYSINMONTH[m] + (m == 2 && isleap(y))

#TimeType constructors
setoffset(tz::Type{UTC},secs,y,s) = 0 - (y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs))
getoffset(tz::Type{UTC},secs) = 0 - leaps(secs)
getoffset_secs(tz::Type{UTC},secs) = 0 - leaps1(secs)
getabr(tz::Type{UTC},secs,y) = "UTC"
#DateTime constructor with timezone and/or leap seconds
const _leaps = [62214393599000000,62230291199000000,62261827199000000,62293363199000000,62324899199000000,62356521599000000,62388057599000000,62419593599000000,62451129599000000,62498390399000000,62529926399000000,62561462399000000,62624620799000000,62703590399000000,62766748799000000,62798284799000000,62845545599000000,62877081599000000,62908617599000000,62956051199000000,63003311999000000,63050745599000000,63271670399000000,63366364799000000,63476697599000000,9223372036854775807]
const _leaps1 = [62214393600000000,62230291201000000,62261827202000000,62293363203000000,62324899204000000,62356521605000000,62388057606000000,62419593607000000,62451129608000000,62498390409000000,62529926410000000,62561462411000000,62624620812000000,62703590413000000,62766748814000000,62798284815000000,62845545616000000,62877081617000000,62908617618000000,62956051219000000,63003312020000000,63050745621000000,63271670422000000,63366364823000000,63476697624000000,9223372036854775807]
leaps(secs::Union(DateTime,Int64))  = (i = 1; while true; @inbounds (_leaps[i]  >= secs && break); i+=1 end; return 1000000*(i-1))
leaps1(secs::Union(DateTime,Int64)) = (i = 1; while true; @inbounds (_leaps1[i] >= secs && break); i+=1 end; return 1000000*(i-1))

date{C<:Calendar}(y::Int64,m::Int64=1,d::Int64=1,cal::Type{C}=CALENDAR) = convert(Date{cal},totaldays(y,m,d))
date{C<:Calendar}(y::PeriodMath,m::PeriodMath=1,d::PeriodMath=1,cal::Type{C}=CALENDAR) = date(int64(y),int64(m),int64(d),cal)
datetime{C<:Calendar,T<:Offsets}(y::Int64,m::Int64=1,d::Int64=1,h::Int64=0,mi::Int64=0,s::Int64=0,tz::Type{T}=OFFSET,cal::Type{C}=CALENDAR) = 
	(secs = 1000000*(s + 60mi + 3600h + 86400*totaldays(y,m,d)); return convert(DateTime{cal,tz}, secs - setoffset(tz,secs,y,s)))
datetime{C<:Calendar,T<:Offsets}(y::PeriodMath,m::PeriodMath=1,d::PeriodMath=1,h::PeriodMath=0,mi::PeriodMath=0,s::PeriodMath=0,cal::Type{C}=CALENDAR,tz::Type{T}=OFFSET) = 
	datetime(int64(y),int64(m),int64(d),int64(h),int64(mi),int64(s),tz,cal)
datetime(y::Int64,m::Int64,d::Int64,h::Int64,mi::Int64,s::Int64,tz::String) = datetime(y,m,d,h,mi,s,CALENDAR,timezone(tz))

#Accessor/trait functions
typealias DateTimeDate Union(DateTime,Date)
_days(dt::Date) = int64(dt)
_days{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = fld(int64(dt)+getoffset(T,dt),86400000000)
year(dt::DateTimeDate) = _year(_days(dt))
month(dt::DateTimeDate) = _month(_days(dt))
week(dt::DateTimeDate) = _week(_days(dt))
day(dt::DateTimeDate) = _day(_days(dt))
hour{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})     = fld(int64(dt)+getoffset(T,dt),3600000000) % 24
minute{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})   = fld(int64(dt)+getoffset(T,dt),60000000) % 60
second{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})   = (s = fld(int64(dt)+getoffset_secs(T,dt),1000000) % 60; return s != 0 ? s : contains(_leaps1,dt) ? 60 : 0)
calendar{C<:Calendar}(dt::Date{C}) = C
typemax{D<:Date}(::Type{D}) = date(252522163911149,12,31)
typemin{D<:Date}(::Type{D}) = date(-252522163911150,1,1)
isdate(n) = typeof(n) <: Date
calendar{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = C
timezone{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = T
typemax{D<:DateTime}(::Type{D}) = datetime(292277,12,31,23,59,59)
typemin{D<:DateTime}(::Type{D}) = datetime(-292276,1,1,0,0,0)
isdatetime(x) = typeof(x) <: DateTime
#Functions to work with timezones
convert{C<:Calendar,T<:Offsets,TT<:Offsets}(::Type{DateTime{C,T}},x::DateTime{C,TT}) = convert(DateTime{C,TT},int64(x))
timezone{C<:Calendar,T<:Offsets,TT<:Offsets}(dt::DateTime{C,T},tz::Type{TT}) = convert(DateTime{C,TT},int64(dt))
timezone(x::String) = get(TIMEZONES,x,Zone0)
timezone(dt::DateTime,tz::String) = timezone(dt,timezone(tz))

#String/print/show
function string(dt::Date)
	y,m,d = _day2date(_days(dt))
	y = y == 0 ? "" : @sprintf("%04d",y)
	m = y == 0 ? @sprintf("%02d",m) : "-" * @sprintf("%02d",m)
	d = d == 0 ? "" : "-" * @sprintf("%02d",d)
	return string(y,m,d)
end
function string{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})
    y,m,d = _day2date(_days(dt))
    h,mi,s = hour(dt),minute(dt),second(dt)
    yy =  @sprintf("%04d",y)   * "-"
    m =  @sprintf("%02d",m)   * "-"
    d =  @sprintf("%02d",d)   * "T"
    h =  @sprintf("%02d",h)   * ":"
   mi =  @sprintf("%02d",mi)  * ":" 
    s =  @sprintf("%02d",s)	  * " " * getabr(T,dt,y)
    return string(yy,m,d,h,mi,s)
end
print(io::IO,x::TimeType) = print(io,string(x))
show(io::IO,x::TimeType) = print(io,string(x))

#Generic date functions
isleap(dt::DateTimeDate) = isleap(year(dt))
lastdayofmonth(dt::DateTimeDate) = lastdayofmonth(year(dt),month(dt))
dayofweek(dt::DateTimeDate) = (_days(dt) % 7) + 1
dayofweekinmonth(dt::DateTimeDate) = (d = day(dt); return d < 8 ? 1 : d < 15 ? 2 : d < 22 ? 3 : d < 29 ? 4 : 5)
function daysofweekinmonth(dt::DateTimeDate)
	d,ld = day(dt),lastdayofmonth(dt)
	return ld == 28 ? 4 : ld == 29 ? (contains((1,8,15,22,29),d) ? 5 : 4) :
		   ld == 30 ? (contains((1,2,8,9,15,16,22,23,29,30),d) ? 5 : 4) :
		   contains((1,2,3,8,9,10,15,16,17,22,23,24,29,30,31),d) ? 5 : 4
end
firstdayofweek{C<:Calendar}(dt::Date{C}) = (d = dayofweek(dt); return convert(Date{C},int64(dt) - d + 1))
firstdayofweek{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = (d = dayofweek(dt); return convert(DateTime{C,T},int64(dt) - 86400000000*(d - 1)))
lastdayofweek{C<:Calendar}(dt::Date{C}) = (d = dayofweek(dt); return convert(Date{C},int64(dt) + (7-d)))
lastdayofweek{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = (d = dayofweek(dt); return convert(DateTime{C,T},int64(dt) + 86400000000*(7-d)))
dayofyear(dt::DateTimeDate) = _days(dt) - totaldays(year(dt),1,1) + 1
@vectorize_1arg DateTimeDate isleap
@vectorize_1arg DateTimeDate lastdayofmonth
@vectorize_1arg DateTimeDate dayofweek
@vectorize_1arg DateTimeDate dayofweekinmonth
@vectorize_1arg DateTimeDate daysofweekinmonth
@vectorize_1arg DateTimeDate firstdayofweek
@vectorize_1arg DateTimeDate lastdayofweek
@vectorize_1arg DateTimeDate dayofyear

#TimeType-specific functions (now, unix2datetime, today)
const UNIXEPOCH = 62135596800000000 #Rata Die microseconds for 1970-01-01T00:00:00 UTC
unix2datetime{T<:Offsets}(x::Int64,tz::Type{T}) = convert(DateTime{CALENDAR,tz},UNIXEPOCH + x + leaps(UNIXEPOCH + x))
now() = unix2datetime(1000000*int64(time()),OFFSET)
now{T<:Offsets}(tz::Type{T}) = unix2datetime(1000000*int64(time()),tz)
today() = convert(Date{CALENDAR}, _days(1000000*int64(time()) + UNIXEPOCH))

#TimeType arithmetic
(+)(x::TimeType) = x
(-)(x::Date) = date(-int64(year(x)),month(x),day(x))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T}) = datetime(-year(x),month(x),day(x),hour(x),minute(x),second(x))
for op in (:+,:*,:/)
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = Base.no_op_err($op,"Date/DateTime")
end
(-){C<:Calendar}(x::Date{C},y::Date{C}) = days(-(int64(x),int64(y)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::DateTime{C,T}) = seconds(-(int64(x),int64(y)))
(-)(x::DateTimeDate,y::DateTimeDate) = (-)(promote(x,y)...)
#years
function (+){C<:Calendar}(dt::Date{C},y::Year{C})
	oy,m,d = _day2date(_days(dt)); ny = oy+int64(y); ld = lastdayofmonth(ny,m)
	return date(ny,m,d <= ld ? d : ld,C)
end
function (-){C<:Calendar}(dt::Date{C},y::Year{C})
	oy,m,d = _day2date(_days(dt)); ny = oy-int64(y); ld = lastdayofmonth(ny,m)
	return date(ny,m,d <= ld ? d : ld,C)
end
function (+){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},y::Year{C})
	oy,m,d = _day2date(_days(dt)); ny = oy+int64(y); ld = lastdayofmonth(ny,m)
	return datetime(ny,m,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
function (-){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},y::Year{C})
	oy,m,d = _day2date(_days(dt)); ny = oy-int64(y); ld = lastdayofmonth(ny,m)
	return datetime(ny,m,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
#months
function (+){C<:Calendar}(dt::Date{C},z::Month{C})
	z < 0 && return dt - -z
	y,m,d = _day2date(_days(dt))
	ny = addwrap(y,m,int64(z))
	mm = addwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
	return date(ny,mm,d <= ld ? d : ld)
end
function (-){C<:Calendar}(dt::Date{C},z::Month{C})
	z < 0 && return dt + -z
	y,m,d = _day2date(_days(dt))
	ny = subwrap(y,m,int64(z))
	mm = subwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
	return date(ny,mm,d <= ld ? d : ld)
end
function (+){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},z::Month{C})
	z < 0 && return dt - -z
	y,m,d = _day2date(_days(dt))
	ny = addwrap(y,m,int64(z))
	mm = addwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
	return datetime(ny,mm,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
function (-){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},z::Month{C})
	z < 0 && return dt + -z
	y,m,d = _day2date(_days(dt))
	ny = subwrap(y,m,int64(z))
	mm = subwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
	return datetime(ny,mm,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
#weeks,days,hours,minutes,seconds
(+){C<:Calendar}(x::Date{C},y::Week{C}) = convert(Date{C},(int64(x) + 7y))
(-){C<:Calendar}(x::Date{C},y::Week{C}) = convert(Date{C},(int64(x) - 7y))
(+){C<:Calendar}(x::Date{C},y::Day{C})  = convert(Date{C},(int64(x) + y))
(-){C<:Calendar}(x::Date{C},y::Day{C})  = convert(Date{C},(int64(x) - y))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Week{C}) = convert(DateTime{C,T},int64(x)+604800000000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Week{C}) = convert(DateTime{C,T},int64(x)-604800000000*int64(y))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Day{C}) = convert(DateTime{C,T},int64(x)+86400000000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Day{C}) = convert(DateTime{C,T},int64(x)-86400000000*int64(y))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Hour{C}) = convert(DateTime{C,T},int64(x)+3600000000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Hour{C}) = convert(DateTime{C,T},int64(x)-3600000000*int64(y))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Minute{C}) = convert(DateTime{C,T},int64(x)+60000000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Minute{C}) = convert(DateTime{C,T},int64(x)-60000000*int64(y))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)+1000000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)-1000000*int64(y))
(+)(y::Period,x::DateTimeDate) = x + y
(-)(y::Period,x::DateTimeDate) = x - y
(+){P<:Period}(x::DateTimeDate,y::Array{P}) = (for i in y; x += i; end; return x)
(+){P<:Period}(y::Array{P},x::DateTimeDate) = (for i in y; x += i; end; return x)
(-){P<:Period}(x::DateTimeDate,y::Array{P}) = (x -= y[1]; for i = 2:length(y); x += y[i]; end; return x)
(-){P<:Period}(y::Array{P},x::DateTimeDate) = (x -= y[1]; for i = 2:length(y); x += y[i]; end; return x)
typealias DateTimePeriod Union(DateTimeDate,Period)
@vectorize_2arg DateTimePeriod (-)
@vectorize_2arg DateTimePeriod (+)

#DateRange: for creating fixed period frequencies
immutable DateRange{C<:Calendar} <: Ranges{Date{C}}
	start::Date{C}
	step::DatePeriod
	len::Int
end
#DateRange1: for creating recurring events/dates, takes a function as step which return true for dates to be included
immutable DateRange1{C<:Calendar} <: Ranges{Date{C}}
	start::Date{C}
	step::Function
	len::Int
end
typealias DateRanges Union(DateRange,DateRange1)
size(r::DateRanges) = (r.len,)
length(r::DateRanges) = r.len
step(r::DateRanges)  = r.step
start(r::DateRanges) = 0
first(r::DateRanges) = r.start
done(r::DateRanges, i) = length(r) <= i
last(r::DateRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
next(r::DateRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
function show(io::IO,r::DateRanges)
	print(io, r.start, ':', r.step, ':', last(r))
end
colon{C<:Calendar}(t1::Date{C}, y::Year{C}, t2::Date{C}) = DateRange{C}(t1, y, fld(year(t2) - year(t1),y) + 1)
colon{C<:Calendar}(t1::Date{C}, m::Month{C}, t2::Date{C}) = DateRange{C}(t1, m, fld((year(t2)-year(t1))*12+month(t2)-month(t1),m) + 1)
colon{C<:Calendar}(t1::Date{C}, w::Week{C}, t2::Date{C}) = DateRange{C}(t1, w, fld(int64(t2)-int64(t1),7w) + 1)
colon{C<:Calendar}(t1::Date{C}, d::Day{C}, t2::Date{C}) = DateRange{C}(t1, d, fld(int64(t2)-int64(t1),d) + 1)
colon{C<:Calendar}(t1::Date{C}, t2::Date{C}) = DateRange{C}(t1, day(1), fld(int64(t2)-int64(t1),day(1)) + 1)
(+){C<:Calendar}(r::DateRange{C},p::DatePeriod) = DateRange{C}(r.start+p,r.step,r.len)
(-){C<:Calendar}(r::DateRange{C},p::DatePeriod) = DateRange{C}(r.start-p,r.step,r.len)
function last(r::DateRange1)
	t = r.start
	len = 0
	while true
		r.step(t) && (len += 1)
		len == r.len && break
		t += day(1)
	end
	return t
end
function next(r::DateRange1, i)
	t = r.start
	len = 0
	while true
		r.step(t) && (len += 1)
		len == i+1 && break
		t += day(1)
	end
	return (t,i+1)
end
function colon{C<:Calendar}(t1::Date{C},fun::Function,t2::Date{C})
	len = 0
	t = d1 = t1
	while t < t2
		if fun(t) 
			len += 1
			len == 1 && (d1 = t)
		end
		t += day(1)
	end
	return DateRange1{C}(d1, fun, len)
end
(+){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start+p,r.step,r.len)
(-){C<:Calendar}(r::DateRange1{C},p::DatePeriod) = DateRange1{C}(r.start-p,r.step,r.len)
recur{C<:Calendar}(fun::Function,di::DateRange{C}) = colon(di.start,fun,last(di))
const Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday = 1,2,3,4,5,6,7
const January,February,March,April,May,June,July,August,September,October,November,December = 1,2,3,4,5,6,7,8,9,10,11,12

immutable DateTimeRange{C<:Calendar,T<:Offsets} <: Ranges{DateTime{C,T}}
	start::DateTime{C,T}
	step::Period
	len::Int
end
size(r::DateTimeRange) = (r.len,)
length(r::DateTimeRange) = r.len
step(r::DateTimeRange)  = r.step
start(r::DateTimeRange) = 0
first(r::DateTimeRange) = r.start
last(r::DateTimeRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
next(r::DateTimeRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
done(r::DateTimeRange, i) = length(r) <= i
function show{C<:Calendar}(io::IO,r::DateTimeRange{C})
	print(io, r.start, ':', r.step, ':', last(r))
end
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, y::Year{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, y, fld(year(t2) - year(t1),y) + 1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, m::Month{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, m, fld((year(t2)-year(t1))*12+month(t2)-month(t1),m) + 1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, w::Week{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, w, fld(_days(t2)-_days(t1),7w)+1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, d::Day{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, d, fld(_days(t2)-_days(t1),d)+1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, h::Hour{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, h, fld(fld(int64(t2),3600000000)-fld(int64(t1),3600000000),h)+1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, mi::Minute{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, mi, fld(fld(int64(t2),60000000)-fld(int64(t1),60000000),mi)+1)
colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, s::Second{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, s, fld(fld(int64(t2),1000000)-fld(int64(t1),1000000),s)+1)
(+){C<:Calendar,T<:Offsets}(r::DateTimeRange{C,T},p::DatePeriod) = DateTimeRange{C,T}(r.start+p,r.step,r.len)
(-){C<:Calendar,T<:Offsets}(r::DateTimeRange{C,T},p::DatePeriod) = DateTimeRange{C,T}(r.start-p,r.step,r.len)

#Period types
convert{P<:Period}(::Type{P},x::Int32) = Base.box(P,Base.unbox(Int32,x))
convert{P<:Period}(::Type{Int32},x::P) = Base.box(Int32,Base.unbox(P,x))
convert{P<:Period}(::Type{P},x::Real) = convert(P,int32(x))
convert{R<:Real}(::Type{R},x::Period) = convert(R,int32(x))
for period in (Year,Month,Week,Day,Hour,Minute,Second)
	@eval convert(::Type{$period},x::Int32) = convert($period{CALENDAR},int32(x))
end
promote_rule{P<:Period,R<:Real}(::Type{P},::Type{R}) = R
#Constructors; default to CALENDAR; with (s) too cutesy? seems natural/expected though
years   = (year(x::PeriodMath)    = convert(Year{CALENDAR},x))
months  = (month(x::PeriodMath)   = convert(Month{CALENDAR},x))
weeks   = (week(x::PeriodMath)    = convert(Week{CALENDAR},x))
days    = (day(x::PeriodMath) 	  = convert(Day{CALENDAR},x))
hours   = (hour(x::PeriodMath)    = convert(Hour{CALENDAR},x))
minutes = (minute(x::PeriodMath)  = convert(Minute{CALENDAR},x))
seconds = (second(x::PeriodMath)  = convert(Second{CALENDAR},x))
#Print/show/traits
_units(x::Period) = " " * lowercase(string(typeof(x).name)) * (x == 1 ? "" : "s")
print(io::IO,x::Period) = print(io,int32(x),_units(x))
show(io::IO,x::Period) = print(io,x)
string(x::Period) = string(int32(x),_units(x))
typemin{P<:Period}(::Type{P}) = convert(P,typemin(Int32))
typemax{P<:Period}(::Type{P}) = convert(P,typemax(Int32))
zero{P<:Period}(::Union(Type{P},P)) = convert(P,int32(0))
one{P<:Period}(::Union(Type{P},P)) = convert(P,int32(1))
#Period Arithmetic:
isless{P<:Period}(x::P,y::P) = isless(int32(x),int32(y))
isless(x::Period,y::Real) = isless(promote(x,y)...)
isless(x::Real,y::Period) = isless(promote(x,y)...)
isequal(x::Period,y::Real) = isequal(promote(x,y)...)
isequal(x::Real,y::Period) = isequal(promote(x,y)...)
(-){P<:Period}(x::P) = convert(P,-int32(x))
(+)(x::Period,y::Period) = Period[x,y]
(-)(x::Period,y::Period) = Period[x,-y]
(+)(x::Array{Period},y::Period) = push!(x,y)
(-)(x::Array{Period},y::Period) = push!(x,-y)
for op in (:+,:-,:*,:/,:%,:fld)
	@eval begin
	($op){P<:Period}(x::P,y::P) = convert(P,($op)(int32(x),int32(y)))
	($op){P<:Period}(x::P,y::Real) = ($op)(promote(x,y)...)
	($op){P<:Period}(x::Real,y::P) = ($op)(promote(x,y)...)
	end
end
#wrapping arithmetic
addwrap(x::Int64,y::Int64) = (v = (x + y)      % 12; return v == 0 ? 12 : v)
subwrap(x::Int64,y::Int64) = (v = (x - y + 12) % 12; return v == 0 ? 12 : v)
addwrap(x::Int64,y::Int64,z::Int64) = x + (y + z > 12 ? max(1, fld(z,12)) : 0)
subwrap(x::Int64,y::Int64,z::Int64) = x - (y - z < 1  ? max(1, fld(z,12)) : 0)

#DateRange: for creating fixed period frequencies
immutable PeriodRange{P<:Period} <: Ranges{Period}
	start::P
	step::P
	len::Int
end
size(r::PeriodRange) = (r.len,)
length(r::PeriodRange) = r.len
step(r::PeriodRange)  = r.step
start(r::PeriodRange) = 0
first(r::PeriodRange) = r.start
done(r::PeriodRange, i) = length(r) <= i
last(r::PeriodRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
next(r::PeriodRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
function show(io::IO,r::PeriodRange)
	print(io, r.start, ':', r.step, ':', last(r))
end
colon{P<:Period}(t1::P, s::P, t2::P) = PeriodRange{P}(t1, s, fld(t2-t1,s) + int32(1))
colon{P<:Period}(t1::P, t2::P) = PeriodRange{P}(t1, one(P), int32(t2)-int32(t1) + int32(1))
(+){P<:Period}(r::PeriodRange{P},p::P) = PeriodRange{P}(r.start+p,r.step,r.len)
(-){P<:Period}(r::PeriodRange{P},p::P) = PeriodRange{P}(r.start-p,r.step,r.len)

end #module

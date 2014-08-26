module Datetime

export Calendar, ISOCalendar, Offsets, TimeZone, Offset, CALENDAR, OFFSET, Period,
    Date, DateTime, DateRange, DateRange1, DateTimeRange, DateTimeRange1,
    Year, Month, Week, Day, Hour, Minute, Second,
    year, month, week, day, hour, minute, second, millisecond,
    years,months,weeks,days,hours,minutes,seconds, milliseconds,
    addwrap, subwrap, date, datetime, unix2datetime, totaldays,
    isleap, lastdayofmonth, dayofweek, dayofyear, isdate, isdatetime,
    dayofweekinmonth, daysofweekinmonth, firstdayofweek, lastdayofweek,
    recur, now, today, calendar, timezone, offset, setcalendar, settimezone,
    Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday,
    Mon,Tue,Wed,Thu,Fri,Sat,Sun,
    January, February, March, April, May, June, July,
    August, September, October, November, December,
    Jan,Feb,Mar,Apr,Jun,Jul,Aug,Sep,Oct,Nov,Dec

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
bitstype 64 Date{C <: Calendar}                        <: TimeType
bitstype 64 DateTime{C <: Calendar, T <: Offsets}     <: TimeType

abstract Period     <: AbstractTime
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
Base.convert{T<:TimeType}(::Type{T},x::Int64) = reinterpret(T,x)
Base.convert{T<:TimeType}(::Type{Int64},x::T) = reinterpret(Int64,x)
Base.promote_rule{T<:TimeType,R<:Real}(::Type{T},::Type{R}) = R
Base.convert{T<:TimeType}(::Type{T},x::Real) = convert(T,int64(x))
Base.convert{R<:Real}(::Type{R}, x::TimeType) = convert(R,int64(x))
Base.promote_rule{C<:Calendar,T<:Offsets}(::Type{Date{C}},::Type{DateTime{C,T}}) = DateTime{C,T}
Base.convert{T<:Offsets}(::Type{DateTime{ISOCalendar,T}},x::Date) = convert(DateTime{ISOCalendar,T}, (secs = 86400000*int64(x); secs - setoffset(T,secs,year(x),0)))
Base.convert(::Type{Date{ISOCalendar}},x::DateTime) = convert(Date{ISOCalendar},_days(x))
date(x::DateTime) = convert(Date{CALENDAR},x)
datetime{T<:Offsets}(x::Date, tz::Type{T}=OFFSET) = convert(DateTime{CALENDAR,tz},x)
datetime(x::Date, tz::String) = datetime(x, timezone(tz))
#Date type safety
Base.promote_rule{C<:Calendar,CC<:Calendar}(::Type{Date{C}},::Type{Date{CC}}) = Date{ISOCalendar}
Base.convert(::Type{Date{ISOCalendar}},x::Date) = convert(Date{ISOCalendar},int64(x))
Base.convert(::Type{Date},x::Int64) = convert(Date{ISOCalendar},x)
#DateTime type safety
Base.promote_rule{C<:Calendar,CC<:Calendar,T<:Offsets,TT<:Offsets}(::Type{DateTime{C,T}},::Type{DateTime{CC,TT}}) = DateTime{ISOCalendar,UTC}
Base.convert(::Type{DateTime{ISOCalendar,UTC}},x::DateTime) = convert(DateTime{ISOCalendar,UTC},int64(x))
Base.convert(::Type{DateTime},x::Int64) = convert(DateTime{ISOCalendar,UTC},x)
Base.hash(x::TimeType, h::Uint) = hash(int64(x), h)
Base.length(::TimeType) = 1
Base.isless{T<:TimeType}(x::T,y::T) =    isless(int64(x),int64(y))
Base.isless(x::TimeType,y::Real) =       isless(int64(x),int64(y))
Base.isless(x::Real,y::TimeType) =       isless(int64(x),int64(y))
Base.isless(x::TimeType,y::TimeType) =   isless(promote(x,y)...)
=={T<:TimeType}(x::T,y::T) = ==(int64(x),int64(y))
==(x::TimeType,y::Real) = ==(int64(x),int64(y))
==(x::Real,y::TimeType) = ==(int64(x),int64(y))
==(x::TimeType,y::TimeType) = ==(promote(x,y)...)

Base.isequal{T<:TimeType}(x::T,y::T) = isequal(int64(x),int64(y))
Base.isequal(x::TimeType,y::Real) = isequal(int64(x),int64(y))
Base.isequal(x::Real,y::TimeType) = isequal(int64(x),int64(y))
Base.isequal(x::TimeType,y::TimeType) = isequal(promote(x,y)...)
Base.isfinite(x::TimeType) = true

#Serialization/Deserialization
Base.write(io::IO, x::TimeType) = write(io, reinterpret(Uint64, x))
Base.write(io::IO, x::Period  ) = write(io, reinterpret(Uint32, x))
Base.read{T<:TimeType}(io::IO, ::Type{T}) = reinterpret(T, read(io, Uint64))
Base.read{T<:Period  }(io::IO, ::Type{T}) = reinterpret(T, read(io, Uint32))

#Date algorithm implementations
#Source: Peter Baum - http://mysite.verizon.net/aesir_research/date/date0.htm
#Convert y,m,d to # of Rata Die days
yeardays(y) = 365y + fld(y,4) - fld(y,100) + fld(y,400)
const monthdays = [306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275]
totaldays(y,m,d) = d + monthdays[m] + yeardays(m<3 ? y-1 : y) - 306
#Convert # of Rata Die days to proleptic Gregorian calendar y,m,d,w
function _year(dt)
    z = dt + 306; h = 100z - 25;    a = fld(h,3652425)
    b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
    m = div(5c+456,153); return m > 12 ? y+1 : y    
end
function _month(dt)
    z = dt + 306; h = 100z - 25;    a = fld(h,3652425)
    b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
    m = div(5c+456,153); return m > 12 ? m-12 : m
end
function _day(dt)
    z = dt + 306; h = 100z - 25;    a = fld(h,3652425)
    b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
    m = div(5c+456,153); d = c - div(153m-457,5); return d
end
function _day2date(dt)
    z = dt + 306; h = 100z - 25;    a = fld(h,3652425)
    b = a - fld(a,4); y = fld(100b+h,36525); c = b + z - 365y - fld(y,4)
    m = div(5c+456,153); d = c - div(153m-457,5); return m > 12 ? (y+1,m-12,d) : (y,m,d)
end
#https://en.wikipedia.org/wiki/Talk:ISO_week_date#Algorithms
function _week(dt)
    w = fld(abs(dt-1),7) % 20871
    c = fld((w + (w >= 10435)),5218)
    w = (w + (w >= 10435)) % 5218
    w = (w*28+(15,23,3,11)[c+1]) % 1461
    return fld(w,28) + 1
end
const DAYSINMONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
isleap(y) = ((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)
lastdayofmonth(y,m) = DAYSINMONTH[m] + (m == 2 && isleap(y))

#TimeType constructors
setoffset(tz::Type{UTC},secs,y,s) = 0 - (y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs))
getoffset(tz::Type{UTC},secs) = 0 - leaps(secs)
getoffset_secs(tz::Type{UTC},secs) = 0 - leaps1(secs)
getabr(tz::Type{UTC},secs,y) = "UTC"
#DateTime constructor with timezone and/or leap seconds
ff = open(joinpath(FILEPATH,"../deps/tzdata/_leaps"))
const _leaps = deserialize(ff)
close(ff)
ff = open(joinpath(FILEPATH,"../deps/tzdata/_leaps1"))
const _leaps1 = deserialize(ff)
close(ff)
# const _leaps  = [62214479999000,62230377599000,62261913599000,62293449599000,62324985599000,62356607999000,62388143999000,62419679999000,62451215999000,62498476799000,62530012799000,62561548799000,62624707199000,62703676799000,62766835199000,62798371199000,62845631999000,62877167999000,62908703999000,62956137599000,63003398399000,63050831999000,63271756799000,63366451199000,63476783999000,9223372036854775807]
# const _leaps1 = [62214480000000,62230377601000,62261913602000,62293449603000,62324985604000,62356608005000,62388144006000,62419680007000,62451216008000,62498476809000,62530012810000,62561548811000,62624707212000,62703676813000,62766835214000,62798371215000,62845632016000,62877168017000,62908704018000,62956137619000,63003398420000,63050832021000,63271756822000,63366451223000,63476784024000,9223372036854775807]
leaps(secs::Union(DateTime,Int64))  = (i = 1; while true; @inbounds (_leaps[i]  >= secs && break); i+=1 end; return 1000*(i-1))
leaps1(secs::Union(DateTime,Int64)) = (i = 1; while true; @inbounds (_leaps1[i] >= secs && break); i+=1 end; return 1000*(i-1))

date{C<:Calendar}(y::Int64,m::Int64=1,d::Int64=1,cal::Type{C}=CALENDAR) = convert(Date{cal},totaldays(y,m,d))
date{C<:Calendar}(y::PeriodMath,m::PeriodMath=1,d::PeriodMath=1,cal::Type{C}=CALENDAR) = date(int64(y),int64(m),int64(d),cal)
datetime{C<:Calendar,T<:Offsets}(y::Int64,m::Int64=1,d::Int64=1,h::Int64=0,mi::Int64=0,s::Int64=0,milli::Int64=0,tz::Type{T}=OFFSET,cal::Type{C}=CALENDAR) = 
    (secs = milli + 1000*(s + 60mi + 3600h + 86400*totaldays(y,m,d)); return convert(DateTime{cal,tz}, secs - setoffset(tz,secs,y,s)))
datetime{C<:Calendar,T<:Offsets}(y::Real,m::Real=1,d::Real=1,h::Real=0,mi::Real=0,s::Real=0,millis::Real=0,tz::Type{T}=OFFSET,cal::Type{C}=CALENDAR) = 
    datetime(int64(y),int64(m),int64(d),int64(h),int64(mi),int64(s),int64(millis),tz,cal)
datetime(y,m,d,h,mi,s,milli,tz::String) = datetime(y,m,d,h,mi,s,milli,timezone(tz),CALENDAR)
function date(s::String)
    if ismatch(r"[\/|\-|\.|,|\s]",s)
        m = match(r"[\/|\-|\.|,|\s]",s)
        a,b,c = split(s,m.match)
        y = length(a) == 4 ? int64(a) : length(c) == 4 ? int64(c) : 0
        a,b,c = int64(a),int64(b),int64(c)
        y == 0 && (y = c > 49 ? c + 1900 : c + 2000)
        m,d = y == a ? (b,c) : (a,b)
        return m > 12 ? date(y,d,m) : date(y,m,d)
    else
        error("Can't parse Date, please use date(format,datestring)")
    end
end
type DateTimeFormat
    year::Range1
    month::Range1
    day::Range1
    hour::Range1
    minute::Range1
    second::Range1
    fraction::Range1
    tz::Range1
    sep::String
    #ampm::Bool
end
function DateTimeFormat(f::String)
    y = first(search(f,"y")):last(rsearch(f,"y"))
    mon = first(search(f,"M")):last(rsearch(f,"M"))
    d = first(search(f,"d")):last(rsearch(f,"d"))
    h = first(search(f,"H")):last(rsearch(f,"H"))
    min = first(search(f,"m")):last(rsearch(f,"m"))
    s = first(search(f,"s")):last(rsearch(f,"s"))
    frac = first(search(f,"S")):last(rsearch(f,"S"))
    sep = ismatch(r"[\/|\-|\.|,|\s]",f) ? match(r"[\/|\-|\.|,|\s]",f).match : ""
    tz = first(search(f,"z")):last(rsearch(f,"z"))
    return DateTimeFormat(y,mon,d,h,min,s,frac,tz,sep) #,ampm)
end
function dt2string(format::DateTimeFormat,dt::String)
    y = format.year == 0:-1 ? 1 : int(dt[format.year])
    mon = format.month == 0:-1 ? 1 : int(dt[format.month])
    d = format.day == 0:-1 ? 1 : int(dt[format.day])
    h = format.hour == 0:-1 ? 0 : int(dt[format.hour])
    min = format.minute == 0:-1 ? 0 : int(dt[format.minute])
    s = format.second == 0:-1 ? 0 : int(dt[format.second])
    frac = format.fraction == 0:-1 ? 0 : int(dt[format.fraction])*100
    tz = format.tz == 0:-1 ? UTC : dt[format.tz]
    return datetime(y,mon,d,h,min,s,frac,tz)
end
datetime(f::String,dt::String) = dt2string(DateTimeFormat(f),dt)
function datetime{T<:String}(f::T,t::Array{T})
    ff = DateTimeFormat(f)
    ret = DateTime{CALENDAR,OFFSET}[]
    for i in t
        push!(ret,dt2string(ff,i))
    end
    return ret
end

#Accessor/trait functions
typealias DateTimeDate Union(DateTime,Date)
_days(dt::Date) = int64(dt)
_days{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = fld(int64(dt)+getoffset(T,dt),86400000)
year(dt::DateTimeDate) = _year(_days(dt))
month(dt::DateTimeDate) = _month(_days(dt))
week(dt::DateTimeDate) = _week(_days(dt))
day(dt::DateTimeDate) = _day(_days(dt))
hour{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})     = fld(int64(dt)+getoffset(T,dt),3600000) % 24
minute{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})   = fld(int64(dt)+getoffset(T,dt),60000) % 60
second{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})   = (s = fld(int64(dt)+getoffset_secs(T,dt),1000) % 60; return s != 0 ? s : dt in _leaps1 ? int64(60) : int64(0))
milliseconds = (millisecond(dt::DateTime) = int64(dt) % 1000)
calendar{C<:Calendar}(dt::Date{C}) = C
Base.typemax{D<:Date}(::Type{D}) = date(252522163911149,12,31)
Base.typemin{D<:Date}(::Type{D}) = date(-252522163911150,1,1)
isdate(n) = typeof(n) <: Date
calendar{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = C
timezone{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = T
Base.typemax{D<:DateTime}(::Type{D}) = datetime(292277024,12,31,23,59,59)
Base.typemin{D<:DateTime}(::Type{D}) = datetime(-292277023,1,1,0,0,0)
isdatetime(x) = typeof(x) <: DateTime
#Functions to work with timezones
Base.convert{C<:Calendar,T<:Offsets,TT<:Offsets}(::Type{DateTime{C,T}},x::DateTime{C,TT}) = convert(DateTime{C,TT},int64(x))
timezone{C<:Calendar,T<:Offsets,TT<:Offsets}(dt::DateTime{C,T},tz::Type{TT}) = convert(DateTime{C,TT},int64(dt))
offset{C<:Calendar,T<:Offsets,TT<:Offsets}(dt::DateTime{C,T},tz::Type{TT}) = convert(DateTime{C,TT},int64(dt))
timezone(x::String) = get(TIMEZONES,x,Zone0)
timezone(dt::DateTime,tz::String) = timezone(dt,timezone(tz))

#String/print/show
_s(x) = @sprintf("%02d",x)
function Base.string(dt::Date)
    y,m,d = _day2date(_days(dt))
    y = y < 0 ? @sprintf("%05d",y) : @sprintf("%04d",y)
    return string(y,"-",_s(m),"-",_s(d))
end
function Base.string{C<:Calendar,T<:Offsets}(dt::DateTime{C,T})
    y,m,d = _day2date(_days(dt))
    h,mi,s = hour(dt),minute(dt),second(dt)
    return string(y < 0 ? @sprintf("%05d",y) : @sprintf("%04d",y),"-",
        _s(m),"-",_s(d),"T",_s(h),":",_s(mi),":",_s(s)," ",getabr(T,dt,y))
end
Base.print(io::IO,x::TimeType) = print(io,string(x))
Base.show(io::IO,x::TimeType) = print(io,string(x))

#Generic date functions
isleap(dt::DateTimeDate) = isleap(year(dt))
lastdayofmonth(dt::DateTimeDate) = lastdayofmonth(year(dt),month(dt))
dayofweek(dt::DateTimeDate) = mod1(_days(dt),7)
dayofweekinmonth(dt::DateTimeDate) = (d = day(dt); return d < 8 ? 1 : d < 15 ? 2 : d < 22 ? 3 : d < 29 ? 4 : 5)
function daysofweekinmonth(dt::DateTimeDate)
    d,ld = day(dt),lastdayofmonth(dt)
    return ld == 28 ? 4 : ld == 29 ? ((d in (1,8,15,22,29)) ? 5 : 4) :
           ld == 30 ? ((d in (1,2,8,9,15,16,22,23,29,30)) ? 5 : 4) :
           (d in (1,2,3,8,9,10,15,16,17,22,23,24,29,30,31)) ? 5 : 4
end
firstdayofweek{C<:Calendar}(dt::Date{C}) = (d = dayofweek(dt); return convert(Date{C},int64(dt) - d + 1))
firstdayofweek{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = (d = dayofweek(dt); return convert(DateTime{C,T},int64(dt) - 86400000*(d - 1)))
lastdayofweek{C<:Calendar}(dt::Date{C}) = (d = dayofweek(dt); return convert(Date{C},int64(dt) + (7-d)))
lastdayofweek{C<:Calendar,T<:Offsets}(dt::DateTime{C,T}) = (d = dayofweek(dt); return convert(DateTime{C,T},int64(dt) + 86400000*(7-d)))
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
const UNIXEPOCH = 62135683200000 #Rata Die milliseconds for 1970-01-01T00:00:00 UTC
unix2datetime{T<:Offsets}(x::Int64,tz::Type{T}) = convert(DateTime{CALENDAR,tz},UNIXEPOCH + x + leaps(UNIXEPOCH + x))
now() = unix2datetime(int64(1000*time()),OFFSET)
now{T<:Offsets}(tz::Type{T}) = unix2datetime(int64(1000*time()),tz)
today() = date(now())

#TimeType arithmetic
(+)(x::TimeType) = x
(-)(x::Date) = date(-int64(year(x)),month(x),day(x))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T}) = datetime(-year(x),month(x),day(x),hour(x),minute(x),second(x))
for op in (:+,:*,:/)
    @eval ($op)(x::DateTimeDate,y::DateTimeDate) = Base.no_op_err($op,"Date/DateTime")
end
(-){C<:Calendar}(x::Date{C},y::Date{C}) = days(-(int64(x),int64(y)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::DateTime{C,T}) = int64(x)-int64(y)
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
    y,m,d = _day2date(_days(dt))
    ny = yearwrap(y,m,int64(z))
    mm = monthwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
    return date(ny,mm,d <= ld ? d : ld)
end
function (-){C<:Calendar}(dt::Date{C},z::Month{C})
    y,m,d = _day2date(_days(dt))
    ny = yearwrap(y,m,-int64(z))
    mm = monthwrap(m,-int64(z)); ld = lastdayofmonth(ny,mm)
    return date(ny,mm,d <= ld ? d : ld)
end
function (+){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},z::Month{C}) 
    y,m,d = _day2date(_days(dt))
    ny = yearwrap(y,m,int64(z))
    mm = monthwrap(m,int64(z)); ld = lastdayofmonth(ny,mm)
    return datetime(ny,mm,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
function (-){C<:Calendar,T<:Offsets}(dt::DateTime{C,T},z::Month{C}) 
    y,m,d = _day2date(_days(dt))
    ny = yearwrap(y,m,-int64(z))
    mm = monthwrap(m,-int64(z)); ld = lastdayofmonth(ny,mm)
    return datetime(ny,mm,d <= ld ? d : ld,hour(dt),minute(dt),second(dt))
end
#weeks,days,hours,minutes,seconds
(+){C<:Calendar}(x::Date{C},y::Week{C}) = convert(Date{C},(int64(x) + 7*int64(y)))
(-){C<:Calendar}(x::Date{C},y::Week{C}) = convert(Date{C},(int64(x) - 7*int64(y)))
(+){C<:Calendar}(x::Date{C},y::Day{C})  = convert(Date{C},(int64(x) + int64(y)))
(-){C<:Calendar}(x::Date{C},y::Day{C})  = convert(Date{C},(int64(x) - int64(y)))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Week{C})   = (x = int64(x)+604800000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Week{C})   = (x = int64(x)-604800000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Day{C})    = (x = int64(x)+86400000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Day{C})    = (x = int64(x)-86400000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Hour{C})   = (x = int64(x)+3600000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Hour{C})   = (x = int64(x)-3600000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Minute{C}) = (x = int64(x)+60000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Minute{C}) = (x = int64(x)-60000*int64(y) - leaps(int64(x)); convert(DateTime{C,T},x+leaps(x)))
(+){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)+1000*int64(y))
(-){C<:Calendar,T<:Offsets}(x::DateTime{C,T},y::Second{C}) = convert(DateTime{C,T},int64(x)-1000*int64(y))
(+)(y::Period,x::DateTimeDate) = x + y
(-)(y::Period,x::DateTimeDate) = x - y
typealias DateTimePeriod Union(DateTimeDate,Period)
(+){T<:DateTimePeriod}(x::DateTimePeriod, y::AbstractArray{T}) = reshape([x + y[i] for i in 1:length(y)], size(y))
(+){T<:DateTimePeriod}(x::AbstractArray{T}, y::DateTimePeriod) = reshape([x[i] + y for i in 1:length(x)], size(x))
(-){T<:DateTimePeriod}(x::DateTimePeriod, y::AbstractArray{T}) = reshape([x - y[i] for i in 1:length(y)], size(y))
(-){T<:DateTimePeriod}(x::AbstractArray{T}, y::DateTimePeriod) = reshape([x[i] - y for i in 1:length(x)], size(x))


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
Base.size(r::DateRanges) = (r.len,)
Base.length(r::DateRanges) = r.len
Base.step(r::DateRanges)  = r.step
Base.start(r::DateRanges) = 0
Base.first(r::DateRanges) = r.start
Base.done(r::DateRanges, i) = length(r) <= i
Base.last(r::DateRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
Base.next(r::DateRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
function Base.show(io::IO,r::DateRanges)
    print(io, r.start, ':', r.step, ':', last(r))
end
Base.colon{C<:Calendar}(t1::Date{C}, y::Year{C}, t2::Date{C}) = DateRange{C}(t1, y, fld(year(t2) - year(t1),y) + 1)
Base.colon{C<:Calendar}(t1::Date{C}, m::Month{C}, t2::Date{C}) = DateRange{C}(t1, m, fld((year(t2)-year(t1))*12+month(t2)-month(t1),m) + 1)
Base.colon{C<:Calendar}(t1::Date{C}, w::Week{C}, t2::Date{C}) = DateRange{C}(t1, w, fld(int64(t2)-int64(t1),7w) + 1)
Base.colon{C<:Calendar}(t1::Date{C}, d::Day{C}, t2::Date{C}) = DateRange{C}(t1, d, fld(int64(t2)-int64(t1),d) + 1)
Base.colon{C<:Calendar}(t1::Date{C}, t2::Date{C}) = DateRange{C}(t1, day(1), fld(int64(t2)-int64(t1),day(1)) + 1)
(+){C<:Calendar}(r::DateRange{C},p::DatePeriod) = DateRange{C}(r.start+p,r.step,r.len)
(-){C<:Calendar}(r::DateRange{C},p::DatePeriod) = DateRange{C}(r.start-p,r.step,r.len)
function Base.last(r::DateRange1)
    t = r.start
    len = 0
    while true
        r.step(t) && (len += 1)
        len == r.len && break
        t += day(1)
    end
    return t
end
function Base.next(r::DateRange1, i)
    t = r.start
    len = 0
    while true
        r.step(t) && (len += 1)
        len == i+1 && break
        t += day(1)
    end
    return (t,i+1)
end
function Base.colon{C<:Calendar}(t1::Date{C},fun::Function,t2::Date{C})
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
const Mon,Tue,Wed,Thu,Fri,Sat,Sun = 1,2,3,4,5,6,7
const Jan,Feb,Mar,Apr,Jun,Jul,Aug,Sep,Oct,Nov,Dec = 1,2,3,4,5,6,7,8,9,10,11,12

immutable DateTimeRange{C<:Calendar,T<:Offsets} <: Ranges{DateTime{C,T}}
    start::DateTime{C,T}
    step::Period
    len::Int
end
Base.size(r::DateTimeRange) = (r.len,)
Base.length(r::DateTimeRange) = r.len
Base.step(r::DateTimeRange)  = r.step
Base.start(r::DateTimeRange) = 0
Base.first(r::DateTimeRange) = r.start
Base.last(r::DateTimeRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
Base.next(r::DateTimeRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
Base.done(r::DateTimeRange, i) = length(r) <= i
function Base.show{C<:Calendar}(io::IO,r::DateTimeRange{C})
    print(io, r.start, ':', r.step, ':', last(r))
end
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, y::Year{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, y, fld(year(t2) - year(t1),y) + 1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, m::Month{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, m, fld((year(t2)-year(t1))*12+month(t2)-month(t1),m) + 1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, w::Week{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, w, fld(_days(t2)-_days(t1),7w)+1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, d::Day{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, d, fld(_days(t2)-_days(t1),d)+1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, h::Hour{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, h, fld(fld(int64(t2),3600000)-fld(int64(t1),3600000),h)+1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, mi::Minute{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, mi, fld(fld(int64(t2),60000)-fld(int64(t1),60000),mi)+1)
Base.colon{C<:Calendar,T<:Offsets}(t1::DateTime{C,T}, s::Second{C}, t2::DateTime{C,T}) = DateTimeRange{C,T}(t1, s, fld(fld(int64(t2),1000)-fld(int64(t1),1000),s)+1)
(+){C<:Calendar,T<:Offsets}(r::DateTimeRange{C,T},p::DatePeriod) = DateTimeRange{C,T}(r.start+p,r.step,r.len)
(-){C<:Calendar,T<:Offsets}(r::DateTimeRange{C,T},p::DatePeriod) = DateTimeRange{C,T}(r.start-p,r.step,r.len)

#Period types
Base.convert{P<:Period}(::Type{P},x::Int32) = Base.box(P,Base.unbox(Int32,x))
Base.convert{P<:Period}(::Type{Int32},x::P) = Base.box(Int32,Base.unbox(P,x))
Base.convert{P<:Period}(::Type{P},x::Real) = convert(P,int32(x))
Base.convert{R<:Real}(::Type{R},x::Period) = convert(R,int32(x))
for period in (Year,Month,Week,Day,Hour,Minute,Second)
    @eval Base.convert(::Type{$period},x::Int32) = convert($period{CALENDAR},int32(x))
    @eval Base.promote_rule{P<:$period}(::Type{P},::Type{P}) = $period{CALENDAR}
    @eval Base.promote_rule{P<:$period,PP<:$period}(::Type{P},::Type{PP}) = $period{CALENDAR}
    @eval Base.convert{P<:$period}(::Type{$period{ISOCalendar}},x::P) = convert($period{ISOCalendar},int32(x))
end
Base.promote_rule{P<:Period,R<:Real}(::Type{P},::Type{R}) = R
Base.promote_rule{A<:Period,B<:Period}(::Type{A},::Type{B}) =
    A == Second{CALENDAR} || B == Second{CALENDAR} ? Second{CALENDAR} :
    A == Minute{CALENDAR} || B == Minute{CALENDAR} ? Minute{CALENDAR} : 
    A == Hour{CALENDAR}   || B == Hour{CALENDAR}   ? Hour{CALENDAR}   :
    A == Day{CALENDAR}    || B == Day{CALENDAR}    ? Day{CALENDAR}    : 
    A == Week{CALENDAR}   || B == Week{CALENDAR}   ? Week{CALENDAR}   : Month{CALENDAR}
#conversion rules between periods; ISO/Greg/Julian-specific, but we define as the catchall for all Calendars
Base.convert{C<:Calendar}(::Type{Month{C}},x::Year{C})    = convert(Month{C},  int32(12x))
Base.convert{C<:Calendar}(::Type{Week{C}},x::Year{C})     = convert(Week{C},   int32(52x))
Base.convert{C<:Calendar}(::Type{Day{C}},x::Year{C})      = convert(Day{C},    int32(365x))
Base.convert{C<:Calendar}(::Type{Day{C}},x::Week{C})      = convert(Day{C},    int32(7x))
Base.convert{C<:Calendar}(::Type{Hour{C}},x::Year{C})     = convert(Hour{C},   int32(8760x))
Base.convert{C<:Calendar}(::Type{Hour{C}},x::Week{C})     = convert(Hour{C},   int32(168x))
Base.convert{C<:Calendar}(::Type{Hour{C}},x::Day{C})      = convert(Hour{C},   int32(24x))
Base.convert{C<:Calendar}(::Type{Minute{C}},x::Year{C})   = convert(Minute{C}, int32(525600x)) #Rent anybody?
Base.convert{C<:Calendar}(::Type{Minute{C}},x::Week{C})   = convert(Minute{C}, int32(10080x))
Base.convert{C<:Calendar}(::Type{Minute{C}},x::Day{C})    = convert(Minute{C}, int32(1440x))
Base.convert{C<:Calendar}(::Type{Minute{C}},x::Hour{C})   = convert(Minute{C}, int32(60x))
Base.convert{C<:Calendar}(::Type{Second{C}},x::Year{C})   = convert(Second{C}, int32(31536000x))
Base.convert{C<:Calendar}(::Type{Second{C}},x::Week{C})   = convert(Second{C}, int32(604800x))
Base.convert{C<:Calendar}(::Type{Second{C}},x::Day{C})    = convert(Second{C}, int32(86400x))
Base.convert{C<:Calendar}(::Type{Second{C}},x::Hour{C})   = convert(Second{C}, int32(3600x))
Base.convert{C<:Calendar}(::Type{Second{C}},x::Minute{C}) = convert(Second{C}, int32(60x))
#Constructors; default to CALENDAR; with (s) too cutesy? seems natural/expected though
years   = (year(x::PeriodMath)    = convert(Year{CALENDAR},x))
months  = (month(x::PeriodMath)   = convert(Month{CALENDAR},x))
weeks   = (week(x::PeriodMath)    = convert(Week{CALENDAR},x))
days    = (day(x::PeriodMath)       = convert(Day{CALENDAR},x))
hours   = (hour(x::PeriodMath)    = convert(Hour{CALENDAR},x))
minutes = (minute(x::PeriodMath)  = convert(Minute{CALENDAR},x))
seconds = (second(x::PeriodMath)  = convert(Second{CALENDAR},x))
#Print/show/traits
_units(x::Period) = " " * lowercase(string(typeof(x).name)) * (x == 1 ? "" : "s")
Base.print(io::IO,x::Period) = print(io,int32(x),_units(x))
Base.show(io::IO,x::Period) = print(io,x)
Base.string(x::Period) = string(int32(x),_units(x))
Base.typemin{P<:Period}(::Type{P}) = convert(P,typemin(Int32))
Base.typemax{P<:Period}(::Type{P}) = convert(P,typemax(Int32))
Base.zero{P<:Period}(::Union(Type{P},P)) = convert(P,int32(0))
Base.one{P<:Period}(::Union(Type{P},P)) = convert(P,int32(1))
offset(x::Period) = return Offset{int(minutes(x))}
offset(x::Period...) = return Offset{int(minutes(sum(x...)))}
#Period Arithmetic:
Base.isless{P<:Period}(x::P,y::P) = isless(int32(x),int32(y))
Base.isless(x::PeriodMath,y::PeriodMath) = isless(promote(x,y)...)
Base.isequal{P<:Period}(x::P,y::P) = isequal(int32(x),int32(y))
Base.isequal(x::Period,y::Period) = isequal(promote(x,y)...)
Base.isequal(x::Period,y::Real) = isequal(promote(x,y)...)
Base.isequal(x::Real,y::Period) = isequal(promote(x,y)...)
=={P<:Period}(x::P,y::P) = ==(int32(x),int32(y))
==(x::Period,y::Period) = ==(promote(x,y)...)
==(x::Period,y::Real) = ==(promote(x,y)...)
==(x::Real,y::Period) = ==(promote(x,y)...)

(-){P<:Period}(x::P) = convert(P,-int32(x))
import Base.fld
for op in (:+,:-,:%,:fld)
    @eval begin
    ($op != /) && (($op){P<:Period}(x::P,y::P) = convert(P,($op)(int32(x),int32(y))))
    ($op){P<:Period}(x::P,y::Real) = ($op)(promote(x,y)...)
    ($op){P<:Period}(x::Real,y::P) = ($op)(promote(x,y)...)
    !($op in (/,%,fld)) && ( ($op)(x::Period,y::Period) = ($op)(promote(x,y)...) )
    if !($op in (/,%,fld))
        ($op){P<:Period}(x::Period, y::AbstractArray{P}) = reshape([($op)(x, y[i]) for i in 1:length(y)], size(y))
        ($op){P<:Period}(x::AbstractArray{P}, y::Period) = reshape([($op)(x[i], y) for i in 1:length(x)], size(x))
    end
    end
end

for op in (:*, :/)
    @eval begin
    ($op){P<:Period}(x::P,y::P) = convert(P,($op)(int32(x),int32(y)))
    ($op){P<:Period}(x::P,y::Real) = convert(P, ($op)(promote(x,y)...))
    ($op){P<:Period}(x::Real,y::P) = convert(P, ($op)(promote(x,y)...))
    ($op)(x::Period,y::Period) = ($op)(promote(x,y)...)
    ($op){P<:Period}(x::Period, y::AbstractArray{P}) = reshape([($op)(x, y[i]) for i in 1:length(y)], size(y))
    ($op){P<:Period}(x::AbstractArray{P}, y::Period) = reshape([($op)(x[i], y) for i in 1:length(x)], size(x))
    end
end

(/){P<:Period}(x::P,y::P) = int32(x) / int32(y)

# Date/DateTime-Month arithmetic
# monthwrap adds two months with wraparound behavior (i.e. 12 + 1 == 1)
monthwrap(m1,m2) = (v = mod1(m1+m2,12); return v < 0 ? 12 + v : v)
# yearwrap takes a starting year/month and a month to add and returns
# the resulting year with wraparound behavior (i.e. 2000-12 + 1 == 2001)
yearwrap(y,m1,m2) = y + fld(m1 + m2 - 1,12)

#DateRange: for creating fixed period frequencies
immutable PeriodRange{P<:Period} <: Ranges{Period}
    start::P
    step::P
    len::Int
end
Base.size(r::PeriodRange) = (r.len,)
Base.length(r::PeriodRange) = r.len
Base.step(r::PeriodRange)  = r.step
Base.start(r::PeriodRange) = 0
Base.first(r::PeriodRange) = r.start
Base.done(r::PeriodRange, i) = length(r) <= i
Base.last(r::PeriodRange) = r.start + convert(typeof(r.step),(r.len-1)*r.step)
Base.next(r::PeriodRange, i) = (r.start + convert(typeof(r.step),i*r.step), i+1)
function Base.show(io::IO,r::PeriodRange)
    print(io, r.start, ':', r.step, ':', last(r))
end
Base.colon{P<:Period}(t1::P, s::P, t2::P) = PeriodRange{P}(t1, s, fld(t2-t1,s) + int32(1))
Base.colon{P<:Period}(t1::P, t2::P) = PeriodRange{P}(t1, one(P), int32(t2)-int32(t1) + int32(1))
(+){P<:Period}(r::PeriodRange{P},p::P) = PeriodRange{P}(r.start+p,r.step,r.len)
(-){P<:Period}(r::PeriodRange{P},p::P) = PeriodRange{P}(r.start-p,r.step,r.len)

end #module

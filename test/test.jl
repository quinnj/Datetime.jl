using Datetime

y = year(1)
m = months(1)
w = weeks(1)
d = days(1)
h = hour(1)
mi = minute(1)
s = second(1)

#Period arithmetic
Base.Test.@test typeof(y+m) ==  Month{ISOCalendar}
Base.Test.@test typeof(m+y) ==  Month{ISOCalendar}
Base.Test.@test typeof(y+w) ==  Week{ISOCalendar}
Base.Test.@test typeof(y+d) ==  Day{ISOCalendar}
Base.Test.@test typeof(y+h) ==  Hour{ISOCalendar}
Base.Test.@test typeof(y+mi) == Minute{ISOCalendar}
Base.Test.@test typeof(y+s) ==  Second{ISOCalendar}
Base.Test.@test_throws MethodError typeof(m+w)
Base.Test.@test_throws MethodError typeof(m+d)
Base.Test.@test_throws MethodError typeof(m+h)
Base.Test.@test_throws MethodError typeof(m+mi)
Base.Test.@test_throws MethodError typeof(m+s)
Base.Test.@test typeof(w+d) ==  Day{ISOCalendar}
Base.Test.@test typeof(w+h) ==  Hour{ISOCalendar}
Base.Test.@test typeof(w+mi) ==  Minute{ISOCalendar}
Base.Test.@test typeof(w+s) ==  Second{ISOCalendar}
Base.Test.@test typeof(d+h) ==  Hour{ISOCalendar}
Base.Test.@test typeof(d+mi) ==  Minute{ISOCalendar}
Base.Test.@test typeof(d+s) ==  Second{ISOCalendar}
Base.Test.@test typeof(h+mi) ==  Minute{ISOCalendar}
Base.Test.@test typeof(h+s) ==  Second{ISOCalendar}
Base.Test.@test typeof(mi+s) ==  Second{ISOCalendar}
Base.Test.@test y * m*months(2) == months(24)
Base.Test.@test y * w*weeks(2) == weeks(104)
Base.Test.@test y * d*days(2) == days(730)
Base.Test.@test y > m
Base.Test.@test d < w
Base.Test.@test typemax(Year) == 2147483647
Base.Test.@test typemax(Year) + y == -2147483648
Base.Test.@test typemin(Year) == -2147483648
q = convert(Year{Calendar},1)
Base.Test.@test typeof(q) == Year{Calendar}
y,q = promote(y,q) #check periods w/ diff calendars
Base.Test.@test typeof(q) == Year{ISOCalendar}
Base.Test.@test typeof(y) == Year{ISOCalendar}
Base.Test.@test q + y == years(2)
#Period-Real arithmetic
Base.Test.@test y + 1 == 2
Base.Test.@test 1 + y == 2
Base.Test.@test y + 1.0 == 2.0
Base.Test.@test y * 4 == 4
Base.Test.@test y * 4f0 == 4.0f0
Base.Test.@test y * 3//4 == year(1)
Base.Test.@test y / 2 == year(1)
Base.Test.@test 2 / y == 2
Base.Test.@test y / y == 1
Base.Test.@test y*10 % 5 == 0
Base.Test.@test 5 % y*10 == 0
Base.Test.@test !(y > 3)
Base.Test.@test 4 > y
t = [y,y,y,y,y]
Base.Test.@test t .+ year(2) == [year(3),year(3),year(3),year(3),year(3)]
#PeriodRange
t = year(100)
r = y:t
Base.Test.@test size(r) == (100,)
Base.Test.@test length(r) == 100
Base.Test.@test step(r) == year(1)
Base.Test.@test first(r) == y
Base.Test.@test last(r) == t
Base.Test.@test first(r + y) == year(2)
Base.Test.@test last(r + y) == year(101)
Base.Test.@test last(y:year(2):t) == year(99)
Base.Test.@test [year(0):year(25):t][4] == year(75)
Base.Test.@test_throws MethodError y:m:t


#traits
Base.Test.@test zero(typeof(y)) == year(0)
Base.Test.@test one(typeof(y)) == y
Base.Test.@test months(y) == months(12)
Base.Test.@test weeks(y) == weeks(52)
Base.Test.@test days(y) == days(365)
#wrapping
Base.Test.@test addwrap(1,11) == 12 #month 1 plus 11 months == month 12
Base.Test.@test addwrap(1,12) == 1  #month 1 plus 12 months == month 1
Base.Test.@test addwrap(1,24) == 1  #month 1 plus 24 months == month 1
Base.Test.@test subwrap(12,1) == 11 #month 12 minus 1 month == month 11
Base.Test.@test addwrap(2000,12,1) == 2001 #year 2000 month 12 plus 1 month == year 2001

#Date tests
dt = date(1,1,1)
Base.Test.@test convert(Date,1) == dt
Base.Test.@test convert(Date,int32(1)) == dt
Base.Test.@test convert(Date,float32(1)) == dt
dt2 = convert(Date{Calendar},float64(1))
Base.Test.@test typeof(dt2) == Date{Calendar}
a,b = promote(dt,dt2) #checks 2 diff calendars promotion
Base.Test.@test typeof(a) == Date{ISOCalendar}
Base.Test.@test typeof(b) == Date{ISOCalendar}
Base.Test.@test dt == dt2
Base.Test.@test dt - dt2 == days(0)
Base.Test.@test !(dt > dt2)
Base.Test.@test length(dt) == 1
Base.Test.@test convert(Date,0) == date(year(0),month(12),day(31))
Base.Test.@test convert(Date,-1) == date(0,12,30)
Base.Test.@test_throws MethodError dt2 + y #Diff calendars
dt3 = datetime(1,1,1)
Base.Test.@test convert(DateTime,86400000) == dt3
dt4 = convert(DateTime{Calendar,UTC},float64(86400000))
Base.Test.@test typeof(dt4) == DateTime{Calendar,UTC}
a,b = promote(dt3,dt4) #checks 2 diff calendars promotion
Base.Test.@test typeof(a) == DateTime{ISOCalendar,UTC}
Base.Test.@test typeof(b) == DateTime{ISOCalendar,UTC}
Base.Test.@test dt3 == dt4
Base.Test.@test dt3 - dt4 == seconds(0)
Base.Test.@test !(dt3 > dt4)
Base.Test.@test length(dt3) == 1
a,b = promote(dt,dt3) #promote Date => DateTime
Base.Test.@test typeof(a) == DateTime{ISOCalendar,UTC}
Base.Test.@test typeof(b) == DateTime{ISOCalendar,UTC}
Base.Test.@test date(dt3) == dt
Base.Test.@test datetime(dt) == dt3
Base.Test.@test dt == dt3
Base.Test.@test !(dt > dt3)
Base.Test.@test dt - dt3 == seconds(0)

check = (-252522163911150,-1,0,1,252522163911149)
for (i,x) in enumerate(check)
	yd = Datetime.yeardays(x-1)
	md = Datetime.monthdays[1]
	d = 1
	td = Datetime.totaldays(x,1,1)
	Base.Test.@test d + md + yd - 306 == td
	Base.Test.@test td == (-92231826452318568,-730,-365,1,92231826452317474)[i]
	Base.Test.@test Datetime._year(td) == x
	Base.Test.@test Datetime._month(td) == 1
	Base.Test.@test Datetime._day(td) == 1
	Base.Test.@test Datetime._day2date(td) == (x,1,1)
	Base.Test.@test Datetime._week(td) == (1,1,1,1,53)[i]
end
Base.Test.@test isleap(-4)
Base.Test.@test isleap(0)
Base.Test.@test isleap(4)
Base.Test.@test !isleap(100)
Base.Test.@test isleap(400)
Base.Test.@test isleap(2000)
Base.Test.@test !isleap(2100)

dt = date(2013,7,1)
Base.Test.@test year(dt) == 2013
Base.Test.@test month(dt) == 7
Base.Test.@test day(dt) == 1
Base.Test.@test Datetime._days(dt) == 735050 == int64(dt)
Base.Test.@test string(dt) == "2013-07-01"
Base.Test.@test week(dt) == 27
Base.Test.@test isdate(dt)
Base.Test.@test calendar(dt) == ISOCalendar
Base.Test.@test typemax(Date) == date(252522163911149,12,31)
Base.Test.@test typemin(Date) == date(-252522163911150,1,1)
Base.Test.@test isleap(dt) == false
Base.Test.@test lastdayofmonth(dt) == 31
Base.Test.@test dayofweek(dt) == 1
Base.Test.@test dayofweekinmonth(dt) == 1
Base.Test.@test daysofweekinmonth(dt) == 5
Base.Test.@test firstdayofweek(dt) == dt
Base.Test.@test lastdayofweek(dt) == dt + days(6)
Base.Test.@test dayofyear(dt) == 182
Base.Test.@test typeof(today()) <: Date
dt = date(2012,2,29)
dt2 = date(2000,2,1)
Base.Test.@test dt > dt2
Base.Test.@test dt != dt2
Base.Test.@test year(-dt) == -2012
Base.Test.@test +dt == dt
Base.Test.@test dt - dt2 == 4411
Base.Test.@test dt > dt2
Base.Test.@test dt2 < dt
Base.Test.@test dt2 - year(3) == date(1997,2,1)
Base.Test.@test dt + year(1) == date(2013,2,28)
Base.Test.@test year(3) - dt2 == dt2 - year(3)
Base.Test.@test dt2 - months(3) == date(1999,11,1)
Base.Test.@test months(11) + dt == date(2013,1,29)
Base.Test.@test months(8) + dt == dt + months(8)
Base.Test.@test dt2 + days(4411) == date(2012,2,29)
Base.Test.@test dt2 + days(4412) == date(2012,3,1)
Base.Test.@test dt2 + weeks(52) == date(2001,1,30)
Base.Test.@test dt2 + weeks(104) == date(2002,1,29)
Base.Test.@test dt2 - year(4) + days(366) == date(1997,2,1)
Base.Test.@test dt2 - (year(4) - days(366)) == date(1997,2,2) #non-associative
dt = date(1999,12,27)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2000,12,25)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2030,12,23)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2004,12,20)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
#Simple Date parsing
a = "2005-01-31"
b = "2005/31/01"
c = "01.31.2005"
d = "31 01 2005"
aa = "2005,1,31"
bb = "2005-31-1"
cc = "1-31-2005"
dd = "31-1-2005"
aaa = "05-01-31"
bbb = "05/31/01"
ccc = "01.31.05"
ddd = "31 01 05"
e = "20050131"
ee = "2005131"
for i in (a,b,c,d,aa,bb,cc,dd,ccc,ddd)
	Base.Test.@test date(i) == date(2005,1,31)
end	
Base.Test.@test date(aaa) == date(2031,5,1)
Base.Test.@test date(bbb) == date(2001,5,31)

#DateRange
dt1 = date(2000,1,1)
dt2 = date(2010,1,1)
y = year(1)
r = dt1:y:dt2
Base.Test.@test first(r) == date(2000,1,1)
Base.Test.@test last(r) == date(2010,1,1)
Base.Test.@test typeof(r.step) == Year{ISOCalendar}
Base.Test.@test length(r) == 11
dt2 = date(2001,1,1)
r = dt1:month(1):dt2
Base.Test.@test length(r) == 13
Base.Test.@test last(r) == date(2001,1,1)
Base.Test.@test typeof(r.step) == Month{ISOCalendar}
r = dt1:weeks(2):dt2
Base.Test.@test length(r) == 27
Base.Test.@test last(r) == date(2000,12,30)
Base.Test.@test typeof(r.step) == Week{ISOCalendar}
dt2 = date(2000,3,1)
r = dt2:day(-1):dt1
Base.Test.@test length(r) == 61
Base.Test.@test last(r) == date(2000,1,1)
Base.Test.@test typeof(r.step) == Day{ISOCalendar}
Base.Test.@test last(r + year(1)) == date(2000,12,31)
dt = date(2009,1,1)
dt2 = date(2013,1,1)
MemorialDay = x->month(x)==May && dayofweek(x)==Monday && dayofweekinmonth(x)==daysofweekinmonth(x)
f = dt:MemorialDay:dt2
Base.Test.@test typeof(f) == DateRange1{ISOCalendar}
Base.Test.@test [f] == [date(2009,5,25),date(2010,5,31),date(2011,5,30),date(2012,5,28)]
Base.Test.@test length(f) == 4
Base.Test.@test last(f) == date(2012,5,28)
Base.Test.@test typeof(f.step) == Function
Thanksgiving = x->dayofweek(x)==Thursday && month(x)==November && dayofweekinmonth(x)==4
f = dt:Thanksgiving:dt2
Base.Test.@test [f] == [date(2009,11,26),date(2010,11,25),date(2011,11,24),date(2012,11,22)]
Base.Test.@test length(f) == 4
Base.Test.@test last(f) == date(2012,11,22)
ff = recur(dt:dt2) do x
	dayofweek(x)==4 && 
	month(x)==11 && 
	dayofweekinmonth(x)==4
end
Base.Test.@test [ff] == [f]
#DateTime
dt = datetime(2013,7,1)
Base.Test.@test year(dt) == 2013
Base.Test.@test month(dt) == 7
Base.Test.@test day(dt) == 1
Base.Test.@test hour(dt) == 0
Base.Test.@test minute(dt) == 0
Base.Test.@test second(dt) == 0
Base.Test.@test string(dt) == "2013-07-01T00:00:00 UTC"
Base.Test.@test Datetime._days(dt) == 735050 == fld(int64(dt),86400000)
Base.Test.@test week(dt) == 27
Base.Test.@test isdatetime(dt)
Base.Test.@test calendar(dt) == ISOCalendar
Base.Test.@test timezone(dt) == Datetime.Zone0
Base.Test.@test typemax(DateTime) == datetime(292277024,12,31,23,59,59)
Base.Test.@test typemin(DateTime) == datetime(-292277023,1,1,0,0,0)
Base.Test.@test isleap(dt) == false
Base.Test.@test lastdayofmonth(dt) == 31
Base.Test.@test dayofweek(dt) == 1
Base.Test.@test dayofweekinmonth(dt) == 1
Base.Test.@test daysofweekinmonth(dt) == 5
Base.Test.@test firstdayofweek(dt) == dt
Base.Test.@test lastdayofweek(dt) == dt + days(6)
Base.Test.@test dayofyear(dt) == 182
Base.Test.@test typeof(now()) <: DateTime
Base.Test.@test int64(dt) == 63508320025000
Base.Test.@test second(datetime(1972,6,30,22,58,60)) == 0 #entering "invalid" periods just rolls the date forward
dt = datetime(2012,2,29)
dt2 = datetime(2000,2,1)
Base.Test.@test dt > dt2
Base.Test.@test dt != dt2
Base.Test.@test isdatetime(dt)
Base.Test.@test calendar(dt) == ISOCalendar
Base.Test.@test year(-dt) == -2012
Base.Test.@test +dt == dt
Base.Test.@test dt - dt2 == 381110402000
Base.Test.@test dt > dt2
Base.Test.@test dt2 < dt
Base.Test.@test dt2 - year(3) == datetime(1997,2,1)
Base.Test.@test dt + year(1) == datetime(2013,2,28)
Base.Test.@test year(3) - dt2 == dt2 - year(3)
Base.Test.@test dt2 - months(3) == datetime(1999,11,1)
Base.Test.@test months(11) + dt == datetime(2013,1,29)
Base.Test.@test months(8) + dt == dt + months(8)
Base.Test.@test dt2 + days(4411) == datetime(2012,2,29)
Base.Test.@test dt2 + days(4412) == datetime(2012,3,1)
Base.Test.@test dt2 + weeks(52) == datetime(2001,1,30)
Base.Test.@test dt2 + weeks(104) == datetime(2002,1,29)
Base.Test.@test dt2 - year(4) + days(366) == datetime(1997,2,1)
Base.Test.@test dt2 - (year(4) - days(366)) == datetime(1997,2,2) #non-associative
dt = datetime(1999,12,27,0,0,0)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2000,12,25,0,0,0)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2030,12,23,0,0,0)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2004,12,20,0,0,0)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	Base.Test.@test week(dt) == check[i]
	dt = dt + day(1)
end

#Leap second support
# _lm = 
# [1972 6 30 23 59 59;
# 1972 12 31 23 59 59;
# 1973 12 31 23 59 59;
# 1974 12 31 23 59 59;
# 1975 12 31 23 59 59;
# 1976 12 31 23 59 59;
# 1977 12 31 23 59 59;
# 1978 12 31 23 59 59;
# 1979 12 31 23 59 59;
# 1981 6 30 23 59 59;
# 1982 6 30 23 59 59;
# 1983 6 30 23 59 59;
# 1985 6 30 23 59 59;
# 1987 12 31 23 59 59;
# 1989 12 31 23 59 59;
# 1990 12 31 23 59 59;
# 1992 6 30 23 59 59;
# 1993 6 30 23 59 59;
# 1994 6 30 23 59 59;
# 1995 12 31 23 59 59;
# 1997 6 30 23 59 59;
# 1998 12 31 23 59 59;
# 2005 12 31 23 59 59;
# 2008 12 31 23 59 59;
# 2012 6 30 23 59 59]
# #Generate leap moments in microsends
# _leapmoments = ref(Int64) #1 sec before a leap second in a timeline that ignores leap seconds
# _leapmoments1 = ref(Int64) #leap second moment in leap second timeline
# for i in 1:size(_lm)[1]
# 	l = 1000*(_lm[i,6] + 
# 		60*_lm[i,5] + 3600*_lm[i,4] + 
# 		86400*totaldays(_lm[i,1],_lm[i,2],_lm[i,3]))
# 	push!(_leapmoments,l)
# 	push!(_leapmoments1,l+(1000*length(_leapmoments)))
# end
q = datetime(1972,6,30,23,59,58)
t = datetime(1972,6,30,23,59,59)
Base.Test.@test t - q == 1000
Base.Test.@test t == t
r = datetime(1972,7,1,0,0,0)
Base.Test.@test r - t == 2000 #Includes leap second
n = datetime(1972,6,30,23,59,60)
Base.Test.@test n - t == 1000
Base.Test.@test r - n == 1000
a = datetime(1972,12,31,23,59,59)
b = datetime(1972,12,31,23,59,60)
c = datetime(1973,1,1,0,0,0)
d = datetime(1973,1,1,0,0,1)
Base.Test.@test c - b == 1000
Base.Test.@test b - a == 1000
a = datetime(1982,6,30,23,59,59)
b = datetime(1982,6,30,23,59,60)
c = datetime(1982,7,1,0,0,0)
Base.Test.@test c - b == 1000
Base.Test.@test b - a == 1000

#Offsets
TZ = CST
a = datetime(1972,12,31,17,59,59,0,TZ)
b = datetime(1972,12,31,17,59,60,0,TZ)
c = datetime(1972,12,31,18,0,0,0,TZ)
d = datetime(1972,12,31,18,0,1,0,TZ)
Base.Test.@test c - b == 1000
Base.Test.@test b - a == 1000
Base.Test.@test c - a == 2000 #Includes leap second
bb = timezone(b,PST)
Base.Test.@test bb == b
bb = timezone(b,"Pacific/Honolulu")
Base.Test.@test bb == b
bb = offset(b,Offset{-360})
Base.Test.@test bb == b
Base.Test.@test string(bb) == "1972-12-31T17:59:60 -06:00"
aa = offset(a,Offset{-360})
Base.Test.@test aa == a
Base.Test.@test offset(a,Offset{-600}) == timezone(a,"Pacific/Honolulu")
Base.Test.@test offset(a,offset(hours(10))) == timezone(a,"Pacific/Honolulu")
Base.Test.@test timezone(datetime(2013,7,6,0,0,0,0,"America/Chicago")) == CDT

#Daylight savings time
t1 = datetime(1920,6,13,1,59,59,0,CST)
t2 = datetime(1920,6,13,2,0,0,0,CST)
t3 = datetime(1920,6,13,3,0,0,0,CST)
Base.Test.@test t2 - t1 == 1000
Base.Test.@test t3 - t1 == 1000
Base.Test.@test t3 == t2
Base.Test.@test t1 + second(1) == t2
Base.Test.@test t1 + second(1) == t3
t4 = datetime(1920,6,13,4,0,0,0,CST)
Base.Test.@test t4 - hour(1) == t3

#Conversion from Unix time
# _ = time()
# tt = unix2datetime(1000*int64(_),TZ)
# ttt = TmStruct(_)
# Base.Test.@test year(tt) == int("20"*string(digits(ttt.year)[2])*string(digits(ttt.year)[1]))
# Base.Test.@test month(tt) == ttt.month+1
# Base.Test.@test day(tt) == ttt.mday
# Base.Test.@test hour(tt) == ttt.hour
# Base.Test.@test minute(tt) == ttt.min
# Base.Test.@test second(tt) == ttt.sec #second may be off by 1, not sure why
#DateTimeRange
dt1 = datetime(2000,1,1)
dt2 = datetime(2010,1,1)
y = year(1)
r = dt1:y:dt2
Base.Test.@test first(r) == datetime(2000,1,1)
Base.Test.@test last(r) == datetime(2010,1,1)
Base.Test.@test typeof(r.step) == Year{ISOCalendar}
Base.Test.@test length(r) == 11
dt2 = datetime(2001,1,1)
r = dt1:month(1):dt2
Base.Test.@test length(r) == 13
Base.Test.@test last(r) == datetime(2001,1,1)
Base.Test.@test typeof(r.step) == Month{ISOCalendar}
r = dt1:weeks(2):dt2
Base.Test.@test length(r) == 27
Base.Test.@test last(r) == datetime(2000,12,30)
Base.Test.@test typeof(r.step) == Week{ISOCalendar}
dt2 = datetime(2000,3,1)
r = dt2:day(-1):dt1
Base.Test.@test length(r) == 61
Base.Test.@test last(r) == datetime(2000,1,1)
Base.Test.@test typeof(r.step) == Day{ISOCalendar}
Base.Test.@test last(r + year(1)) == datetime(2000,12,31)
dt2 = datetime(2000,1,31)
r = dt1:hours(24):dt2
Base.Test.@test length(r) == 31
Base.Test.@test last(r) == datetime(2000,1,31)
Base.Test.@test typeof(r.step) == Hour{ISOCalendar}
r = dt1:minutes(1440):dt2
Base.Test.@test length(r) == 31
Base.Test.@test last(r) == datetime(2000,1,31)
Base.Test.@test typeof(r.step) == Minute{ISOCalendar}
r = dt1:seconds(86400):dt2
Base.Test.@test length(r) == 31
Base.Test.@test last(r) == datetime(2000,1,31)
Base.Test.@test typeof(r.step) == Second{ISOCalendar}

#Test for 32 bit issues #20
datetime(int32(2013),int32(10),int32(27),int32(11),int32(10),int32(9))
datetime(int32(2013),int32(10),int32(27),int32(11),int32(10),int32(9), int32(8), timezone("UTC"))

#Test for date->DateTime conversion w/ leap seconds
Base.Test.@test date(datetime(date(2012,7,1))) == date(2012,7,1)

#Test for date->DateTime conversion w/ Timezone
Base.Test.@test datetime(date(2012,7,1),EST) == datetime(2012,7,1,4,0,0,0)
Base.Test.@test datetime(date(2012,7,1),"America/New_York") == datetime(2012,7,1,4,0,0,0)

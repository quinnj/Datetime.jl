using Datetime
using Base.Test
y = year(1)
m = months(1)
w = weeks(1)
d = days(1)
h = hour(1)
mi = minute(1)
s = second(1)

#Period arithmetic
@test typeof(y+m) ==  Month{ISOCalendar}
@test typeof(m+y) ==  Month{ISOCalendar}
@test typeof(y+w) ==  Week{ISOCalendar}
@test typeof(y+d) ==  Day{ISOCalendar}
@test typeof(y+h) ==  Hour{ISOCalendar}
@test typeof(y+mi) == Minute{ISOCalendar}
@test typeof(y+s) ==  Second{ISOCalendar}
@test_throws MethodError typeof(m+w)
@test_throws MethodError typeof(m+d)
@test_throws MethodError typeof(m+h)
@test_throws MethodError typeof(m+mi)
@test_throws MethodError typeof(m+s)
@test typeof(w+d) ==  Day{ISOCalendar}
@test typeof(w+h) ==  Hour{ISOCalendar}
@test typeof(w+mi) ==  Minute{ISOCalendar}
@test typeof(w+s) ==  Second{ISOCalendar}
@test typeof(d+h) ==  Hour{ISOCalendar}
@test typeof(d+mi) ==  Minute{ISOCalendar}
@test typeof(d+s) ==  Second{ISOCalendar}
@test typeof(h+mi) ==  Minute{ISOCalendar}
@test typeof(h+s) ==  Second{ISOCalendar}
@test typeof(mi+s) ==  Second{ISOCalendar}
@test y * m*months(2) == months(24)
@test y * w*weeks(2) == weeks(104)
@test y * d*days(2) == days(730)
@test y > m
@test d < w
@test typemax(Year) == 2147483647
@test typemax(Year) + y == -2147483648
@test typemin(Year) == -2147483648
q = convert(Year{Calendar},1)
@test typeof(q) == Year{Calendar}
y,q = promote(y,q) #check periods w/ diff calendars
@test typeof(q) == Year{ISOCalendar}
@test typeof(y) == Year{ISOCalendar}
@test q + y == years(2)
#Period-Real arithmetic
@test y + 1 == 2
@test 1 + y == 2
@test y + 1.0 == 2.0
@test y * 4 == 4
@test y * 4f0 == 4.0f0
@test y * 3//4 == year(1)
@test y / 2 == year(1)
@test 2 / y == 2
@test y / y == 1
@test y*10 % 5 == 0
@test 5 % y*10 == 0
@test !(y > 3)
@test 4 > y
#PeriodRange
t = year(100)
r = y:t
@test size(r) == (100,)
@test length(r) == 100
@test step(r) == year(1)
@test first(r) == y
@test last(r) == t
@test first(r + y) == year(2)
@test last(r + y) == year(101)
@test last(y:year(2):t) == year(99)
@test [year(0):year(25):t][4] == year(75)
@test_throws MethodError y:m:t


#traits
@test zero(typeof(y)) == year(0)
@test one(typeof(y)) == y
@test months(y) == months(12)
@test weeks(y) == weeks(52)
@test days(y) == days(365)

# Wrapping arithemtic for Months
# This ends up being trickier than expected because
# the user might do 2014-01-01 + Month(-14)
# monthwrap figures out the resulting month
# when adding/subtracting months from a date
@test Datetime.monthwrap(1,-14) == 11
@test Datetime.monthwrap(1,-13) == 12
@test Datetime.monthwrap(1,-12) == 1
@test Datetime.monthwrap(1,-11) == 2
@test Datetime.monthwrap(1,-10) == 3
@test Datetime.monthwrap(1,-9) == 4
@test Datetime.monthwrap(1,-8) == 5
@test Datetime.monthwrap(1,-7) == 6
@test Datetime.monthwrap(1,-6) == 7
@test Datetime.monthwrap(1,-5) == 8
@test Datetime.monthwrap(1,-4) == 9
@test Datetime.monthwrap(1,-3) == 10
@test Datetime.monthwrap(1,-2) == 11
@test Datetime.monthwrap(1,-1) == 12
@test Datetime.monthwrap(1,0) == 1
@test Datetime.monthwrap(1,1) == 2
@test Datetime.monthwrap(1,2) == 3
@test Datetime.monthwrap(1,3) == 4
@test Datetime.monthwrap(1,4) == 5
@test Datetime.monthwrap(1,5) == 6
@test Datetime.monthwrap(1,6) == 7
@test Datetime.monthwrap(1,7) == 8
@test Datetime.monthwrap(1,8) == 9
@test Datetime.monthwrap(1,9) == 10
@test Datetime.monthwrap(1,10) == 11
@test Datetime.monthwrap(1,11) == 12
@test Datetime.monthwrap(1,12) == 1
@test Datetime.monthwrap(1,13) == 2
@test Datetime.monthwrap(1,24) == 1
@test Datetime.monthwrap(12,-14) == 10
@test Datetime.monthwrap(12,-13) == 11
@test Datetime.monthwrap(12,-12) == 12
@test Datetime.monthwrap(12,-11) == 1
@test Datetime.monthwrap(12,-2) == 10
@test Datetime.monthwrap(12,-1) == 11
@test Datetime.monthwrap(12,0) == 12
@test Datetime.monthwrap(12,1) == 1
@test Datetime.monthwrap(12,2) == 2
@test Datetime.monthwrap(12,11) == 11
@test Datetime.monthwrap(12,12) == 12
@test Datetime.monthwrap(12,13) == 1

# yearwrap figures out the resulting year
# when adding/subtracting months from a date
@test Datetime.yearwrap(2000,1,-3600) == 1700
@test Datetime.yearwrap(2000,1,-37) == 1996
@test Datetime.yearwrap(2000,1,-36) == 1997
@test Datetime.yearwrap(2000,1,-35) == 1997
@test Datetime.yearwrap(2000,1,-25) == 1997
@test Datetime.yearwrap(2000,1,-24) == 1998
@test Datetime.yearwrap(2000,1,-23) == 1998
@test Datetime.yearwrap(2000,1,-14) == 1998
@test Datetime.yearwrap(2000,1,-13) == 1998
@test Datetime.yearwrap(2000,1,-12) == 1999
@test Datetime.yearwrap(2000,1,-11) == 1999
@test Datetime.yearwrap(2000,1,-2) == 1999
@test Datetime.yearwrap(2000,1,-1) == 1999
@test Datetime.yearwrap(2000,1,0) == 2000
@test Datetime.yearwrap(2000,1,1) == 2000
@test Datetime.yearwrap(2000,1,11) == 2000
@test Datetime.yearwrap(2000,1,12) == 2001
@test Datetime.yearwrap(2000,1,13) == 2001
@test Datetime.yearwrap(2000,1,23) == 2001
@test Datetime.yearwrap(2000,1,24) == 2002
@test Datetime.yearwrap(2000,1,25) == 2002
@test Datetime.yearwrap(2000,1,36) == 2003
@test Datetime.yearwrap(2000,1,3600) == 2300
@test Datetime.yearwrap(2000,2,-2) == 1999
@test Datetime.yearwrap(2000,3,10) == 2001
@test Datetime.yearwrap(2000,4,-4) == 1999
@test Datetime.yearwrap(2000,5,8) == 2001
@test Datetime.yearwrap(2000,6,-18) == 1998
@test Datetime.yearwrap(2000,6,-6) == 1999
@test Datetime.yearwrap(2000,6,6) == 2000
@test Datetime.yearwrap(2000,6,7) == 2001
@test Datetime.yearwrap(2000,6,19) == 2002
@test Datetime.yearwrap(2000,12,-3600) == 1700
@test Datetime.yearwrap(2000,12,-36) == 1997
@test Datetime.yearwrap(2000,12,-35) == 1998
@test Datetime.yearwrap(2000,12,-24) == 1998
@test Datetime.yearwrap(2000,12,-23) == 1999
@test Datetime.yearwrap(2000,12,-14) == 1999
@test Datetime.yearwrap(2000,12,-13) == 1999
@test Datetime.yearwrap(2000,12,-12) == 1999
@test Datetime.yearwrap(2000,12,-11) == 2000
@test Datetime.yearwrap(2000,12,-2) == 2000
@test Datetime.yearwrap(2000,12,-1) == 2000
@test Datetime.yearwrap(2000,12,0) == 2000
@test Datetime.yearwrap(2000,12,1) == 2001
@test Datetime.yearwrap(2000,12,11) == 2001
@test Datetime.yearwrap(2000,12,12) == 2001
@test Datetime.yearwrap(2000,12,13) == 2002
@test Datetime.yearwrap(2000,12,24) == 2002
@test Datetime.yearwrap(2000,12,25) == 2003
@test Datetime.yearwrap(2000,12,36) == 2003
@test Datetime.yearwrap(2000,12,37) == 2004
@test Datetime.yearwrap(2000,12,3600) == 2300

#Date tests
dt = date(1,1,1)
@test convert(Date,1) == dt
@test convert(Date,int32(1)) == dt
@test convert(Date,float32(1)) == dt
dt2 = convert(Date{Calendar},float64(1))
@test typeof(dt2) == Date{Calendar}
a,b = promote(dt,dt2) #checks 2 diff calendars promotion
@test typeof(a) == Date{ISOCalendar}
@test typeof(b) == Date{ISOCalendar}
@test dt == dt2
@test dt - dt2 == days(0)
@test !(dt > dt2)
@test length(dt) == 1
@test convert(Date,0) == date(year(0),month(12),day(31))
@test convert(Date,-1) == date(0,12,30)
@test_throws MethodError dt2 + y #Diff calendars
dt3 = datetime(1,1,1)
@test convert(DateTime,86400000) == dt3
dt4 = convert(DateTime{Calendar,UTC},float64(86400000))
@test typeof(dt4) == DateTime{Calendar,UTC}
a,b = promote(dt3,dt4) #checks 2 diff calendars promotion
@test typeof(a) == DateTime{ISOCalendar,UTC}
@test typeof(b) == DateTime{ISOCalendar,UTC}
@test dt3 == dt4
@test dt3 - dt4 == seconds(0)
@test !(dt3 > dt4)
@test length(dt3) == 1
a,b = promote(dt,dt3) #promote Date => DateTime
@test typeof(a) == DateTime{ISOCalendar,UTC}
@test typeof(b) == DateTime{ISOCalendar,UTC}
@test date(dt3) == dt
@test datetime(dt) == dt3
@test dt == dt3
@test !(dt > dt3)
@test dt - dt3 == seconds(0)

check = (-252522163911150,-1,0,1,252522163911149)
for (i,x) in enumerate(check)
	yd = Datetime.yeardays(x-1)
	md = Datetime.monthdays[1]
	d = 1
	td = Datetime.totaldays(x,1,1)
	@test d + md + yd - 306 == td
	@test td == (-92231826452318568,-730,-365,1,92231826452317474)[i]
	@test Datetime._year(td) == x
	@test Datetime._month(td) == 1
	@test Datetime._day(td) == 1
	@test Datetime._day2date(td) == (x,1,1)
	@test Datetime._week(td) == (1,1,1,1,53)[i]
end
@test isleap(-4)
@test isleap(0)
@test isleap(4)
@test !isleap(100)
@test isleap(400)
@test isleap(2000)
@test !isleap(2100)

dt = date(2013,7,1)
@test year(dt) == 2013
@test month(dt) == 7
@test day(dt) == 1
@test Datetime._days(dt) == 735050 == int64(dt)
@test string(dt) == "2013-07-01"
@test week(dt) == 27
@test isdate(dt)
@test calendar(dt) == ISOCalendar
@test typemax(Date) == date(252522163911149,12,31)
@test typemin(Date) == date(-252522163911150,1,1)
@test isleap(dt) == false
@test lastdayofmonth(dt) == 31
@test dayofweek(dt) == 1
@test dayofweekinmonth(dt) == 1
@test daysofweekinmonth(dt) == 5
@test firstdayofweek(dt) == dt
@test lastdayofweek(dt) == dt + days(6)
@test dayofyear(dt) == 182
@test typeof(today()) <: Date
dt = date(2012,2,29)
dt2 = date(2000,2,1)
@test dt > dt2
@test dt != dt2
@test year(-dt) == -2012
@test +dt == dt
@test dt - dt2 == 4411
@test dt > dt2
@test dt2 < dt
@test dt2 - year(3) == date(1997,2,1)
@test dt + year(1) == date(2013,2,28)
@test year(3) - dt2 == dt2 - year(3)
@test dt2 - months(3) == date(1999,11,1)
@test months(11) + dt == date(2013,1,29)
@test months(8) + dt == dt + months(8)
@test dt2 + days(4411) == date(2012,2,29)
@test dt2 + days(4412) == date(2012,3,1)
@test dt2 + weeks(52) == date(2001,1,30)
@test dt2 + weeks(104) == date(2002,1,29)
@test dt2 - year(4) + days(366) == date(1997,2,1)
@test dt2 - (year(4) - days(366)) == date(1997,2,2) #non-associative
dt = date(1999,12,27)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2000,12,25)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2030,12,23)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2004,12,20)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	@test week(dt) == check[i]
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
	@test date(i) == date(2005,1,31)
end	
@test date(aaa) == date(2031,5,1)
@test date(bbb) == date(2001,5,31)

#DateRange
dt1 = date(2000,1,1)
dt2 = date(2010,1,1)
y = year(1)
r = dt1:y:dt2
@test first(r) == date(2000,1,1)
@test last(r) == date(2010,1,1)
@test typeof(r.step) == Year{ISOCalendar}
@test length(r) == 11
dt2 = date(2001,1,1)
r = dt1:month(1):dt2
@test length(r) == 13
@test last(r) == date(2001,1,1)
@test typeof(r.step) == Month{ISOCalendar}
r = dt1:weeks(2):dt2
@test length(r) == 27
@test last(r) == date(2000,12,30)
@test typeof(r.step) == Week{ISOCalendar}
dt2 = date(2000,3,1)
r = dt2:day(-1):dt1
@test length(r) == 61
@test last(r) == date(2000,1,1)
@test typeof(r.step) == Day{ISOCalendar}
@test last(r + year(1)) == date(2000,12,31)
dt = date(2009,1,1)
dt2 = date(2013,1,1)
MemorialDay = x->month(x)==May && dayofweek(x)==Monday && dayofweekinmonth(x)==daysofweekinmonth(x)
f = dt:MemorialDay:dt2
@test typeof(f) == DateRange1{ISOCalendar}
@test [f] == [date(2009,5,25),date(2010,5,31),date(2011,5,30),date(2012,5,28)]
@test length(f) == 4
@test last(f) == date(2012,5,28)
@test typeof(f.step) == Function
Thanksgiving = x->dayofweek(x)==Thursday && month(x)==November && dayofweekinmonth(x)==4
f = dt:Thanksgiving:dt2
@test [f] == [date(2009,11,26),date(2010,11,25),date(2011,11,24),date(2012,11,22)]
@test length(f) == 4
@test last(f) == date(2012,11,22)
ff = recur(dt:dt2) do x
	dayofweek(x)==4 && 
	month(x)==11 && 
	dayofweekinmonth(x)==4
end
@test [ff] == [f]
#DateTime
dt = datetime(2013,7,1)
@test year(dt) == 2013
@test month(dt) == 7
@test day(dt) == 1
@test hour(dt) == 0
@test minute(dt) == 0
@test second(dt) == 0
@test string(dt) == "2013-07-01T00:00:00 UTC"
@test Datetime._days(dt) == 735050 == fld(int64(dt),86400000)
@test week(dt) == 27
@test isdatetime(dt)
@test calendar(dt) == ISOCalendar
@test timezone(dt) == Datetime.Zone0
@test typemax(DateTime) == datetime(292277024,12,31,23,59,59)
@test typemin(DateTime) == datetime(-292277023,1,1,0,0,0)
@test isleap(dt) == false
@test lastdayofmonth(dt) == 31
@test dayofweek(dt) == 1
@test dayofweekinmonth(dt) == 1
@test daysofweekinmonth(dt) == 5
@test firstdayofweek(dt) == dt
@test lastdayofweek(dt) == dt + days(6)
@test dayofyear(dt) == 182
@test typeof(now()) <: DateTime
@test int64(dt) == 63508320025000
@test second(datetime(1972,6,30,22,58,60)) == 0 #entering "invalid" periods just rolls the date forward
dt = datetime(2012,2,29)
dt2 = datetime(2000,2,1)
@test dt > dt2
@test dt != dt2
@test isdatetime(dt)
@test calendar(dt) == ISOCalendar
@test year(-dt) == -2012
@test +dt == dt
@test dt - dt2 == 381110402000
@test dt > dt2
@test dt2 < dt
@test dt2 - year(3) == datetime(1997,2,1)
@test dt + year(1) == datetime(2013,2,28)
@test year(3) - dt2 == dt2 - year(3)
@test dt2 - months(3) == datetime(1999,11,1)
@test months(11) + dt == datetime(2013,1,29)
@test months(8) + dt == dt + months(8)
@test dt2 + days(4411) == datetime(2012,2,29)
@test dt2 + days(4412) == datetime(2012,3,1)
@test dt2 + weeks(52) == datetime(2001,1,30)
@test dt2 + weeks(104) == datetime(2002,1,29)
@test dt2 - year(4) + days(366) == datetime(1997,2,1)
@test dt2 - (year(4) - days(366)) == datetime(1997,2,2) #non-associative
dt = datetime(1999,12,27,0,0,0)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2000,12,25,0,0,0)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2030,12,23,0,0,0)
for i = 1:21
	@test week(dt) == check[i]
	dt = dt + day(1)
end
dt = datetime(2004,12,20,0,0,0)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	@test week(dt) == check[i]
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
@test t - q == 1000
@test t == t
r = datetime(1972,7,1,0,0,0)
@test r - t == 2000 #Includes leap second
n = datetime(1972,6,30,23,59,60)
@test n - t == 1000
@test r - n == 1000
a = datetime(1972,12,31,23,59,59)
b = datetime(1972,12,31,23,59,60)
c = datetime(1973,1,1,0,0,0)
d = datetime(1973,1,1,0,0,1)
@test c - b == 1000
@test b - a == 1000
a = datetime(1982,6,30,23,59,59)
b = datetime(1982,6,30,23,59,60)
c = datetime(1982,7,1,0,0,0)
@test c - b == 1000
@test b - a == 1000

#Offsets
TZ = CST
a = datetime(1972,12,31,17,59,59,0,TZ)
b = datetime(1972,12,31,17,59,60,0,TZ)
c = datetime(1972,12,31,18,0,0,0,TZ)
d = datetime(1972,12,31,18,0,1,0,TZ)
@test c - b == 1000
@test b - a == 1000
@test c - a == 2000 #Includes leap second
bb = timezone(b,PST)
@test bb == b
bb = timezone(b,"Pacific/Honolulu")
@test bb == b
bb = offset(b,Offset{-360})
@test bb == b
@test string(bb) == "1972-12-31T17:59:60 -06:00"
aa = offset(a,Offset{-360})
@test aa == a
@test offset(a,Offset{-600}) == timezone(a,"Pacific/Honolulu")
@test offset(a,offset(hours(10))) == timezone(a,"Pacific/Honolulu")
@test timezone(datetime(2013,7,6,0,0,0,0,"America/Chicago")) == CDT

#Daylight savings time
t1 = datetime(1920,6,13,1,59,59,0,CST)
t2 = datetime(1920,6,13,2,0,0,0,CST)
t3 = datetime(1920,6,13,3,0,0,0,CST)
@test t2 - t1 == 1000
@test t3 - t1 == 1000
@test t3 == t2
@test t1 + second(1) == t2
@test t1 + second(1) == t3
t4 = datetime(1920,6,13,4,0,0,0,CST)
@test t4 - hour(1) == t3

#Conversion from Unix time
# _ = time()
# tt = unix2datetime(1000*int64(_),TZ)
# ttt = TmStruct(_)
# @test year(tt) == int("20"*string(digits(ttt.year)[2])*string(digits(ttt.year)[1]))
# @test month(tt) == ttt.month+1
# @test day(tt) == ttt.mday
# @test hour(tt) == ttt.hour
# @test minute(tt) == ttt.min
# @test second(tt) == ttt.sec #second may be off by 1, not sure why
#DateTimeRange
dt1 = datetime(2000,1,1)
dt2 = datetime(2010,1,1)
y = year(1)
r = dt1:y:dt2
@test first(r) == datetime(2000,1,1)
@test last(r) == datetime(2010,1,1)
@test typeof(r.step) == Year{ISOCalendar}
@test length(r) == 11
dt2 = datetime(2001,1,1)
r = dt1:month(1):dt2
@test length(r) == 13
@test last(r) == datetime(2001,1,1)
@test typeof(r.step) == Month{ISOCalendar}
r = dt1:weeks(2):dt2
@test length(r) == 27
@test last(r) == datetime(2000,12,30)
@test typeof(r.step) == Week{ISOCalendar}
dt2 = datetime(2000,3,1)
r = dt2:day(-1):dt1
@test length(r) == 61
@test last(r) == datetime(2000,1,1)
@test typeof(r.step) == Day{ISOCalendar}
@test last(r + year(1)) == datetime(2000,12,31)
dt2 = datetime(2000,1,31)
r = dt1:hours(24):dt2
@test length(r) == 31
@test last(r) == datetime(2000,1,31)
@test typeof(r.step) == Hour{ISOCalendar}
r = dt1:minutes(1440):dt2
@test length(r) == 31
@test last(r) == datetime(2000,1,31)
@test typeof(r.step) == Minute{ISOCalendar}
r = dt1:seconds(86400):dt2
@test length(r) == 31
@test last(r) == datetime(2000,1,31)
@test typeof(r.step) == Second{ISOCalendar}

#Test for 32 bit issues #20
datetime(int32(2013),int32(10),int32(27),int32(11),int32(10),int32(9))
datetime(int32(2013),int32(10),int32(27),int32(11),int32(10),int32(9), int32(8), timezone("UTC"))

#Test for date->DateTime conversion w/ leap seconds
@test date(datetime(date(2012,7,1))) == date(2012,7,1)

#Test for date->DateTime conversion w/ Timezone
@test datetime(date(2012,7,1),EST) == datetime(2012,7,1,4,0,0,0)
@test datetime(date(2012,7,1),"America/New_York") == datetime(2012,7,1,4,0,0,0)

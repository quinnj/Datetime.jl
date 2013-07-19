y = year(1)
m = month(1)
w = week(1)
d = day(1)
h = hour(1)
mi = minute(1)
s = second(1)

#Period arithmetic
Base.Test.@test typeof(y+m) == Month{ISOCalendar}
Base.Test.@test typeof(m+y) == Month{ISOCalendar}
Base.Test.@test typeof(y+w) == Week{ISOCalendar}
Base.Test.@test typeof(y+d) == Day{ISOCalendar}
Base.Test.@test typeof(y+h) == Hour{ISOCalendar}
Base.Test.@test typeof(y+mi) == Minute{ISOCalendar}
Base.Test.@test typeof(y+s) == Second{ISOCalendar}
Base.Test.@test_throws m+w
Base.Test.@test_throws m+d
Base.Test.@test_throws m+h
Base.Test.@test_throws m+mi
Base.Test.@test_throws m+s
Base.Test.@test typeof(w+d) == Day{ISOCalendar}
Base.Test.@test typeof(w+h) == Hour{ISOCalendar}
Base.Test.@test typeof(w+mi) == Minute{ISOCalendar}
Base.Test.@test typeof(w+s) == Second{ISOCalendar}
Base.Test.@test typeof(d+h) == Hour{ISOCalendar}
Base.Test.@test typeof(d+mi) == Minute{ISOCalendar}
Base.Test.@test typeof(d+s) == Second{ISOCalendar}
Base.Test.@test typeof(h+mi) == Minute{ISOCalendar}
Base.Test.@test typeof(h+s) == Second{ISOCalendar}
Base.Test.@test typeof(mi+s) == Second{ISOCalendar}
Base.Test.@test y + m == months(13)
Base.Test.@test y + w == weeks(53)
Base.Test.@test y + d == days(366)
Base.Test.@test y - m == months(11)
Base.Test.@test y - w == weeks(51)
Base.Test.@test y - d == days(364)
Base.Test.@test y * m*months(2) == months(24)
Base.Test.@test y * w*weeks(2) == weeks(104)
Base.Test.@test y * d*days(2) == days(730)
Base.Test.@test y > m
Base.Test.@test d < w
Base.Test.@test typemax(Year) == 2147483647
Base.Test.@test typemax(Year) + y == -2147483648
Base.Test.@test typemin(Year) == -2147483648
#Period-Real arithmetic
Base.Test.@test y + 1 == 2
Base.Test.@test 1 + y == 2
Base.Test.@test y + 1.0 == 2.0
Base.Test.@test y * 4 == 4
Base.Test.@test y * 4f0 == 4.0f0
Base.Test.@test y * 3//4 == 3//4
Base.Test.@test y / 2 == 0.5
Base.Test.@test 2 / y == 2
Base.Test.@test y*10 % 5 == 0
Base.Test.@test 5 % y*10 == 0
Base.Test.@test !(y > 3)
Base.Test.@test 4 > y
t = [y,y,y,y,y]
Base.Test.@test t .+ year(2) == [year(3),year(3),year(3),year(3),year(3)]

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
dt = date(2013,7,1)
Base.Test.@test year(dt) == 2013
Base.Test.@test month(dt) == 7
Base.Test.@test day(dt) == 1
Base.Test.@test string(dt) == "2013-07-01"
Base.Test.@test isleap(dt) == false
Base.Test.@test week(dt) == 27
Base.Test.@test dayofyear(dt) == 182
Base.Test.@test dayofweek(dt) == 1
Base.Test.@test int64(dt) == 735049
dt = date(2012,2,29)
dt2 = date(2000,2,1)
Base.Test.@test dt > dt2
Base.Test.@test dt != dt2
Base.Test.@test isdate(dt)
Base.Test.@test calendar(dt) == ISOCalendar
Base.Test.@test year(-dt) == -2012
Base.Test.@test +dt == dt
Base.Test.@test_throws dt + dt2
Base.Test.@test_throws dt * dt2
Base.Test.@test_throws dt / dt2
Base.Test.@test_throws dt + hour(1)
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
Base.Test.@test dt2 - month(1) + days(366) == date(2001,1,1)
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

dt = datetime(2013,7,1)
Base.Test.@test year(dt) == 2013
Base.Test.@test month(dt) == 7
Base.Test.@test day(dt) == 1
Base.Test.@test hour(dt) == 0
Base.Test.@test minute(dt) == 0
Base.Test.@test second(dt) == 0
Base.Test.@test string(dt) == "2013-07-01T00:00:00 UTC"
Base.Test.@test isleap(dt) == false
Base.Test.@test week(dt) == 27
Base.Test.@test dayofyear(dt) == 182
Base.Test.@test dayofweek(dt) == 1
Base.Test.@test int64(dt) == 63508233625
dt = datetime(2012,2,29)
dt2 = datetime(2000,2,1)
Base.Test.@test dt > dt2
Base.Test.@test dt != dt2
Base.Test.@test isdatetime(dt)
Base.Test.@test calendar(dt) == ISOCalendar
Base.Test.@test year(-dt) == -2012
Base.Test.@test +dt == dt

#Leap second support
q = datetime(1972,6,30,23,59,58)
t = datetime(1972,6,30,23,59,59)
Base.Test.@test t - q == 1
Base.Test.@test t == t
r = datetime(1972,7,1,0,0,0)
Base.Test.@test r - t == 2 #Includes leap second
n = datetime(1972,6,30,23,59,60)
Base.Test.@test n - t == 1
Base.Test.@test r - n == 1
a = datetime(1972,12,31,23,59,59)
b = datetime(1972,12,31,23,59,60)
c = datetime(1973,1,1,0,0,0)
d = datetime(1973,1,1,0,0,1)
Base.Test.@test c - b == 1
Base.Test.@test b - a == 1
a = datetime(1982,6,30,23,59,59)
b = datetime(1982,6,30,23,59,60)
c = datetime(1982,7,1,0,0,0)
Base.Test.@test c - b == 1
Base.Test.@test b - a == 1
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
#Timezone
TZ = CST
q = datetime(1972,6,30,18,59,58,TZ)
t = datetime(1972,6,30,18,59,59,TZ)
n = datetime(1972,6,30,18,59,60,TZ)
r = datetime(1972,6,30,19,0,0,TZ)
Base.Test.@test t - q == 1
Base.Test.@test t == t
Base.Test.@test r - t == 2 #Includes leap second
Base.Test.@test n - t == 1
Base.Test.@test r - n == 1
#Daylight savings time
t1 = datetime(1920,6,13,1,59,59,CST)
t2 = datetime(1920,6,13,2,0,0,CST)
t3 = datetime(1920,6,13,3,0,0,CST)
Base.Test.@test t2 - t1 == 1
Base.Test.@test t3 - t1 == 1
Base.Test.@test t3 == t2
Base.Test.@test t1 + second(1) == t2
Base.Test.@test t1 + second(1) == t3
t4 = datetime(1920,6,13,4,0,0,CST)
Base.Test.@test t4 - hour(1) == t3

#Conversion from Unix time
_ = time()
tt = unix2datetime(int64(_),TZ)
ttt = TmStruct(_)
Base.Test.@test year(tt) == int("20"*string(digits(ttt.year)[2])*string(digits(ttt.year)[1]))
Base.Test.@test month(tt) == ttt.month+1
Base.Test.@test day(tt) == ttt.mday
Base.Test.@test hour(tt) == ttt.hour
Base.Test.@test minute(tt) == ttt.min
#Base.Test.@test second(tt) == ttt.sec #second may be off by 1, not sure why

Base.Test.@test timezone(datetime(2013,7,6,0,0,0,"America/Chicago")) == CDT
Base.Test.@test second(datetime(1972,6,30,22,58,60)) == 0 #entering "invalid" periods just rolls the date forward

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

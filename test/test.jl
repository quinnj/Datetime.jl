y = year(1)
m = month(1)
w = week(1)
d = day(1)
h = hour(1)
mi = minute(1)
s = second(1)

#Period arithmetic
@assert typeof(y+m) == Month{ISOCalendar}
@assert typeof(m+y) == Month{ISOCalendar}
@assert typeof(y+w) == Week{ISOCalendar}
@assert typeof(y+d) == Day{ISOCalendar}
@assert typeof(y+h) == Hour{ISOCalendar}
@assert typeof(y+mi) == Minute{ISOCalendar}
@assert typeof(y+s) == Second{ISOCalendar}
Base.Test.@test_throws m+w
Base.Test.@test_throws m+d
Base.Test.@test_throws m+h
Base.Test.@test_throws m+mi
Base.Test.@test_throws m+s
@assert typeof(w+d) == Day{ISOCalendar}
@assert typeof(w+h) == Hour{ISOCalendar}
@assert typeof(w+mi) == Minute{ISOCalendar}
@assert typeof(w+s) == Second{ISOCalendar}
@assert typeof(d+h) == Hour{ISOCalendar}
@assert typeof(d+mi) == Minute{ISOCalendar}
@assert typeof(d+s) == Second{ISOCalendar}
@assert typeof(h+mi) == Minute{ISOCalendar}
@assert typeof(h+s) == Second{ISOCalendar}
@assert typeof(mi+s) == Second{ISOCalendar}
@assert y + m == months(13)
@assert y + w == weeks(53)
@assert y + d == days(366)
@assert y - m == months(11)
@assert y - w == weeks(51)
@assert y - d == days(364)
@assert y * m*2 == months(24)
@assert y * w*2 == weeks(104)
@assert y * d*2 == days(730)
@assert y > m
@assert d < w
@assert typemax(Year) == 2147483647
@assert typemax(Year) + y == -2147483648
@assert typemin(Year) == -2147483648
#Period-Real arithmetic
@assert y + 1 == 2
@assert 1 + y == 2
@assert y + 1.0 == 2.0
@assert y * 4 == 4
@assert y * 4f0 == 4.0f0
@assert y * 3//4 == 3//4
@assert y / 2 == 0.5
@assert 2 / y == 2
@assert y*10 % 5 == 0
@assert 5 % y*10 == 0
@assert !(y > 3)
@assert 4 > y
t = [y,y,y,y,y]
t .+ year(2)

#traits
@assert zero(typeof(y)) == year(0)
@assert one(typeof(y)) == y
@assert months(y) == months(12)
@assert weeks(y) == weeks(52)
@assert days(y) == days(365)
#wrapping
@assert addwrap(1,11) == 12 #month 1 plus 11 months == month 12
@assert addwrap(1,12) == 1  #month 1 plus 12 months == month 1
@assert addwrap(1,24) == 1  #month 1 plus 24 months == month 1
@assert subwrap(12,1) == 11 #month 12 minus 1 month == month 11
@assert addwrap(2000,12,1) == 2001 #year 2000 month 12 plus 1 month == year 2001

#Date tests
dt = date(2013,7,1)
@assert year(dt) == 2013
@assert month(dt) == 7
@assert day(dt) == 1
@assert string(dt) == "2013-07-01"
@assert isleap(dt) == false
@assert week(dt) == 27
@assert dayofyear(dt) == 182
@assert dayofweek(dt) == 1
@assert int64(dt) == 735049
dt = date(2012,2,29)
dt2 = date(2000,2,1)
@assert dt > dt2
@assert dt != dt2
@assert isdate(dt)
@assert calendar(dt) == ISOCalendar
@assert year(-dt) == -2012
@assert +dt == dt
Base.Test.@test_throws dt + dt2
Base.Test.@test_throws dt * dt2
Base.Test.@test_throws dt / dt2
Base.Test.@test_throws dt + hour(1)
@assert dt - dt2 == 4411
@assert dt > dt2
@assert dt2 < dt
@assert dt2 - year(3) == date(1997,2,1)
@assert dt + year(1) == date(2013,2,28)
@assert year(3) - dt2 == dt2 - year(3)
@assert dt2 - months(3) == date(1999,11,1)
@assert months(11) + dt == date(2013,1,29)
@assert months(8) + dt == dt + months(8)
@assert dt2 + days(4411) == date(2012,2,29)
@assert dt2 + days(4412) == date(2012,3,1)
@assert dt2 + weeks(52) == date(2001,1,30)
@assert dt2 + weeks(104) == date(2002,1,29)
@assert dt2 - month(1) + days(366) == date(2001,1,1)
dt = date(1999,12,27)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2000,12,25)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2030,12,23)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt + day(1)
end
dt = date(2004,12,20)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt + day(1)
end
#TODO: fix BCE dates/arithmetic; i.e. can't show 31st of month
# dt1 = date(2000,1,1)
# dt2 = date(2010,1,1)
# y = year(1)
# r = dt1:y:dt2
# @assert first(r) == date(2000,1,1)
# @assert last(r) == date(2010,1,1)
# @assert typeof(r.step) == Year{ISOCalendar}
# @assert length(r) == 11
# dt2 = date(2001,1,1)
# r = dt1:month(1):dt2
# @assert length(r) == 13
# @assert last(r) == date(2001,1,1)
# @assert typeof(r.step) == Month{ISOCalendar}
# r = dt1:weeks(2):dt2
# @assert length(r) == 27
# @assert last(r) == date(2000,12,30)
# @assert typeof(r.step) == Week{ISOCalendar}
# dt2 = date(2000,3,1)
# r = dt2:day(-1):dt1
# @assert length(r) == 61
# @assert last(r) == date(2000,1,1)
# @assert typeof(r.step) == Day{ISOCalendar}
# @assert last(r + year(1)) == date(2000,12,31)

q = datetime(1972,6,30,23,59,58)
t = datetime(1972,6,30,23,59,59)
@assert t - q == 1
@assert t == t
r = datetime(1972,7,1,0,0,0)
@assert r - t == 2 #Includes leap second
n = datetime(1972,6,30,23,59,60)
@assert n - t == 1
@assert r - n == 1
a = datetime(1972,12,31,23,59,59)
b = datetime(1972,12,31,23,59,60)
c = datetime(1973,1,1,0,0,0)
d = datetime(1973,1,1,0,0,1)
@assert c - b == 1
@assert b - a == 1
a = datetime(1982,6,30,23,59,59)
b = datetime(1982,6,30,23,59,60)
c = datetime(1982,7,1,0,0,0)
@assert c - b == 1
@assert b - a == 1
dt = datetime(1999,12,27,0,0,0)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt >> day(1)
end
dt = datetime(2000,12,25,0,0,0)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt >> day(1)
end
dt = datetime(2030,12,23,0,0,0)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt >> day(1)
end
dt = datetime(2004,12,20,0,0,0)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	@assert week(dt) == check[i]
	dt = dt >> day(1)
end
#Timezone
TZ = CST
q = datetime(1972,6,30,18,59,58,TZ)
t = datetime(1972,6,30,18,59,59,TZ)
n = datetime(1972,6,30,18,59,60,TZ)
r = datetime(1972,6,30,19,0,0,TZ)
@assert t - q == 1
@assert t == t
@assert r - t == 2 #Includes leap second
@assert n - t == 1
@assert r - n == 1
#Daylight savings time
t1 = datetime(1920,6,13,1,59,59,CST)
t2 = datetime(1920,6,13,2,0,0,CST)
t3 = datetime(1920,6,13,3,0,0,CST)
@assert t2 - t1 == 1
@assert t3 - t1 == 1
@assert t3 == t2
@assert t1 >> second(1) == t2
@assert t1 >> second(1) == t3
t4 = datetime(1920,6,13,4,0,0,CST)
@assert t4 << hour(1) == t3

#Conversion from Unix time
_ = time()
tt = unix2datetime(int64(_),TZ)
ttt = TmStruct(_)
@assert year(tt) == int("20"*string(digits(ttt.year)[2])*string(digits(ttt.year)[1]))
@assert month(tt) == ttt.month+1
@assert day(tt) == ttt.mday
@assert hour(tt) == ttt.hour
@assert minute(tt) == ttt.min
#@assert second(tt) == ttt.sec #second may be off by 1, not sure why

@assert timezone(datetime(2013,7,6,0,0,0,"America/Chicago")) == CDT
@assert second(datetime(1972,6,30,22,58,60)) == 0 #entering "invalid" periods just rolls the date forward

# dt1 = datetime(2000,1,1,0,0,0)
# dt2 = datetime(2000,12,1,0,0,0)
# m = month(1)
# r = dt1:m:dt2
# @assert first(r) == datetime(2000,1,1,0,0,0)
# @assert last(r) == datetime(2010,1,1,0,0,0)
# @assert typeof(r.step) == Year{ISOCalendar}
# @assert length(r) == 11
# dt2 = datetime(2001,1,1,0,0,0)
# r = dt1:month(1):dt2
# @assert length(r) == 13
# @assert last(r) == datetime(2001,1,1,0,0,0)
# @assert typeof(r.step) == Month{ISOCalendar}
# r = dt1:weeks(2):dt2
# @assert length(r) == 27
# @assert last(r) == datetime(2000,12,30,0,0,0)
# @assert typeof(r.step) == Week{ISOCalendar}
# dt2 = datetime(2000,3,1)
# r = dt2:day(-1):dt1
# @assert length(r) == 61
# @assert last(r) == datetime(2000,1,1,0,0,0)
# @assert typeof(r.step) == Day{ISOCalendar}
# @assert last(r + year(1)) == datetime(2000,12,31,0,0,0)
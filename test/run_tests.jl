using Base.Test
# Date internal algorithms
@test Dates.totaldays(0,2,28) == -307
@test Dates.totaldays(0,2,29) == -306
@test Dates.totaldays(0,3,1) == -305
@test Dates.totaldays(0,12,31) == 0
@test Dates.totaldays(1,1,1) == 1
@test Dates.totaldays(1,1,2) == 2
@test Dates.totaldays(2013,1,1) == 734869

@test Dates._day2date(-306) == (0,2,29)
@test Dates._day2date(-305) == (0,3,1)
@test Dates._day2date(-2) == (0,12,29)
@test Dates._day2date(-1) == (0,12,30)
@test Dates._day2date(0) == (0,12,31)
@test Dates._day2date(1) == (1,1,1)
@test Dates._year(-1) == 0
@test Dates._month(-1) == 12
@test Dates._day(-1) == 30
@test Dates._year(0) == 0
@test Dates._month(0) == 12
@test Dates._day(0) == 31
@test Dates._year(1) == 1
@test Dates._month(1) == 1
@test Dates._day(1) == 1
@test Dates._day2date(730120) == (2000,1,1)
@test Dates._year(730120) == 2000
@test Dates._month(730120) == 1
@test Dates._day(730120) == 1

function test_dates(from,to)
	y = m = d = 0
	test_day = Dates.totaldays(from,1,1)
	for y in from:to
		for m = 1:12
			for d = 1:Dates._lastdayofmonth(y,m)
				days = Dates.totaldays(y,m,d)
				@test days == test_day
				@test (y,m,d) == Dates._day2date(days)
				test_day += 1
			end
		end
	end
end
test_dates(-2000,2000)

test = Dates.DateTime{Dates.UTInstant{Dates.Millisecond},Dates.ISOCalendar}(Dates.UTInst(63492681600000))
@test Dates.DateTime(2013) == test
@test Dates.DateTime(2013,1) == test
@test Dates.DateTime(2013,1,1) == test
@test Dates.DateTime(2013,1,1,0) == test
@test Dates.DateTime(2013,1,1,0,0) == test
@test Dates.DateTime(2013,1,1,0,0,0) == test
@test Dates.DateTime(2013,1,1,0,0,0,0) == test
test = Dates.Date(Dates.Day(734869))
@test Dates.Date(2013) == test
@test Dates.Date(2013,1) == test
@test Dates.Date(2013,1,1) == test
@test string(Dates.Date(1,1,1)) == "0001-01-01" # January 1st, 1 AD/CE
@test string(Dates.Date(0,12,31)) == "0000-12-31" # December 31, 1 BC/BCE
@test Dates.Date(1,1,1) - Dates.Date(0,12,31) == Dates.Day(1)
@test Dates.Date(Dates.Day(-306)) == Dates.Date(0,2,29)
@test string(Dates.Date(0,1,1)) == "0000-01-01" # January 1st, 1 BC/BCE
@test string(Dates.Date(-1,1,1)) == "-0001-01-01" # January 1st, 2 BC/BCE
@test string(Dates.Date(-1000000,1,1)) == "-1000000-01-01"
@test string(Dates.Date(1000000,1,1)) == "1000000-01-01"

# Test various input types for Date/DateTime
test = Date(1,1,1)
@test Date(int8(1),int8(1),int8(1)) == test
@test Date(uint8(1),uint8(1),uint8(1)) == test
@test Date(int16(1),int16(1),int16(1)) == test
@test Date(uint8(1),uint8(1),uint8(1)) == test
@test Date(int32(1),int32(1),int32(1)) == test
@test Date(uint32(1),uint32(1),uint32(1)) == test
@test Date(int64(1),int64(1),int64(1)) == test
@test Date(uint64(1),uint64(1),uint64(1)) == test
@test Date(int128(1),int128(1),int128(1)) == test
@test Date(uint128(1),uint128(1),uint128(1)) == test
@test Date(big(1),big(1),big(1)) == test
@test Date(big(1),big(1),big(1)) == test
@test Date('\x01','\x01','\x01') == test
@test Date(true,true,true) == test
@test Date(false,true,false) == test - Dates.Year(1) - Dates.Day(1)
@test Date(false,true,true) == test - Dates.Year(1)
@test Date(true,true,false) == test - Dates.Day(1)
@test_throws Date(BigFloat(1),BigFloat(1),BigFloat(1))
@test_throws Date(complex(1),complex(1),complex(1))
@test_throws Date(float64(1),float64(1),float64(1))
@test_throws Date(float32(1),float32(1),float32(1))
@test_throws Date(float16(1),float16(1),float16(1))
@test_throws Date(Rational(1),Rational(1),Rational(1))

# Test year, month, day, hour, minute
function test_dates()
	y = m = d = h = mi = 0
	for y in [-2013,-1,0,1,2013]
		for m = 1:12
			for d = 1:Dates._lastdayofmonth(y,m)
				for h = 0:23
					for mi = 0:59
						dt = Dates.DateTime(y,m,d,h,mi)
						@test y == Dates.year(dt)
						@test m == Dates.month(dt)
						@test d == Dates.day(dt)
						@test h == Dates.hour(dt)
						@test mi == Dates.minute(dt)
						#@test s == Dates.second(dt)
						#@test ms == Dates.millisecond(dt)
					end
				end
			end
		end
	end
end
test_dates()

# Test second, millisecond
function test_dates()
	y = m = d = h = mi = s = ms = 0
	for y in [-2013,-1,0,1,2013]
		for m in [1,6,12]
			for d in [1,15,Dates._lastdayofmonth(y,m)]
				for h in [0,12,23]
					for s = 0:59
						for ms in [0,1,500,999]
							dt = Dates.DateTime(y,m,d,h,mi,s,ms)
							@test y == Dates.year(dt)
							@test m == Dates.month(dt)
							@test d == Dates.day(dt)
							@test h == Dates.hour(dt)
							@test s == Dates.second(dt)
							@test ms == Dates.millisecond(dt)
						end
					end
				end
			end
		end
	end
end
test_dates()

function test_dates(from,to)
	y = m = d = 0
	for y in from:to
		for m = 1:12
			for d = 1:Dates._lastdayofmonth(y,m)
				dt = Dates.Date(y,m,d)
				@test y == Dates.year(dt)
				@test m == Dates.month(dt)
				@test d == Dates.day(dt)
			end
		end
	end
end
test_dates(-2000,2000)

# Months must be in range
@test_throws Dates.DateTime(2013,0,1)
@test_throws Dates.DateTime(2013,13,1)

# Days/Hours/Minutes/Seconds/Milliseconds roll back/forward
@test Dates.DateTime(2013,1,0) == Dates.DateTime(2012,12,31)
@test Dates.DateTime(2013,1,32) == Dates.DateTime(2013,2,1)
@test Dates.DateTime(2013,1,1,24) == Dates.DateTime(2013,1,2)
@test Dates.DateTime(2013,1,1,-1) == Dates.DateTime(2012,12,31,23)
@test Dates.Date(2013,1,0) == Dates.Date(2012,12,31)
@test Dates.Date(2013,1,32) == Dates.Date(2013,2,1)

# DateTime arithmetic
dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Year(1) == Dates.DateTime(2000,12,27)
@test dt + Dates.Year(100) == Dates.DateTime(2099,12,27)
@test dt + Dates.Year(1000) == Dates.DateTime(2999,12,27)
@test dt - Dates.Year(1) == Dates.DateTime(1998,12,27)
@test dt - Dates.Year(100) == Dates.DateTime(1899,12,27)
@test dt - Dates.Year(1000) == Dates.DateTime(999,12,27)
dt = Dates.DateTime(2000,2,29)
@test dt + Dates.Year(1) == Dates.DateTime(2001,2,28)
@test dt - Dates.Year(1) == Dates.DateTime(1999,2,28)
@test dt + Dates.Year(4) == Dates.DateTime(2004,2,29)
@test dt - Dates.Year(4) == Dates.DateTime(1996,2,29)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Year(1) == Dates.DateTime(1973,7,1)
@test dt - Dates.Year(1) == Dates.DateTime(1971,7,1)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Year(1) == Dates.DateTime(1973,6,30,23,59,59)
@test dt - Dates.Year(1) == Dates.DateTime(1971,6,30,23,59,59)
@test dt + Dates.Year(-1) == Dates.DateTime(1971,6,30,23,59,59)

# Wrapping arithemtic for Months
@test Dates.monthwrap(1,-14) == 11
@test Dates.monthwrap(1,-13) == 12
@test Dates.monthwrap(1,-12) == 1
@test Dates.monthwrap(1,-11) == 2
@test Dates.monthwrap(1,-10) == 3
@test Dates.monthwrap(1,-9) == 4
@test Dates.monthwrap(1,-8) == 5
@test Dates.monthwrap(1,-7) == 6
@test Dates.monthwrap(1,-6) == 7
@test Dates.monthwrap(1,-5) == 8
@test Dates.monthwrap(1,-4) == 9
@test Dates.monthwrap(1,-3) == 10
@test Dates.monthwrap(1,-2) == 11
@test Dates.monthwrap(1,-1) == 12
@test Dates.monthwrap(1,0) == 1
@test Dates.monthwrap(1,1) == 2
@test Dates.monthwrap(1,2) == 3
@test Dates.monthwrap(1,3) == 4
@test Dates.monthwrap(1,4) == 5
@test Dates.monthwrap(1,5) == 6
@test Dates.monthwrap(1,6) == 7
@test Dates.monthwrap(1,7) == 8
@test Dates.monthwrap(1,8) == 9
@test Dates.monthwrap(1,9) == 10
@test Dates.monthwrap(1,10) == 11
@test Dates.monthwrap(1,11) == 12
@test Dates.monthwrap(1,12) == 1
@test Dates.monthwrap(1,13) == 2
@test Dates.monthwrap(1,24) == 1
@test Dates.monthwrap(12,-14) == 10
@test Dates.monthwrap(12,-13) == 11
@test Dates.monthwrap(12,-12) == 12
@test Dates.monthwrap(12,-11) == 1
@test Dates.monthwrap(12,-2) == 10
@test Dates.monthwrap(12,-1) == 11
@test Dates.monthwrap(12,0) == 12
@test Dates.monthwrap(12,1) == 1
@test Dates.monthwrap(12,2) == 2
@test Dates.monthwrap(12,11) == 11
@test Dates.monthwrap(12,12) == 12
@test Dates.monthwrap(12,13) == 1

@test Dates.yearwrap(2000,1,-3600) == 1700
@test Dates.yearwrap(2000,1,-37) == 1996
@test Dates.yearwrap(2000,1,-36) == 1997
@test Dates.yearwrap(2000,1,-35) == 1997
@test Dates.yearwrap(2000,1,-25) == 1997
@test Dates.yearwrap(2000,1,-24) == 1998
@test Dates.yearwrap(2000,1,-23) == 1998
@test Dates.yearwrap(2000,1,-14) == 1998
@test Dates.yearwrap(2000,1,-13) == 1998
@test Dates.yearwrap(2000,1,-12) == 1999
@test Dates.yearwrap(2000,1,-11) == 1999
@test Dates.yearwrap(2000,1,-2) == 1999
@test Dates.yearwrap(2000,1,-1) == 1999
@test Dates.yearwrap(2000,1,0) == 2000
@test Dates.yearwrap(2000,1,1) == 2000
@test Dates.yearwrap(2000,1,11) == 2000
@test Dates.yearwrap(2000,1,12) == 2001
@test Dates.yearwrap(2000,1,13) == 2001
@test Dates.yearwrap(2000,1,23) == 2001
@test Dates.yearwrap(2000,1,24) == 2002
@test Dates.yearwrap(2000,1,25) == 2002
@test Dates.yearwrap(2000,1,36) == 2003
@test Dates.yearwrap(2000,1,3600) == 2300
@test Dates.yearwrap(2000,2,-2) == 1999
@test Dates.yearwrap(2000,3,10) == 2001
@test Dates.yearwrap(2000,4,-4) == 1999
@test Dates.yearwrap(2000,5,8) == 2001
@test Dates.yearwrap(2000,6,-18) == 1998
@test Dates.yearwrap(2000,6,-6) == 1999
@test Dates.yearwrap(2000,6,6) == 2000
@test Dates.yearwrap(2000,6,7) == 2001
@test Dates.yearwrap(2000,6,19) == 2002
@test Dates.yearwrap(2000,12,-3600) == 1700
@test Dates.yearwrap(2000,12,-36) == 1997
@test Dates.yearwrap(2000,12,-35) == 1998
@test Dates.yearwrap(2000,12,-24) == 1998
@test Dates.yearwrap(2000,12,-23) == 1999
@test Dates.yearwrap(2000,12,-14) == 1999
@test Dates.yearwrap(2000,12,-13) == 1999
@test Dates.yearwrap(2000,12,-12) == 1999
@test Dates.yearwrap(2000,12,-11) == 2000
@test Dates.yearwrap(2000,12,-2) == 2000
@test Dates.yearwrap(2000,12,-1) == 2000
@test Dates.yearwrap(2000,12,0) == 2000
@test Dates.yearwrap(2000,12,1) == 2001
@test Dates.yearwrap(2000,12,11) == 2001
@test Dates.yearwrap(2000,12,12) == 2001
@test Dates.yearwrap(2000,12,13) == 2002
@test Dates.yearwrap(2000,12,24) == 2002
@test Dates.yearwrap(2000,12,25) == 2003
@test Dates.yearwrap(2000,12,36) == 2003
@test Dates.yearwrap(2000,12,37) == 2004
@test Dates.yearwrap(2000,12,3600) == 2300

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Month(1) == Dates.DateTime(2000,1,27)
@test dt + Dates.Month(-1) == Dates.DateTime(1999,11,27)
@test dt + Dates.Month(-11) == Dates.DateTime(1999,1,27)
@test dt + Dates.Month(11) == Dates.DateTime(2000,11,27)
@test dt + Dates.Month(-12) == Dates.DateTime(1998,12,27)
@test dt + Dates.Month(12) == Dates.DateTime(2000,12,27)
@test dt + Dates.Month(13) == Dates.DateTime(2001,1,27)
@test dt + Dates.Month(100) == Dates.DateTime(2008,4,27)
@test dt + Dates.Month(1000) == Dates.DateTime(2083,4,27)
@test dt - Dates.Month(1) == Dates.DateTime(1999,11,27)
@test dt - Dates.Month(-1) == Dates.DateTime(2000,1,27)
@test dt - Dates.Month(100) == Dates.DateTime(1991,8,27)
@test dt - Dates.Month(1000) == Dates.DateTime(1916,8,27)
dt = Dates.DateTime(2000,2,29)
@test dt + Dates.Month(1) == Dates.DateTime(2000,3,29)
@test dt - Dates.Month(1) == Dates.DateTime(2000,1,29)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Month(1) == Dates.DateTime(1972,8,1)
@test dt - Dates.Month(1) == Dates.DateTime(1972,6,1)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Month(1) == Dates.DateTime(1972,7,30,23,59,59)
@test dt - Dates.Month(1) == Dates.DateTime(1972,5,30,23,59,59)
@test dt + Dates.Month(-1) == Dates.DateTime(1972,5,30,23,59,59)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Week(1) == Dates.DateTime(2000,1,3)
@test dt + Dates.Week(100) == Dates.DateTime(2001,11,26)
@test dt + Dates.Week(1000) == Dates.DateTime(2019,2,25)
@test dt - Dates.Week(1) == Dates.DateTime(1999,12,20)
@test dt - Dates.Week(100) == Dates.DateTime(1998,1,26)
@test dt - Dates.Week(1000) == Dates.DateTime(1980,10,27)
dt = Dates.DateTime(2000,2,29)
@test dt + Dates.Week(1) == Dates.DateTime(2000,3,7)
@test dt - Dates.Week(1) == Dates.DateTime(2000,2,22)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Week(1) == Dates.DateTime(1972,7,8)
@test dt - Dates.Week(1) == Dates.DateTime(1972,6,24)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Week(1) == Dates.DateTime(1972,7,7,23,59,59)
@test dt - Dates.Week(1) == Dates.DateTime(1972,6,23,23,59,59)
@test dt + Dates.Week(-1) == Dates.DateTime(1972,6,23,23,59,59)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Day(1) == Dates.DateTime(1999,12,28)
@test dt + Dates.Day(100) == Dates.DateTime(2000,4,5)
@test dt + Dates.Day(1000) == Dates.DateTime(2002,9,22)
@test dt - Dates.Day(1) == Dates.DateTime(1999,12,26)
@test dt - Dates.Day(100) == Dates.DateTime(1999,9,18)
@test dt - Dates.Day(1000) == Dates.DateTime(1997,4,1)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Day(1) == Dates.DateTime(1972,7,2)
@test dt - Dates.Day(1) == Dates.DateTime(1972,6,30)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Day(1) == Dates.DateTime(1972,7,1,23,59,59)
@test dt - Dates.Day(1) == Dates.DateTime(1972,6,29,23,59,59)
@test dt + Dates.Day(-1) == Dates.DateTime(1972,6,29,23,59,59)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Hour(1) == Dates.DateTime(1999,12,27,1)
@test dt + Dates.Hour(100) == Dates.DateTime(1999,12,31,4)
@test dt + Dates.Hour(1000) == Dates.DateTime(2000,2,6,16)
@test dt - Dates.Hour(1) == Dates.DateTime(1999,12,26,23)
@test dt - Dates.Hour(100) == Dates.DateTime(1999,12,22,20)
@test dt - Dates.Hour(1000) == Dates.DateTime(1999,11,15,8)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Hour(1) == Dates.DateTime(1972,7,1,1)
@test dt - Dates.Hour(1) == Dates.DateTime(1972,6,30,23)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Hour(1) == Dates.DateTime(1972,7,1,0,59,59)
@test dt - Dates.Hour(1) == Dates.DateTime(1972,6,30,22,59,59)
@test dt + Dates.Hour(-1) == Dates.DateTime(1972,6,30,22,59,59)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Minute(1) == Dates.DateTime(1999,12,27,0,1)
@test dt + Dates.Minute(100) == Dates.DateTime(1999,12,27,1,40)
@test dt + Dates.Minute(1000) == Dates.DateTime(1999,12,27,16,40)
@test dt - Dates.Minute(1) == Dates.DateTime(1999,12,26,23,59)
@test dt - Dates.Minute(100) == Dates.DateTime(1999,12,26,22,20)
@test dt - Dates.Minute(1000) == Dates.DateTime(1999,12,26,7,20)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Minute(1) == Dates.DateTime(1972,7,1,0,1)
@test dt - Dates.Minute(1) == Dates.DateTime(1972,6,30,23,59)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Minute(1) == Dates.DateTime(1972,7,1,0,0,59)
@test dt - Dates.Minute(1) == Dates.DateTime(1972,6,30,23,58,59)
@test dt + Dates.Minute(-1) == Dates.DateTime(1972,6,30,23,58,59)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Second(1) == Dates.DateTime(1999,12,27,0,0,1)
@test dt + Dates.Second(100) == Dates.DateTime(1999,12,27,0,1,40)
@test dt + Dates.Second(1000) == Dates.DateTime(1999,12,27,0,16,40)
@test dt - Dates.Second(1) == Dates.DateTime(1999,12,26,23,59,59)
@test dt - Dates.Second(100) == Dates.DateTime(1999,12,26,23,58,20)
@test dt - Dates.Second(1000) == Dates.DateTime(1999,12,26,23,43,20)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Second(1) == Dates.DateTime(1972,7,1,0,0,1)
@test dt - Dates.Second(1) == Dates.DateTime(1972,6,30,23,59,59)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Second(1) == Dates.DateTime(1972,6,30,23,59,60)
@test dt - Dates.Second(1) == Dates.DateTime(1972,6,30,23,59,58)
@test dt + Dates.Second(-1) == Dates.DateTime(1972,6,30,23,59,58)

dt = Dates.DateTime(1999,12,27)
@test dt + Dates.Millisecond(1) == Dates.DateTime(1999,12,27,0,0,0,1)
@test dt + Dates.Millisecond(100) == Dates.DateTime(1999,12,27,0,0,0,100)
@test dt + Dates.Millisecond(1000) == Dates.DateTime(1999,12,27,0,0,1)
@test dt - Dates.Millisecond(1) == Dates.DateTime(1999,12,26,23,59,59,999)
@test dt - Dates.Millisecond(100) == Dates.DateTime(1999,12,26,23,59,59,900)
@test dt - Dates.Millisecond(1000) == Dates.DateTime(1999,12,26,23,59,59)
dt = Dates.DateTime(1972,6,30,23,59,60)
@test dt + Dates.Millisecond(1) == Dates.DateTime(1972,6,30,23,59,60,1)
@test dt - Dates.Millisecond(1) == Dates.DateTime(1972,6,30,23,59,59,999)
dt = Dates.DateTime(1972,6,30,23,59,59)
@test dt + Dates.Millisecond(1) == Dates.DateTime(1972,6,30,23,59,59,1)
@test dt - Dates.Millisecond(1) == Dates.DateTime(1972,6,30,23,59,58,999)
@test dt + Dates.Millisecond(-1) == Dates.DateTime(1972,6,30,23,59,58,999)

dt = Dates.Date(1999,12,27)
@test dt + Dates.Year(1) == Dates.Date(2000,12,27)
@test dt + Dates.Year(100) == Dates.Date(2099,12,27)
@test dt + Dates.Year(1000) == Dates.Date(2999,12,27)
@test dt - Dates.Year(1) == Dates.Date(1998,12,27)
@test dt - Dates.Year(100) == Dates.Date(1899,12,27)
@test dt - Dates.Year(1000) == Dates.Date(999,12,27)
dt = Dates.Date(2000,2,29)
@test dt + Dates.Year(1) == Dates.Date(2001,2,28)
@test dt - Dates.Year(1) == Dates.Date(1999,2,28)
@test dt + Dates.Year(4) == Dates.Date(2004,2,29)
@test dt - Dates.Year(4) == Dates.Date(1996,2,29)

dt = Dates.Date(1999,12,27)
@test dt + Dates.Month(1) == Dates.Date(2000,1,27)
@test dt + Dates.Month(100) == Dates.Date(2008,4,27)
@test dt + Dates.Month(1000) == Dates.Date(2083,4,27)
@test dt - Dates.Month(1) == Dates.Date(1999,11,27)
@test dt - Dates.Month(100) == Dates.Date(1991,8,27)
@test dt - Dates.Month(1000) == Dates.Date(1916,8,27)
dt = Dates.Date(2000,2,29)
@test dt + Dates.Month(1) == Dates.Date(2000,3,29)
@test dt - Dates.Month(1) == Dates.Date(2000,1,29)

dt = Dates.Date(1999,12,27)
@test dt + Dates.Week(1) == Dates.Date(2000,1,3)
@test dt + Dates.Week(100) == Dates.Date(2001,11,26)
@test dt + Dates.Week(1000) == Dates.Date(2019,2,25)
@test dt - Dates.Week(1) == Dates.Date(1999,12,20)
@test dt - Dates.Week(100) == Dates.Date(1998,1,26)
@test dt - Dates.Week(1000) == Dates.Date(1980,10,27)
dt = Dates.Date(2000,2,29)
@test dt + Dates.Week(1) == Dates.Date(2000,3,7)
@test dt - Dates.Week(1) == Dates.Date(2000,2,22)

dt = Dates.Date(1999,12,27)
@test dt + Dates.Day(1) == Dates.Date(1999,12,28)
@test dt + Dates.Day(100) == Dates.Date(2000,4,5)
@test dt + Dates.Day(1000) == Dates.Date(2002,9,22)
@test dt - Dates.Day(1) == Dates.Date(1999,12,26)
@test dt - Dates.Day(100) == Dates.Date(1999,9,18)
@test dt - Dates.Day(1000) == Dates.Date(1997,4,1)

# week function
dt = Dates.DateTime(1999,12,27)
dt1 = Dates.Date(1999,12,27)
check = (52,52,52,52,52,52,52,1,1,1,1,1,1,1,2,2,2,2,2,2,2)
for i = 1:21
	@test Dates.week(dt) == check[i]
	@test Dates.week(dt1) == check[i]
	dt = dt + Dates.Day(1)
	dt1 = dt1 + Dates.Day(1)
end
dt = Dates.DateTime(2000,12,25)
dt1 = Dates.Date(2000,12,25)
for i = 1:21
	@test Dates.week(dt) == check[i]
	@test Dates.week(dt1) == check[i]
	dt = dt + Dates.Day(1)
	dt1 = dt1 + Dates.Day(1)
end
dt = Dates.DateTime(2030,12,23)
dt1 = Dates.Date(2030,12,23)
for i = 1:21
	@test Dates.week(dt) == check[i]
	@test Dates.week(dt1) == check[i]
	dt = dt + Dates.Day(1)
	dt1 = dt1 + Dates.Day(1)
end
dt = Dates.DateTime(2004,12,20)
dt1 = Dates.Date(2004,12,20)
check = (52,52,52,52,52,52,52,53,53,53,53,53,53,53,1,1,1,1,1,1,1)
for i = 1:21
	@test Dates.week(dt) == check[i]
	@test Dates.week(dt1) == check[i]
	dt = dt + Dates.Day(1)
	dt1 = dt1 + Dates.Day(1)
end

a = Dates.DateTime(1972,6,30,23,59,59)
@test Dates.calendar(a) == Dates.ISOCalendar
@test Dates.precision(a) == Dates.UTInstant{Millisecond}
@test string(typemax(Dates.DateTime)) == "292277024-12-31T23:59:59"
@test string(typemin(Dates.DateTime)) == "-292277023-01-01T00:00:00"
@test string(typemax(Dates.Date)) == "252522163911149-12-31"
@test string(typemin(Dates.Date)) == "-252522163911150-01-01"

# Name functions
jan = Dates.DateTime(2013,1,1)
feb = Dates.DateTime(2013,2,2)
mar = Dates.DateTime(2013,3,3)
apr = Dates.DateTime(2013,4,4)
may = Dates.DateTime(2013,5,5)
jun = Dates.DateTime(2013,6,7)
jul = Dates.DateTime(2013,7,7)
aug = Dates.DateTime(2013,8,8)
sep = Dates.DateTime(2013,9,9)
oct = Dates.DateTime(2013,10,10)
nov = Dates.DateTime(2013,11,11)
dec = Dates.DateTime(2013,12,11)
monthnames = ["January","February","March","April",
                "May","June","July","August","September",
                "October","November","December"]
daysofweek = [Dates.Tue,Dates.Sat,Dates.Sun,Dates.Thu,Dates.Sun,Dates.Fri,
			  Dates.Sun,Dates.Thu,Dates.Mon,Dates.Thu,Dates.Mon,Dates.Wed]
dows = ["Tuesday","Saturday","Sunday","Thursday","Sunday","Friday",
		"Sunday","Thursday","Monday","Thursday","Monday","Wednesday"]
for (i,dt) in enumerate([jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec])
	@test Dates.month(dt) == i
	@test Dates.monthname(dt) == monthnames[i]
	@test Dates.monthabbr(dt) == monthnames[i][1:3]
	@test Dates.dayofweek(dt) == daysofweek[i]
	@test Dates.dayname(dt) == dows[i]
	@test Dates.dayabbr(dt) == dows[i][1:3]
end

# Date functions
@test Dates._lastdayofmonth(2000,1) == 31
@test Dates._lastdayofmonth(2000,2) == 29
@test Dates._lastdayofmonth(2000,3) == 31
@test Dates._lastdayofmonth(2000,4) == 30
@test Dates._lastdayofmonth(2000,5) == 31
@test Dates._lastdayofmonth(2000,6) == 30
@test Dates._lastdayofmonth(2000,7) == 31
@test Dates._lastdayofmonth(2000,8) == 31
@test Dates._lastdayofmonth(2000,9) == 30
@test Dates._lastdayofmonth(2000,10) == 31
@test Dates._lastdayofmonth(2000,11) == 30
@test Dates._lastdayofmonth(2000,12) == 31
@test Dates._lastdayofmonth(2001,2) == 28

@test Dates.isleap(Dates.DateTime(1900)) == false
@test Dates.isleap(Dates.DateTime(2000)) == true
@test Dates.isleap(Dates.DateTime(2004)) == true
@test Dates.isleap(Dates.DateTime(2008)) == true
@test Dates.isleap(Dates.DateTime(0)) == true
@test Dates.isleap(Dates.DateTime(1)) == false
@test Dates.isleap(Dates.DateTime(-1)) == false
@test Dates.isleap(Dates.DateTime(4)) == true
@test Dates.isleap(Dates.DateTime(-4)) == true

@test Dates.dayofweek(Dates.DateTime(2013,12,22)) == 0
@test Dates.dayofweek(Dates.DateTime(2013,12,23)) == 1
@test Dates.dayofweek(Dates.DateTime(2013,12,24)) == 2
@test Dates.dayofweek(Dates.DateTime(2013,12,25)) == 3
@test Dates.dayofweek(Dates.DateTime(2013,12,26)) == 4
@test Dates.dayofweek(Dates.DateTime(2013,12,27)) == 5
@test Dates.dayofweek(Dates.DateTime(2013,12,28)) == 6
@test Dates.dayofweek(Dates.DateTime(2013,12,29)) == 0

@test Dates.dayofweekofmonth(Dates.DateTime(2013,12,1)) == 1
@test Dates.dayofweekofmonth(Dates.DateTime(2013,12,8)) == 2
@test Dates.dayofweekofmonth(Dates.DateTime(2013,12,15)) == 3
@test Dates.dayofweekofmonth(Dates.DateTime(2013,12,22)) == 4
@test Dates.dayofweekofmonth(Dates.DateTime(2013,12,29)) == 5

@test Dates.daysofweekinmonth(Dates.DateTime(2013,12,1)) == 5

@test Dates.dayofyear(Dates.DateTime(2000,1,1)) == 1
@test Dates.dayofyear(Dates.DateTime(2004,1,1)) == 1
@test Dates.dayofyear(Dates.DateTime(20013,1,1)) == 1
@test Dates.dayofyear(Dates.DateTime(2000,12,31)) == 366
@test Dates.dayofyear(Dates.DateTime(2001,12,31)) == 365
dt = Dates.DateTime(2000,1,1)
for i = 1:366
	@test Dates.dayofyear(dt) == i
	dt += Dates.Day(1)
end
dt = Dates.DateTime(2001,1,1)
for i = 1:365
	@test Dates.dayofyear(dt) == i
	dt += Dates.Day(1)
end

a = Dates.Date(2014,1,5)
b = Dates.Date(2014,1,6)
c = Dates.Date(2014,1,7)
d = Dates.Date(2014,1,8)
e = Dates.Date(2014,1,9)
f = Dates.Date(2014,1,10)
g = Dates.Date(2014,1,11)
@test Dates.firstdayofweek(a) == a
@test Dates.firstdayofweek(b) == a
@test Dates.firstdayofweek(c) == a
@test Dates.firstdayofweek(d) == a
@test Dates.firstdayofweek(e) == a
@test Dates.firstdayofweek(f) == a
@test Dates.firstdayofweek(g) == a
dt = a
for i = 0:364
	@test Dates.firstdayofweek(dt) == a + Dates.Week(div(i,7))
	dt += Dates.Day(1)
end
a = Dates.DateTime(2014,1,5)
b = Dates.DateTime(2014,1,6)
c = Dates.DateTime(2014,1,7)
d = Dates.DateTime(2014,1,8)
e = Dates.DateTime(2014,1,9)
f = Dates.DateTime(2014,1,10)
g = Dates.DateTime(2014,1,11)
@test Dates.firstdayofweek(a) == a
@test Dates.firstdayofweek(b) == a
@test Dates.firstdayofweek(c) == a
@test Dates.firstdayofweek(d) == a
@test Dates.firstdayofweek(e) == a
@test Dates.firstdayofweek(f) == a
@test Dates.firstdayofweek(g) == a
dt = a
for i = 0:364
	@test Dates.firstdayofweek(dt) == a + Dates.Week(div(i,7))
	dt += Dates.Day(1)
end
@test Dates.firstdayofweek(Dates.DateTime(2013,12,24)) == Dates.DateTime(2013,12,22)
a = Dates.Date(2014,1,5)
b = Dates.Date(2014,1,6)
c = Dates.Date(2014,1,7)
d = Dates.Date(2014,1,8)
e = Dates.Date(2014,1,9)
f = Dates.Date(2014,1,10)
g = Dates.Date(2014,1,11)
@test Dates.lastdayofweek(a) == g
@test Dates.lastdayofweek(b) == g
@test Dates.lastdayofweek(c) == g
@test Dates.lastdayofweek(d) == g
@test Dates.lastdayofweek(e) == g
@test Dates.lastdayofweek(f) == g
@test Dates.lastdayofweek(g) == g
dt = a
for i = 0:364
	@test Dates.lastdayofweek(dt) == g + Dates.Week(div(i,7))
	dt += Dates.Day(1)
end
a = Dates.DateTime(2014,1,5)
b = Dates.DateTime(2014,1,6)
c = Dates.DateTime(2014,1,7)
d = Dates.DateTime(2014,1,8)
e = Dates.DateTime(2014,1,9)
f = Dates.DateTime(2014,1,10)
g = Dates.DateTime(2014,1,11)
@test Dates.lastdayofweek(a) == g
@test Dates.lastdayofweek(b) == g
@test Dates.lastdayofweek(c) == g
@test Dates.lastdayofweek(d) == g
@test Dates.lastdayofweek(e) == g
@test Dates.lastdayofweek(f) == g
@test Dates.lastdayofweek(g) == g
dt = a
for i = 0:364
	@test Dates.lastdayofweek(dt) == g + Dates.Week(div(i,7))
	dt += Dates.Day(1)
end
@test Dates.lastdayofweek(Dates.DateTime(2013,12,24)) == Dates.DateTime(2013,12,28)

@test Date(DateTime(Date(2012,7,1))) == Date(2012,7,1)
@test Dates.unix2date(Dates.date2unix(DateTime(2000,1,1))) == DateTime(2000,1,1)
@test Dates.DateTime(1970).instant.t.ms == Dates.UNIXEPOCH
#@test Dates.date2unix(now()) == time()

startdate = Date(2014,1,1)
stopdate = Date(2014,2,1)
januarymondays2014 = [Date(2014,1,6),Date(2014,1,13),Date(2014,1,20),Date(2014,1,27)]
@test Dates.recur(x->Dates.dayofweek(x)==Dates.Monday,startdate,stopdate) == januarymondays2014
@test Dates.recur(x->!(Dates.dayofweek(x)==Dates.Monday),startdate,stopdate;inclusion=false) == januarymondays2014

# Tests from here: http://en.wikipedia.org/wiki/Unix_time
@test string(Dates.unix2date(1095379198.75)) == string("2004-09-16T23:59:58.75")
@test string(Dates.unix2date(1095379199.00)) == string("2004-09-16T23:59:59")
@test string(Dates.unix2date(1095379199.25)) == string("2004-09-16T23:59:59.25")
@test string(Dates.unix2date(1095379199.50)) == string("2004-09-16T23:59:59.5")
@test string(Dates.unix2date(1095379199.75)) == string("2004-09-16T23:59:59.75")
@test string(Dates.unix2date(1095379200.00)) == string("2004-09-17T00:00:00")
@test string(Dates.unix2date(1095379200.25)) == string("2004-09-17T00:00:00.25")
@test string(Dates.unix2date(1095379200.50)) == string("2004-09-17T00:00:00.5")
@test string(Dates.unix2date(1095379200.75)) == string("2004-09-17T00:00:00.75")
@test string(Dates.unix2date(1095379201.00)) == string("2004-09-17T00:00:01")
@test string(Dates.unix2date(1095379201.25)) == string("2004-09-17T00:00:01.25")
@test string(Dates.unix2date(915148798.75)) == string("1998-12-31T23:59:58.75")
@test string(Dates.unix2date(915148799.00)) == string("1998-12-31T23:59:59")
@test string(Dates.unix2date(915148799.25)) == string("1998-12-31T23:59:59.25")
@test string(Dates.unix2date(915148799.50)) == string("1998-12-31T23:59:59.5")
@test string(Dates.unix2date(915148799.75)) == string("1998-12-31T23:59:59.75")
@test string(Dates.unix2date(915148800.00)) == string("1999-01-01T00:00:00")
@test string(Dates.unix2date(915148800.25)) == string("1999-01-01T00:00:00.25")
@test string(Dates.unix2date(915148800.50)) == string("1999-01-01T00:00:00.5")
@test string(Dates.unix2date(915148800.75)) == string("1999-01-01T00:00:00.75")
@test string(Dates.unix2date(915148801.00)) == string("1999-01-01T00:00:01")
@test string(Dates.unix2date(915148801.25)) == string("1999-01-01T00:00:01.25")

@test Date(Dates.ratadays2date(734869)...) == Date(2013,1,1)
@test Dates.date2ratadays(Date(Dates.ratadays2date(734869)...)) == 734869

# Tests from here: http://mysite.verizon.net/aesir_research/date/back.htm#JDN
@test Dates.julian2date(1721119.5) == DateTime(0,3,1)
@test Dates.julian2date(1721424.5) == DateTime(0,12,31)
@test Dates.julian2date(1721425.5) == DateTime(1,1,1)
@test Dates.julian2date(2299149.5) == DateTime(1582,10,4)
@test Dates.julian2date(2415020.5) == DateTime(1900,1,1)
@test Dates.julian2date(2415385.5) == DateTime(1901,1,1)
@test Dates.julian2date(2440587.5) == DateTime(1970,1,1)
@test Dates.julian2date(2444239.5) == DateTime(1980,1,1)
@test Dates.julian2date(2452695.625) == DateTime(2003,2,25,3)
@test Dates.date2julian(DateTime(2013,12,3,21)) == 2456630.375

# DateTime parsing
#'1996-January-15'
dt = Dates.DateTime(1996,1,15)
f = "yy-mm-dd"
a = "96-01-15"
@test Dates.DateTime(a,f) + Dates.Year(1900) == dt
a1 = "96-1-15"
@test Dates.DateTime(a1,f) + Dates.Year(1900) == dt
a2 = "96-1-1"
@test Dates.DateTime(a2,f) + Dates.Year(1900) + Dates.Day(14) == dt
a3 = "1996-1-15"
@test Dates.DateTime(a3,f) == dt
a4 = "1996-Jan-15"
@test_throws Dates.DateTime(a4,f) # Trying to use month name, but specified only "mm"

f = "yy/mmm/dd"
b = "96/Feb/15"
@test Dates.DateTime(b,f) + Dates.Year(1900) == dt + Dates.Month(1)
b1 = "1996/Feb/15"
@test Dates.DateTime(b1,f) == dt + Dates.Month(1)
b2 = "96/Feb/1"
@test Dates.DateTime(b2,f) + Dates.Year(1900) + Dates.Day(14) == dt + Dates.Month(1)
# Here we've specifed the month name, yet fail to parse and default to January
b3 = "96/2/15"
@test Dates.DateTime(b3,f) == dt - Dates.Year(1900) 

f = "yy:dd:mm"
c = "96:15:01"
@test Dates.DateTime(c,f) + Dates.Year(1900) == dt
c1 = "1996:15:01"
@test Dates.DateTime(c1,f) == dt
c2 = "96:15:1"
@test Dates.DateTime(c2,f) + Dates.Year(1900) == dt
c3 = "96:1:01"
@test Dates.DateTime(c3,f) + Dates.Year(1900) + Dates.Day(14) == dt
c4 = "96:15:01 # random comment"
@test_throws Dates.DateTime(c4,f) # Currently doesn't handle trailing comments

f = "yyyy,mmm,dd"
d = "1996,Jan,15"
@test Dates.DateTime(d,f) == dt
d1 = "96,Jan,15"
@test Dates.DateTime(d1,f) + Dates.Year(1900) == dt
d2 = "1996,Jan,1"
@test Dates.DateTime(d2,f) + Dates.Day(14) == dt
d3 = "1996,2,15"
@test Dates.DateTime(d3,f) != Dates.DateTime(1996,2,15) # Same as above

f = "yyyy.mmmm.dd"
e = "1996.January.15"
@test Dates.DateTime(e,f) == dt
e1 = "96.January.15"
@test Dates.DateTime(e1,f) + Dates.Year(1900) == dt

fo = "yyyy m dd"
f = "1996 1 15"
@test Dates.DateTime(f,fo) == dt
f1 = "1996 01 15"
@test Dates.DateTime(f1,fo) == dt
f2 = "1996 1 1"
@test Dates.DateTime(f2,fo) + Dates.Day(14) == dt

j = "1996-01-15"
f = "yyyy-mm-dd zzz"
#@test Dates.DateTime(j,f) == dt
# k = "1996-01-15 10:00:00"
# f = "yyyy-mm-dd HH:MM:SS zzz"
# @test Dates.DateTime(k,f) == dt + Dates.Hour(10)
# l = "1996-01-15 10:10:10.25"
# f = "yyyy-mm-dd HH:MM:SS.ss zzz"
# @test Dates.DateTime(l,f) == dt + Dates.Hour(10) + Dates.Minute(10) + Dates.Second(10) + Dates.Millisecond(250)

# r = "1/15/1996" # Excel
# f = "m/dd/yyyy"
# @test Dates.DateTime(r,f) == dt
# s = "19960115"
# f = "yyyymmdd"
# @test Dates.DateTime(s,f) == dt
# v = "1996-01-15 10:00:00"
# f = "yyyy-mm-dd HH:MM:SS"
# @test Dates.DateTime(v,f) == dt + Dates.Hour(10)
# w = "1996-01-15T10:00:00"
# f = "yyyy-mm-ddTHH:MM:SS zzz"
# @test Dates.DateTime(w,f;sep="T") == dt + Dates.Hour(10)

# f = "yyyy/m"
# y = "1996/1"
# @test Dates.DateTime(y,f) == dt - Dates.Day(14)
# y1 = "1996/1/15"
# @test_throws Dates.DateTime(y1,f)
# y2 = "96/1"
# @test Dates.DateTime(y2,f) + Dates.Year(1900) == dt - Dates.Day(14)

# f = "yyyy"
# z = "1996"
# @test Dates.DateTime(z,f) == dt - Dates.Day(14)
# z1 = "1996-3"
# @test Dates.DateTime(z1,f) != Dates.DateTime(1996,3)
# z2 = "1996-3-1"
# @test Dates.DateTime(z2,f) != Dates.DateTime(1996,3)

# aa = "1/5/1996"
# f = "m/d/yyyy"
# @test Dates.DateTime(aa,f) == dt - Dates.Day(10)
# bb = "5/1/1996"
# f = "d/m/yyyy"
# @test Dates.DateTime(bb,f) == dt - Dates.Day(10)
# cc = "01151996"
# f = "mmddyyyy"
# @test Dates.DateTime(cc,f) == dt
# dd = "15011996"
# f = "ddmmyyyy"
# @test Dates.DateTime(dd,f) == dt
# ee = "01199615"
# f = "mmyyyydd"
# @test Dates.DateTime(ee,f) == dt
# ff = "1996-15-Jan"
# f = "yyyy-dd-mmm"
# @test Dates.DateTime(ff,f) == dt
# gg = "Jan-1996-15"
# f = "mmm-yyyy-dd"
# @test Dates.DateTime(gg,f) == dt

@test_throws DateTime("18/05/2009","mm/dd/yyyy") # switched month and day
@test_throws DateTime("18/05/2009 16","mm/dd/yyyy hh") # same
@test DateTime("18/05/2009 16:12","mm/dd/yyyy hh:mm") == DateTime(2009,12,16) # here they used mm instead of MM for minutes
@test_throws DateTime("18:05:2009","mm/dd/yyyy")
@test Date("2009年12月01日","yyyy年mm月dd日") == Date(2009,12,1)
@test Date("2009-12-01","yyyy-mm-dd") == Date(2009,12,1)

# Period testing
@test -Dates.Year(1) == Dates.Year(-1)
@test Dates.Year(1) > Dates.Year(0)
@test (Dates.Year(1) < Dates.Year(0)) == false
@test Dates.Year(1) == Dates.Year(1)
@test Dates.Year(1) + Dates.Year(1) == Dates.Year(2)
@test Dates.Year(1) - Dates.Year(1) == Dates.Year(0)
@test Dates.Year(1) * Dates.Year(1) == Dates.Year(1)
@test Dates.Year(10) % Dates.Year(4) == Dates.Year(2)
@test div(Dates.Year(10),Dates.Year(3)) == Dates.Year(3)
@test div(Dates.Year(10),Dates.Year(4)) == Dates.Year(2)
t = Dates.Year(1)
t2 = Dates.Year(2)
@test ([t,t,t,t,t] + Dates.Year(1)) == ([t2,t2,t2,t2,t2])
@test ([t2,t2,t2,t2,t2] - Dates.Year(1)) == ([t,t,t,t,t])
@test ([t,t,t,t,t] * Dates.Year(1)) == ([t,t,t,t,t])
@test ([t,t,t,t,t] % t2) == ([t,t,t,t,t])
@test div([t,t,t,t,t],Dates.Year(1)) == ([t,t,t,t,t])

#Period arithmetic
y = Dates.Year(1)
m = Dates.Month(1)
w = Dates.Week(1)
d = Dates.Day(1)
h = Dates.Hour(1)
mi = Dates.Minute(1)
s = Dates.Second(1)
ms = Dates.Millisecond(1)
@test Dates.DateTime(y) == Dates.DateTime(1)
@test Dates.DateTime(y,m) == Dates.DateTime(1,1)
@test Dates.DateTime(y,m,d) == Dates.DateTime(1,1,1)
@test Dates.DateTime(y,m,d,h) == Dates.DateTime(1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi) == Dates.DateTime(1,1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi,s) == Dates.DateTime(1,1,1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi,s,ms) == Dates.DateTime(1,1,1,1,1,1,1)
@test_throws Dates.DateTime(Dates.Day(10),Dates.Month(2),y)
@test_throws Dates.DateTime(Dates.Second(10),Dates.Month(2),y,Dates.Hour(4))
@test_throws Dates.DateTime(Dates.Year(1),Dates.Month(2),Dates.Day(1),Dates.Hour(4),Dates.Second(10))
@test Dates.Date(y) == Dates.Date(1)
@test Dates.Date(y,m) == Dates.Date(1,1)
@test Dates.Date(y,m,d) == Dates.Date(1,1,1)
@test_throws Dates.Date(m)
@test_throws Dates.Date(d,y)
@test_throws Dates.Date(d,m)
@test_throws Dates.Date(m,y)
@test Dates.Year(int8(1)) == y
@test Dates.Year(uint8(1)) == y
@test Dates.Year(int16(1)) == y
@test Dates.Year(uint16(1)) == y
@test Dates.Year(int(1)) == y
@test Dates.Year(uint(1)) == y
@test Dates.Year(int64(1)) == y
@test Dates.Year(uint64(1)) == y
@test Dates.Year(int128(1)) == y
@test Dates.Year(uint128(1)) == y
@test Dates.Year(big(1)) == y
@test_throws Dates.Year(BigFloat(1)) == y
@test_throws Dates.Year(float(1)) == y
@test_throws Dates.Year(float32(1)) == y
@test_throws Dates.Year(float16(1)) == y
@test_throws Dates.Year(Rational(1)) == y
@test_throws Dates.Year(complex(1)) == y
@test Dates.Year(true) == y
@test Dates.Year(false) != y
@test Dates.Year('\x01') == y
@test_throws Dates.Year(:hey) == y
@test Dates.Year(real(1)) == y
@test_throws Dates.Year(m) == y
@test_throws Dates.Year(w) == y
@test_throws Dates.Year(d) == y
@test_throws Dates.Year(h) == y
@test_throws Dates.Year(mi) == y
@test_throws Dates.Year(s) == y
@test_throws Dates.Year(ms) == y
@test_throws Dates.Year(Date(2013,1,1))
@test typeof(y+m) <: Dates.CompoundPeriod
@test typeof(m+y) <: Dates.CompoundPeriod
@test typeof(y+w) <: Dates.CompoundPeriod
@test typeof(y+d) <: Dates.CompoundPeriod
@test typeof(y+h) <: Dates.CompoundPeriod
@test typeof(y+mi) <: Dates.CompoundPeriod
@test typeof(y+s) <: Dates.CompoundPeriod
@test typeof(y+ms) <: Dates.CompoundPeriod
@test_throws y > m
@test_throws d < w
@test typemax(Dates.Year) == Dates.Year(typemax(Int64))
@test typemax(Dates.Year) + y == Dates.Year(-9223372036854775808)
@test typemin(Dates.Year) == Dates.Year(-9223372036854775808)
#Period-Real arithmetic
@test y + 1 == Dates.Year(2)
@test 1 + y == Dates.Year(2)
@test y + 1.0 == Dates.Year(2)
@test y * 4 == Dates.Year(4)
@test y * 4f0 == Dates.Year(4)
@test y * 3//4 == Dates.Year(1)
@test div(y,2) == Dates.Year(0)
@test div(2,y) == Dates.Year(2)
@test div(y,y) == Dates.Year(1)
@test y*10 % 5 == Dates.Year(0)
@test 5 % y*10 == Dates.Year(0)
@test_throws y > 3
@test_throws 4 < y
@test_throws 1 == y
t = [y,y,y,y,y]
@test t .+ Dates.Year(2) == [Dates.Year(3),Dates.Year(3),Dates.Year(3),Dates.Year(3),Dates.Year(3)]
dt = Dates.DateTime(2012,12,21)
test = ((((((((dt + y) - m) + w) - d) + h) - mi) + s) - ms)
@test test == dt + y - m + w - d + h - mi + s - ms
@test test == y - m + w - d + dt + h - mi + s - ms
@test test == dt - m + y - d + w - mi + h - ms + s
@test test == dt + (y - m + w - d + h - mi + s - ms)
@test test == dt + y - m + w - d + (h - mi + s - ms)
#associative
@test (dt + Dates.Year(4)) + Dates.Day(1) == dt + (Dates.Year(4) + Dates.Day(1))
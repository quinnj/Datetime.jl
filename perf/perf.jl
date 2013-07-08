# using Calendar
# function test()
# 	for i = 1:1000000
# 		t = ymd_hms(1982,6,30,23,59,59)
# 	end
# end
# @time test() #~17.1s
# function test()
# 	for i = 1:1000000
# 		t = ymd_hms(1982,6,30,23,59,59,"UTC")
# 	end
# end
# @time test() #~0.87s
# function test()
# 	for i = 1:1000000
# 		t = ymd_hms(1982,6,30,23,59,59,"VET")
# 	end
# end
# @time test() #~0.93s
# function test()
# 	for i = 1:1000000
# 		t = ymd_hms(1982,6,30,23,59,59,"PST")
# 	end
# end
# @time test() #~1.6s
# function test()
# 	t = ymd(2013,7,8)
# 	for i = 1:1000000
# 		r = dayofyear(t)
# 	end
# end
# @time test() #~0.62s
# function test()
# 	t = ymd(2013,7,8)
# 	for i = 1:1000000
# 		r = dayofweek(t)
# 	end
# end
# @time test() #~0.62s
# function test()
# 	t = ymd(2013,7,8)
# 	for i = 1:1000000
# 		r = week(t)
# 	end
# end
# @time test() #~0.61s

#using Datetime
function test()
	y,m,d,h,mi,s = year(1982),month(6),day(30),hour(23),minute(59),second(59)
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s) #UTC
	end
end
@time test() #~0.21s
function test()
	y,m,d,h,mi,s = year(1982),month(6),day(30),hour(23),minute(59),second(59)
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s,VET)
	end
end
@time test() #~1.06s
function test()
	y,m,d,h,mi,s = year(1982),month(6),day(30),hour(23),minute(59),second(59)
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s,PST)
	end
end
@time test() #~4.42s

function test()
	y,m = year(2000),month(12)
	for i = 1:1000000
		t = lastday(y,m)
	end
end
@time test() #0.03s
function test()
	y,m,d = year(2013),month(7),day(8)
	for i = 1:1000000
		t = dayofyear(y,m,d)
	end
end
@time test() #~0.65s -could probably be faster
function test()
	y,m,d = year(2000),month(12),day(31)
	for i = 1:1000000
		t = dayofweek(y,m,d)
	end
end
@time test() #~0.09s
function test()
	y,m,d = year(2000),month(12),day(31)
	for i = 1:1000000
		t = Datetime._day2date(Datetime._daynumbers(y,m,d))
	end
end
@time test() #~1.85s -full => Rata Die numbers back to => date
function test()
	y,m,d = year(2000),month(12),day(31)
	for i = 1:1000000
		t = Datetime._daynumbers(y,m,d)
	end
end
@time test() #~0.1s
function test()
	y,m,d = year(2000),month(12),day(31)
	for i = 1:1000000
		t = date(y,m,d)
	end
end
@time test() #~0.54s
function test()
	y,m,d = year(2000),month(12),day(31)
	for i = 1:1000000
		t = week(y,m,d)
	end
end
@time test() #~0.11s

#arithmetic
#Calendar
function test()
	t = ymd(2013,7,8,"UTC")
	tt = years(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~3.1s
function test()
	t = ymd(2013,7,8,"UTC")
	tt = months(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~3.07s
function test()
	t = ymd(2013,7,8,"UTC")
	tt = days(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~0.03s
function test()
	t = ymd(2013,7,8,"UTC")
	tt = hours(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~0.03s
function test()
	t = ymd(2013,7,8,"UTC")
	tt = minutes(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~0.03s
function test()
	t = ymd(2013,7,8,"UTC")
	tt = seconds(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~0.03s

#Datetime
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = years(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~2.6s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = months(1)
	for i = 1:1000000
		r = t + tt
	end
end
@time test() #~3.2s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = weeks(1)
	for i = 1:1000000
		r = t >> tt
	end
end
@time test() #~0.03s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = days(1)
	for i = 1:1000000
		r = t >> tt
	end
end
@time test() #~0.03s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = hours(1)
	for i = 1:1000000
		r = t >> tt
	end
end
@time test() #~0.03s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = minutes(1)
	for i = 1:1000000
		r = t >> tt
	end
end
@time test() #~0.03s
function test()
	t = datetime(2013,7,8,23,59,59)
	tt = seconds(1)
	for i = 1:1000000
		r = t >> tt
	end
end
@time test() #~0.03s
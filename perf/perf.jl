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
	for i = 1:1000000
		r = t + days(1)
	end
end
@time test() #~0.03s
function test()
	t = ymd(2013,7,8,"UTC")
	for i = 1:1000000
		r = t + years(1)
	end
end
@time test() #~2.9s
function test()
	t = ymd(2013,7,8,"UTC")
	for i = 1:1000000
		r = t + minutes(1)
	end
end
@time test() #~0.027s
function test()
	t = ymd(2013,7,8,"UTC")
	for i = 1:1000000
		r = t + months(1)
	end
end
@time test() #~3s
#Datetime
function test()
	t = date(2013,7,8)
	for i = 1:1000000
		r = t + days(1)
	end
end
@time test() #~2s
function test()
	t = date(2013,7,8)
	for i = 1:1000000
		r = t + years(1)
	end
end
@time test() #~0.86s
function test()
	t = date(2013,7,8)
	for i = 1:1000000
		r = t + months(1)
	end
end
@time test() #~1.15s
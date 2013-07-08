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
@time test() #~4.64s

function test()
	for i = 1:1000000
		t = lastday(date(2000+i,i%12+1,i%30+1))
	end
end
@time test()
function test()
	for i = 1:1000000
		t = dayofyear(date(2000+i,i%12+1,i%30+1))
	end
end
@time test()
function test()
	for i = 1:1000000
		t = dayofweek(date(2000+i,i%12,i%30))
	end
end
@time test()
function test()
	for i = 1:1000000
		t = _day2date(_daynumbers(date(2000+i,i%12,i%30)))
	end
end
@time test()
function test()
	for i = 1:1000000
		t = _daynumbers(date(2000+i,i%12,i%30))
	end
end
@time test()
function test()
	for i = 1:1000000
		t = date(2000+i,12,30)
	end
end
@time test()
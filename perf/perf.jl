perf = ref(String)
timing = ref(Float64)
baseline = ref(Float64)
function test()
	tic()
	y,m,d,h,mi,s = 1982,6,30,23,59,59
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s) #UTC
	end
	return toq()
end
push!(perf,"Create UTC DateTime")
push!(timing,test())
push!(baseline,0.12)
function test()
	tic()
	y,m,d,h,mi,s = 1982,6,30,23,59,59
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s,VET)
	end
	return toq()
end
push!(perf,"Create VET DateTime")
push!(timing,test())
push!(baseline,2.0)
function test()
	tic()
	y,m,d,h,mi,s = 1982,6,30,23,59,59
	for i = 1:1000000
		b = datetime(y,m,d,h,mi,s,PST)
	end
	return toq()
end
push!(perf,"Create PST DateTime")
push!(timing,test())
push!(baseline,4.3)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = lastdayofmonth(dt)
	end
	return toq()
end
push!(perf,"lastdayofmonth DateTime")
push!(timing,test())
push!(baseline,0.12)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = dayofyear(dt)
	end
	return toq()
end
push!(perf,"dayofyear DateTime")
push!(timing,test())
push!(baseline,0.11)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = dayofweek(dt)
	end
	return toq()
end
push!(perf,"dayofweek DateTime")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = dayofweekinmonth(dt)
	end
	return toq()
end
push!(perf,"dayofweekinmonth DateTime")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = daysofweekinmonth(dt)
	end
	return toq()
end
push!(perf,"daysofweekinmonth DateTime")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = firstdayofweek(dt)
	end
	return toq()
end
push!(perf,"firstdayofweek DateTime")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = lastdayofweek(dt)
	end
	return toq()
end
push!(perf,"lastdayofweek DateTime")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	dt = datetime(2013,7,8,23,59,59)
	for i = 1:1000000
		t = week(dt)
	end
	return toq()
end
push!(perf,"week DateTime")
push!(timing,test())
push!(baseline,0.07)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = years(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ years(1) DateTime")
push!(timing,test())
push!(baseline,0.43)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = months(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ months(1) DateTime")
push!(timing,test())
push!(baseline,0.42)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = weeks(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ weeks(1) DateTime")
push!(timing,test())
push!(baseline,0.07)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = days(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ days(1) DateTime")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = hours(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ hours(1) DateTime")
push!(timing,test())
push!(baseline,0.07)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = minutes(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ minutes(1) DateTime")
push!(timing,test())
push!(baseline,0.08)
function test()
	tic()
	t = datetime(2013,7,8,23,59,59)
	tt = seconds(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ seconds(1) DateTime")
push!(timing,test())
push!(baseline,0.07)

#Date
function test()
	tic()
	y,m,d = 1982,6,30
	for i = 1:1000000
		b = date(y,m,d)
	end
	return toq()
end
push!(perf,"Create Date")
push!(timing,test())
push!(baseline,0.07)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = dayofyear(dt)
	end
	return toq()
end
push!(perf,"dayofyear Date")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = lastdayofmonth(dt)
	end
	return toq()
end
push!(perf,"lastdayofmonth Date")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = dayofweekinmonth(dt)
	end
	return toq()
end
push!(perf,"dayofweekinmonth Date")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = daysofweekinmonth(dt)
	end
	return toq()
end
push!(perf,"daysofweekinmonth Date")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = firstdayofweek(dt)
	end
	return toq()
end
push!(perf,"firstdayofweek Date")
push!(timing,test())
push!(baseline,0.03)
function test()
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = lastdayofweek(dt)
	end
	return toq()
end
push!(perf,"lastdayofweek Date")
push!(timing,test())
push!(baseline,0.03)
function test() ####
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = dayofweek(dt)
	end
	return toq()
end
push!(perf,"dayofweek Date")
push!(timing,test())
push!(baseline,0.0003)
function test() #####
	tic()
	dt = date(2013,7,8)
	for i = 1:1000000
		t = week(dt)
	end
	return toq()
end
push!(perf,"week Date")
push!(timing,test())
push!(baseline,0.02)
function test()
	tic()
	t = date(2013,7,8)
	tt = years(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ years(1) Date")
push!(timing,test())
push!(baseline,0.15)
function test()
	tic()
	t = date(2013,7,8)
	tt = months(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ months(1) Date")
push!(timing,test())
push!(baseline,0.23)
function test()
	tic()
	t = date(2013,7,8)
	tt = weeks(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ weeks(1) Date")
push!(timing,test())
push!(baseline,0.05)
function test()
	tic()
	t = date(2013,7,8)
	tt = days(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ days(1) Date")
push!(timing,test())
push!(baseline,0.06)
#results
results = [perf timing baseline]
println(results)
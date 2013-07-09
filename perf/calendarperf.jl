using Calendar
perf = ref(String)
timing = ref(Float64)
function test()
	tic()
	for i = 1:1000000
		t = ymd_hms(1982,6,30,23,59,59)
	end
	return toq()
end
push!(perf,"Create Default CalendarTime")
push!(timing,test())
function test()
	tic()
	for i = 1:1000000
		t = ymd_hms(1982,6,30,23,59,59,"UTC")
	end
	return toq()
end
push!(perf,"Create UTC CalendarTime")
push!(timing,test())
function test()
	tic()
	for i = 1:1000000
		t = ymd_hms(1982,6,30,23,59,59,"VET")
	end
	return toq()
end
push!(perf,"Create VET CalendarTime")
push!(timing,test())
function test()
	tic()
	for i = 1:1000000
		t = ymd_hms(1982,6,30,23,59,59,"PST")
	end
	return toq()
end
push!(perf,"Create PST CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8)
	for i = 1:1000000
		r = dayofyear(t)
	end
	return toq()
end
push!(perf,"dayofyear CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8)
	for i = 1:1000000
		r = dayofweek(t)
	end
	return toq()
end
push!(perf,"dayofweek CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8)
	for i = 1:1000000
		r = week(t)
	end
	return toq()
end
push!(perf,"week CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = years(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ years(1) CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = months(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ months(1) CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = days(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ days(1) CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = hours(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ hours(1) CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = minutes(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ minutes(1) CalendarTime")
push!(timing,test())
function test()
	tic()
	t = ymd(2013,7,8,"UTC")
	tt = seconds(1)
	for i = 1:1000000
		r = t + tt
	end
	return toq()
end
push!(perf,"+ seconds(1) CalendarTime")
push!(timing,test())
#results
results = [perf timing]
println(results)
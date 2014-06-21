""" tests for TmStruct conversions and strftime() """
using Datetime


function test_date(d1::Date)
    tmd1 = Date2TmStruct(d1)  #tmd
    d1b = TmStruct2Date(tmd1)
    println("d1 $d1, tmd1 $tmd1, d1b $d1b")
    println(d1==d1b)
end

function test_datetime(d1::DateTime)
    println("test_datetime")
    tmd1 = DateTime2TmStruct(d1)  #tmd
    d1b = TmStruct2DateTime(tmd1)
    println("d1 $d1, tmd1 $tmd1, d1b $d1b")
    println(d1==d1b)
end


println("\nDate to Tm to Date Round Trip")
test_date(date(1970,1,1))
test_date(date(1978,2,1))
test_date(date(2012,7,31))


println("\nDate strftime")
d= date(1970,4,1)
println( strftime("%d-%Y-%m", d) )
println( strftime("%d-%Y-%m", d) == "01-1970-04")

d2= date(2013,11,25)
println( strftime("%d-%Y-%m %A", d2) )
println( strftime("%d-%Y-%m %A", d2) == "25-2013-11 Monday" )

println( strftime("%d-%Y-%m %a", d2) )
println( strftime("%d-%Y-%m %a", d2) == "25-2013-11 Mon" )

println( strftime("%d-%Y-%m %b", d2) )
println( strftime("%d-%Y-%m %b", d2) == "25-2013-11 Nov" )

println( strftime("%Y-%m-%d %H:%M:%S", d2) )
println( strftime("%Y-%m-%d %H:%M:%S", d2)  == "2013-11-25 00:00:00" )



println("\nDateTime to Tm to DateTime Round Trip")
dt1= datetime(1970,1,1,23,12,45)
tmdt1 = DateTime2TmStruct(dt1)
dt1b = TmStruct2DateTime(tmdt1)
println("dt1 $dt1, tmdt1 $tmdt1, dt1b $dt1b")
println(dt1==dt1b)

test_datetime( datetime(1970,1,1,23,12,45) )
test_datetime( datetime(1998,2,28,23,59,59) )
test_datetime( datetime(2013,4,30,0,0,0) )


println("\nDateTime strftime")
dt2= datetime(2013,11,25, 15,7,59)
println( strftime("%Y-%m-%d %H:%M:%S", dt2) )
println( strftime("%Y-%m-%d %H:%M:%S", dt2)  == "2013-11-25 15:07:59" )

println( strftime("%A, %m-%d-%Y %H:%M", dt2) )
println( strftime("%A, %m-%d-%Y %H:%M", dt2)  == "Monday, 11-25-2013 15:07" )

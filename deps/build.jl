warn("The Datetime.jl package is deprecated, but will remain maintained for the 0.3 release. Please consider using the Dates.jl package instead, which mirrors the Dates module in Base Julia in 0.4")

const FILEPATH = joinpath(dirname(@__FILE__),"tzdata")

#create _leaps and _leaps1
function make_leaps(fname)
  temp = Int[]
  open(joinpath(FILEPATH, fname*".dat")) do fin
    #readdlm was giving an InexactError, so I read the file by hand
    for x in readlines(fin)
      push!(temp, int(x))
    end
  end
  open(joinpath(FILEPATH, fname), "w") do fout
    serialize(fout, temp)
  end
end

for fname in ["_leaps", "_leaps1"]
  make_leaps(fname)
end

#create Zone***DATA
function make_zones(fname)
  #There is probably a better way to read this in
  temp = {}
  open(joinpath(FILEPATH, fname*".dat")) do fin
    for x in readlines(fin)
      ss = split(x, " ")
      push!(temp, ss[1], int(ss[2]), int(ss[3]))
    end
  end

  #reshape temp to matrix for serializing
  mat = transpose(reshape(temp, 3, div(length(temp), 3)))
  open(joinpath(FILEPATH, fname), "w") do fout
    serialize(fout, mat)
  end
end

tzs = map(chomp, collect(open(readlines, joinpath(FILEPATH, "timezonenames"))))

map(make_zones, tzs)

const FILEPATH = normpath(dirname(Base.source_path()), "..", "src", "tzdata")

#create _leaps and _leaps1
function make_leaps(fname)
  temp = Int64[]
  open(joinpath(FILEPATH, fname*".dat")) do fin
    #readdlm was giving an InexactError, so I read the file by hand
    for x in readlines(fin)
    push!(temp, int64(x))
    end
  end
  fout = open(joinpath(FILEPATH, fname), "w")
  serialize(fout, temp)
  close(fout)
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
      push!(temp, ss[1], int64(ss[2]), int64(ss[3]))
    end
  end

  #reshape temp to matrix for serializing
  mat = transpose(reshape(temp, 3, div(length(temp), 3)))
  fout = open(joinpath(FILEPATH, fname), "w")
  serialize(fout, mat)
  close(fout)
end

tzs = map(chomp, collect(open(readlines, joinpath(FILEPATH, "timezonenames"))))

map(make_zones, tzs)

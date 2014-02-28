Datetime.jl
=======
[![Build Status](https://travis-ci.org/karbarcca/Datetime.jl.png)](https://travis-ci.org/karbarcca/Datetime.jl)

A Date and DateTime implementation for Julia

Open the test/run_test.jl file for more examples of code to run and functionality.

Installation/Usage
--
Installation through the Julia package manager:
```julia
julia> Pkg.init()          # Creates julia package repository (only runs once for all packages)
julia> Pkg.add("Datetime") # Creates the Datetime repo folder and downloads the Datetime package
julia> Pkg.checkout("Datetime","dev") # Checks out the new dev branch
julia> include(Pkg.dir() * "/Datetime/src/Dates.jl")      # Loads the Dates module for use (needs to be run with each new Julia instance)
julia> using Dates
```


* Checkout the updated [Dates manual](https://github.com/karbarcca/Datetime.jl/wiki/Dates-module:-dev-branch)

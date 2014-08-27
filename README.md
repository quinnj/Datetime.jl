Datetime.jl
=======
[![Build Status](https://travis-ci.org/quinnj/Datetime.jl.png)](https://travis-ci.org/quinnj/Datetime.jl)
[![Coverage Status](https://img.shields.io/coveralls/quinnj/Dates.jl.svg)](https://coveralls.io/r/quinnj/Datetime.jl)

>This project is now obsolete. Starting with version `0.4-dev`, date and time functionality has been added to Julia base. For codebases on Julia version `0.3-` the same functionality is packaged as [Dates.jl](https://github.com/quinnj/Dates.jl)

A Date and DateTime implementation for Julia

Open the test/test.jl file for more examples of code to run and functionality.

Installation/Usage
--
Installation through the Julia package manager:
```julia
julia> Pkg.init()          # Creates julia package repository (only runs once for all packages)
julia> Pkg.add("Datetime") # Creates the Datetime repo folder and downloads the Datetime package
julia> using Datetime      # Loads the Datetime module for use (needs to be run with each new Julia instance)
```


* Checkout the [Datetime manual](https://github.com/quinnj/Datetime.jl/wiki/Datetime-Manual)

* Information on [timezones](https://github.com/quinnj/Datetime.jl/wiki/Timezone-Information) used in Datetime

* [API Reference](https://github.com/quinnj/Datetime.jl/wiki/API-Reference)

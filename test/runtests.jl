using Base.Filesystem
using Test
using openPMD2

# Basic features
include("test_version.jl")

# Basic types
include("test_Access.jl")
include("test_Datatype.jl")
include("test_Format.jl")
include("test_IterationEncoding.jl")
include("test_UnitDimension.jl")

include("test_Attributable.jl")

include("test_Series.jl")

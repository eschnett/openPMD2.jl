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

include("test_Attributes.jl")

# tmpdir = Filesystem.mktempdir(; cleanup=true)
tmpdir = "/tmp"
filename = joinpath(tmpdir, "hello.json")

include("test_Series_write.jl")
include("test_Series_read.jl")

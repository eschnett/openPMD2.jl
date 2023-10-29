module openPMD2

using MPI
using openPMD_api_C_jll

# Basic features
include("version.jl")

# Basic types
include("Access.jl")
include("Datatype.jl")
include("Format.jl")
include("IterationEncoding.jl")
include("UnitDimension.jl")

include("Attributes.jl")
include("Iteration.jl")

include("Iterations.jl")
include("ReadIterations.jl")
include("WriteIterations.jl")

include("Series.jl")

end

module openPMD2

using MPI
using openPMD_api_C_jll

mutable struct Object
    function Object(fin)
        obj = new()
        finalizer(fin, obj)
        return obj
    end
end

# Basic features
include("version.jl")

# Basic types
include("Access.jl")
include("Datatype.jl")
include("Format.jl")
include("IterationEncoding.jl")
include("UnitDimension.jl")

include("Attributable.jl")

include("Series.jl")

end

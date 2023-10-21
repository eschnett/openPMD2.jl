module openPMD2

using openPMD_api_C_jll

# Basic features
include("version.jl")

# Basic types
include("Access.jl")
include("Format.jl")

end

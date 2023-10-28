"""
    mutable struct ReadIterations
"""
mutable struct ReadIterations
    c_read_iterations_ptr::Ptr{Cvoid}
    function ReadIterations(c_read_iterations_ptr::Ptr{Cvoid})
        read_iterations = new(c_read_iterations_ptr)
        finalizer(ReadIterations_delete!, read_iterations)
        return read_iterations
    end
end
export ReadIterations

Base.cconvert(::Type{Ptr{Cvoid}}, read_iterations::ReadIterations) = read_iterations.c_read_iterations_ptr

function ReadIterations_delete!(read_iterations::ReadIterations)
    @ccall libopenPMD_c.openPMD_ReadIterations_delete(read_iterations::Ptr{Cvoid})::Cvoid
    return nothing
end

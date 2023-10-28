"""
    mutable struct WriteIterations
"""
mutable struct WriteIterations
    c_write_iterations_ptr::Ptr{Cvoid}
    function WriteIterations(c_write_iterations_ptr::Ptr{Cvoid})
        write_iterations = new(c_write_iterations_ptr)
        finalizer(WriteIterations_delete!, write_iterations)
        return write_iterations
    end
end
export WriteIterations

Base.cconvert(::Type{Ptr{Cvoid}}, write_iterations::WriteIterations) = write_iterations.c_write_iterations_ptr

function WriteIterations_delete!(write_iterations::WriteIterations)
    @ccall libopenPMD_c.openPMD_WriteIterations_delete(write_iterations::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function Base.getindex(write_iterations::WriteIterations, key::Integer)
"""
function Base.getindex(write_iterations::WriteIterations, key::Integer)
    c_iteration = @ccall libopenPMD_c.openPMD_WriteIterations_get(write_iterations.c_write_iterations_ptr::Ptr{Cvoid},
                                                                  key::UInt64)::Ptr{Cvoid}
    return Iteration(c_iteration)
end

"""
    function current_iteration(write_iterations::WriteIterations)
"""
function current_iteration(write_iterations::WriteIterations)
    c_iteration = @ccall libopenPMD_c.openPMD_WriteIterations_currentIteration(write_iterations.c_write_iterations_ptr::Ptr{Cvoid})::Ptr{Cvoid}
    return Iteration(c_iteration)
end
export current_iteration

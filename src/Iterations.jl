mutable struct Iterations <: AbstractDict{Int,Iteration}
    # `c_iterations_ptr` is non-owning. We thus store a corresponding owning pointer in `parent`.
    c_iterations_ptr::Ptr{Cvoid}
    parent::Any
    Iterations(c_iterations_ptr::Ptr{Cvoid}, parent::Any) = new(c_iterations_ptr, parent)
end
export Iterations

Base.cconvert(::Type{Ptr{Cvoid}}, iterations::Iterations) = iterations.c_iterations_ptr

"""
    function attributes(iterations::Iterations)::Attributes
"""
function attributes(iterations::Iterations)
    c_attributable_ptr = @ccall libopenPMD_c.openPMD_Container_Iteration_getAttributable(iterations::Ptr{Cvoid})::Ptr{Cvoid}
    return Attributes(c_attributable_ptr, iterations.parent)
end
export attributes

"""
    function isempty(iterations::Iterations)::Bool
"""
function Base.isempty(iterations::Iterations)
    isem = @ccall libopenPMD_c.openPMD_Container_Iteration_empty(iterations::Ptr{Cvoid})::UInt8
    return Bool(isem)
end

"""
    function length(iterations::Iterations)::Int
"""
function Base.length(iterations::Iterations)
    len = @ccall libopenPMD_c.openPMD_Container_Iteration_size(iterations::Ptr{Cvoid})::Csize_t
    return Int(len)
end

"""
    function empty!(iterations::Iterations)::Nothing
"""
function Base.empty!(iterations::Iterations)
    @ccall libopenPMD_c.openPMD_Container_Iteration_clear(iterations::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function getindex(iterations::Iterations, key::Integer)::Iteration
"""
function Base.getindex(iterations::Iterations, key::Integer)
    c_iteration_ptr = @ccall libopenPMD_c.openPMD_Container_Iteration_get(iterations::Ptr{Cvoid}, key::UInt64)::Ptr{Cvoid}
    return Iteration(c_iteration_ptr)
end

"""
    function setindex!(iterations::Iterations, iteration::Iteration, key::Integer)::Nothing
"""
function Base.setindex!(iterations::Iterations, iteration::Iteration, key::Integer)
    @ccall libopenPMD_c.openPMD_Container_Iteration_set(iterations::Ptr{Cvoid}, key::UInt64, iteration::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function haskey(iterations::Iterations, key::Integer)::Bool
"""
function Base.haskey(iterations::Iterations, key::Integer)
    has = @ccall libopenPMD_c.openPMD_Container_Iteration_contains(iterations::Ptr{Cvoid}, key::UInt64)::UInt8
    return Bool(has)
end

"""
    function delete!(iterations::Iterations, key::Integer)::Iterations
"""
function Base.delete!(iterations::Iterations, key::Integer)
    @ccall libopenPMD_c.openPMD_Container_Iteration_erase(iterations::Ptr{Cvoid}, key::UInt64)::Cvoid
    return iterations
end

"""
    mutable struct Iteration
"""
mutable struct Iteration
    c_iteration_ptr::Ptr{Cvoid}
    function Iteration(c_iteration_ptr::Ptr{Cvoid})
        iteration = new(c_iteration_ptr)
        finalizer(Iteration_delete!, iteration)
        return iteration
    end
end
export Iteration

function Iteration_delete!(iteration::Iteration)
    @ccall libopenPMD_c.openPMD_Iteration_delete(iteration::Ptr{Cvoid})::Cvoid
    return nothing
end

Base.cconvert(::Type{Ptr{Cvoid}}, iteration::Iteration) = iteration.c_iteration_ptr

"""
    function attributes(iteration::Iteration)::Attributes
"""
function attributes(iteration::Iteration)::Attributes
    c_attributes = @ccall libopenPMD_c.openPMD_Iteration_getAttributable(iteration::Ptr{Cvoid})::Ptr{Cvoid}
    return Attributes(c_attributes, iteration)
end
export attributes

#TODO    openPMD_Iteration *
#TODO    openPMD_Iteration_copy(const openPMD_Iteration *iteration);

"""
    function get_time(iteration::Iteration)::Float64
"""
function get_time(iteration::Iteration)
    time = @ccall libopenPMD_c.openPMD_Iteration_time(iteration.c_iteration_ptr::Ptr{Cvoid})::Cdouble
    return Float64(time)
end
export get_time

"""
    function set_time!(iteration::Iteration, time::Real)::Nothing
"""
function set_time!(iteration::Iteration, time::Real)
    @ccall libopenPMD_c.openPMD_Iteration_setTime(iteration.c_iteration_ptr::Ptr{Cvoid}, time::Cdouble)::Cvoid
    return nothing
end
export set_time!

"""
    function get_dt(iteration::Iteration)::Float64
"""
function get_dt(iteration::Iteration)
    dt = @ccall libopenPMD_c.openPMD_Iteration_dt(iteration.c_iteration_ptr::Ptr{Cvoid})::Cdouble
    return Float64(dt)
end
export get_dt

"""
    function set_dt!(iteration::Iteration, dt::Real)::Nothing
"""
function set_dt!(iteration::Iteration, dt::Real)
    @ccall libopenPMD_c.openPMD_Iteration_setDt(iteration.c_iteration_ptr::Ptr{Cvoid}, dt::Cdouble)::Cvoid
    return nothing
end
export set_dt!

"""
    function get_time_unit_SI(iteration::Iteration)::Float64
"""
function get_time_unit_SI(iteration::Iteration)
    time_unit_SI = @ccall libopenPMD_c.openPMD_Iteration_timeUnitSI(iteration.c_iteration_ptr::Ptr{Cvoid})::Cdouble
    return Float64(time_unit_SI)
end
export get_time_unit_SI

"""
    function set_time_unit_SI!(iteration::Iteration, time_unit_SI::Real)::Nothing
"""
function set_time_unit_SI!(iteration::Iteration, time_unit_SI::Real)
    @ccall libopenPMD_c.openPMD_Iteration_setTimeUnitSI(iteration.c_iteration_ptr::Ptr{Cvoid}, time_unit_SI::Cdouble)::Cvoid
    return nothing
end
export set_time_unit_SI!

"""
    function close(iteration::Iteration)::Nothing
"""
function Base.close(iteration::Iteration)
    @ccall libopenPMD_c.openPMD_Iteration_close(iteration.c_iteration_ptr::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function open(iteration::Iteration)::Nothing
"""
function Base.open(iteration::Iteration)
    @ccall libopenPMD_c.openPMD_Iteration_open(iteration.c_iteration_ptr::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function isclosed(iteration::Iteration)::Bool
"""
function isclosed(iteration::Iteration)
    iscl = @ccall libopenPMD_c.openPMD_Iteration_closed(iteration.c_iteration_ptr::Ptr{Cvoid})::UInt8
    return Bool(iscl)
end
export isclosed

#TODO    const openPMD_Container_Mesh *
#TODO    openPMD_Iteration_constMeshes(const openPMD_Iteration *iteration);
#TODO
#TODO    openPMD_Container_Mesh *
#TODO    openPMD_Iteration_meshes(openPMD_Iteration *iteration);
#TODO
#TODO    void openPMD_Iteration_delete(openPMD_Iteration *iteration);
#TODO
#TODO    typedef struct openPMD_IndexedIteration openPMD_IndexedIteration;
#TODO
#TODO    const openPMD_Iteration *openPMD_IndexedIteration_getConstIteration(
#TODO        const openPMD_IndexedIteration *indexed_iteration);
#TODO
#TODO    openPMD_Iteration *openPMD_IndexedIteration_getIteration(
#TODO        openPMD_IndexedIteration *indexed_iteration);
#TODO
#TODO    uint64_t openPMD_IndexedIteration_iterationIndex(
#TODO        const openPMD_IndexedIteration *indexed_iteration);

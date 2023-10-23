"""
    struct Series
"""
struct Series
    c_series_ptr::Ptr{Cvoid}
    object::Object
    function Series(c_series_ptr::Ptr{Cvoid})
        object = Object(_ -> Series_delete!(c_series_ptr))
        return new(c_series_ptr, object)
    end
end
export Series

function Series_delete!(c_series_ptr::Ptr{Cvoid})
    @ccall libopenPMD_c.openPMD_Series_delete(c_series_ptr::Ptr{Cvoid})::Cvoid
    return nothing
end

"""
    function Series()::Series
"""
function Series()
    c_series_ptr = @ccall libopenPMD_c.openPMD_Series_new()::Ptr{Cvoid}
    return Series(c_series_ptr)
end

"""
    function Series(filepath::AbstractString, access::Access, options::Union{Nothing,AbstractString})::Series
"""
function Series(filepath::AbstractString, access::Access, options::Union{Nothing,AbstractString}=nothing)
    c_series_ptr = if options === nothing
        @ccall libopenPMD_c.openPMD_Series_new_serial(filepath::Cstring, access::Cint, Ptr{Cchar}()::Ptr{Cchar})::Ptr{Cvoid}
    else
        @ccall libopenPMD_c.openPMD_Series_new_serial(filepath::Cstring, access::Cint, options::Cstring)::Ptr{Cvoid}
    end
    return Series(c_series_ptr)
end

"""
    function Series(filepath::AbstractString, access::Access, comm::MPI.comm, options::Union{Nothing,AbstractString})::Series
"""
function Series(filepath::AbstractString, access::Access, comm::MPI.Comm, options::Union{Nothing,AbstractString}=nothing)
    c_options = options === nothing ? Ptr{Cchar}() : options
    c_series_ptr = @static if sizeof(MPI.Comm) == 4
        @ccall libopenPMD_c.openPMD_Series_new_parallel(filepath::Cstring, access::Cint, comm.val::UInt32,
                                                        c_options::Cstring)::Ptr{Cvoid}
    else
        @static if sizeof(MPI.Comm) == 8
            @ccall libopenPMD_c.openPMD_Series_new_parallel(filepath::Cstring, access::Cint, comm.val::UInt64,
                                                            c_options::Cstring)::Ptr{Cvoid}
        else
            @assert false
        end
    end
    return Series(c_series_ptr)
end

"""
    function getindex(series::Series, key::AbstractString)::Union{Nothing,Datatypes}
"""
function Base.getindex(series::Series, key::AbstractString)
    c_attr = @ccall libopenPMD_c.openPMD_Series_getConstAttributable(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cvoid}
    attr = Attributable(c_attr, series.object)
    return get_attribute(attr, key)
end

"""
    function setindex!(series::Series, value::Datatypes, key::AbstractString)::Nothing
"""
function Base.setindex!(series::Series, value::Datatypes, key::AbstractString)
    c_attr = @ccall libopenPMD_c.openPMD_Series_getAttributable(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cvoid}
    attr = Attributable(c_attr, series.object)
    return set_attribute!(attr, key, value)
end

"""
    function in(key::AbstractString, series::Series)::Bool
"""
function Base.in(key::AbstractString, series::Series)
    c_attr = @ccall libopenPMD_c.openPMD_Series_getConstAttributable(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cvoid}
    c_contains = @ccall libopenPMD_c.openPMD_Attributable_containsAttribute(c_attr::Ptr{Cvoid}, key::Cstring)::UInt8
    return Bool(c_contains)
end

"""
    function isvalid(series::Series)::Bool
"""
function Base.isvalid(series::Series)
    c_isvalid = @ccall libopenPMD_c.openPMD_Series_has_value(series.c_series_ptr::Ptr{Cvoid})::UInt8
    return Bool(c_isvalid)
end

"""
    function openPMD_version(series::Series)::AbstractString
"""
function get_openPMD_version(series::Series)
    c_openPMD_version = @ccall libopenPMD_c.openPMD_Series_openPMD(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    openPMD_version = unsafe_string(c_openPMD_version)
    @ccall free(c_openPMD_version::Ptr{Cvoid})::Cvoid
    return openPMD_version::AbstractString
end
export get_openPMD_version

"""
    function set_openPMD_version!(series::Series, version::AbstractString)::Nothing
"""
function set_openPMD_version!(series::Series, openPMD_version::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setOpenPMD(series.c_series_ptr::Ptr{Cvoid}, openPMD_version::Cstring)::Cvoid
    return nothing
end
export set_openPMD_version!

"""
    function openPMD_extension(series::Series)::Unsigned
"""
function get_openPMD_extension(series::Series)
    openPMD_extension = @ccall libopenPMD_c.openPMD_Series_openPMDextension(series.c_series_ptr::Ptr{Cvoid})::UInt32
    return openPMD_extension::Unsigned
end
export get_openPMD_extension

"""
    function set_openPMD_extension!(series::Series, extension::Unsigned)::Nothing
"""
function set_openPMD_extension!(series::Series, openPMD_extension::Unsigned)
    @ccall libopenPMD_c.openPMD_Series_setOpenPMDextension(series.c_series_ptr::Ptr{Cvoid}, openPMD_extension::UInt32)::Cvoid
    return nothing
end
export set_openPMD_extension!

"""
    function base_path(series::Series)::AbstractString
"""
function get_base_path(series::Series)
    c_base_path = @ccall libopenPMD_c.openPMD_Series_basePath(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    base_path = unsafe_string(c_base_path)
    @ccall free(c_base_path::Ptr{Cvoid})::Cvoid
    return base_path::AbstractString
end
export get_base_path

"""
    function set_base_path!(series::Series, base_path::AbstractString)::Nothing
"""
function set_base_path!(series::Series, base_path::AbstractString)
    throw(ErrorException("Custom basePath not allowed in openPMD <=1.1.0"))
    # @ccall libopenPMD_c.openPMD_Series_setBasePath(series.c_series_ptr::Ptr{Cvoid}, base_path::Cstring)::Cvoid
    # return nothing
end
export set_base_path!

"""
    function get_meshes_path(series::Series)::AbstractString
"""
function get_meshes_path(series::Series)
    c_meshes_path = @ccall libopenPMD_c.openPMD_Series_meshesPath(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    meshes_path = unsafe_string(c_meshes_path)
    @ccall free(c_meshes_path::Ptr{Cvoid})::Cvoid
    return meshes_path::AbstractString
end
export get_meshes_path

"""
    function set_meshes_path!(series::Series, meshes_path::AbstractString)::Nothing
"""
function set_meshes_path!(series::Series, meshes_path::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setMeshesPath(series.c_series_ptr::Ptr{Cvoid}, meshes_path::Cstring)::Cvoid
    return nothing
end
export set_meshes_path!

"""
    function get_particles_path(series::Series)::AbstractString
"""
function get_particles_path(series::Series)
    c_particles_path = @ccall libopenPMD_c.openPMD_Series_particlesPath(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    particles_path = unsafe_string(c_particles_path)
    @ccall free(c_particles_path::Ptr{Cvoid})::Cvoid
    return particles_path::AbstractString
end
export get_particles_path

"""
    function set_particles_path!(series::Series, particles_path::AbstractString)::Nothing
"""
function set_particles_path!(series::Series, particles_path::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setParticlesPath(series.c_series_ptr::Ptr{Cvoid}, particles_path::Cstring)::Cvoid
    return nothing
end
export set_particles_path!

"""
    function get_author(series::Series)::AbstractString
"""
function get_author(series::Series)
    c_author = @ccall libopenPMD_c.openPMD_Series_author(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    author = unsafe_string(c_author)
    @ccall free(c_author::Ptr{Cvoid})::Cvoid
    return author::AbstractString
end
export get_author

"""
    function set_author!(series::Series, author::AbstractString)::Nothing
"""
function set_author!(series::Series, author::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setAuthor(series.c_series_ptr::Ptr{Cvoid}, author::Cstring)::Cvoid
    return nothing
end
export set_author!

"""
    function get_software(series::Series)::AbstractString
"""
function get_software(series::Series)
    c_software = @ccall libopenPMD_c.openPMD_Series_software(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    software = unsafe_string(c_software)
    @ccall free(c_software::Ptr{Cvoid})::Cvoid
    return software::AbstractString
end
export get_software

"""
    function set_software!(series::Series, software::AbstractString, version::AbstractString)::Nothing
"""
function set_software!(series::Series, software::AbstractString, version::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setSoftware(series.c_series_ptr::Ptr{Cvoid}, software::Cstring, version::Cstring)::Cvoid
    return nothing
end
export set_software!

"""
    function get_date(series::Series)::AbstractString
"""
function get_date(series::Series)
    c_date = @ccall libopenPMD_c.openPMD_Series_date(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    date = unsafe_string(c_date)
    @ccall free(c_date::Ptr{Cvoid})::Cvoid
    return date::AbstractString
end
export get_date

"""
    function set_date!(series::Series, date::AbstractString)::Nothing
"""
function set_date!(series::Series, date::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setDate(series.c_series_ptr::Ptr{Cvoid}, date::Cstring)::Cvoid
    return nothing
end
export set_date!

"""
    function get_software_dependencies(series::Series)::AbstractString
"""
function get_software_dependencies(series::Series)
    c_software_dependencies = @ccall libopenPMD_c.openPMD_Series_softwareDependencies(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    software_dependencies = unsafe_string(c_software_dependencies)
    @ccall free(c_software_dependencies::Ptr{Cvoid})::Cvoid
    return software_dependencies::AbstractString
end
export get_software_dependencies

"""
    function set_software_dependencies!(series::Series, software_dependencies::AbstractString)::Nothing
"""
function set_software_dependencies!(series::Series, software_dependencies::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setSoftwareDependencies(series.c_series_ptr::Ptr{Cvoid},
                                                               software_dependencies::Cstring)::Cvoid
    return nothing
end
export set_software_dependencies!

"""
    function get_machine(series::Series)::AbstractString
"""
function get_machine(series::Series)
    c_machine = @ccall libopenPMD_c.openPMD_Series_machine(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    machine = unsafe_string(c_machine)
    @ccall free(c_machine::Ptr{Cvoid})::Cvoid
    return machine::AbstractString
end
export get_machine

"""
    function set_machine!(series::Series, machine::AbstractString)::Nothing
"""
function set_machine!(series::Series, machine::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setMachine(series.c_series_ptr::Ptr{Cvoid}, machine::Cstring)::Cvoid
    return nothing
end
export set_machine!

"""
    function get_iteration_encoding(series::Series)::IterationEncoding
"""
function get_iteration_encoding(series::Series)
    c_iteration_encoding = @ccall libopenPMD_c.openPMD_Series_iterationEncoding(series.c_series_ptr::Ptr{Cvoid})::Cint
    return IterationEncoding(c_iteration_encoding)
end
export get_iteration_encoding

"""
    function set_iteration_encoding!(series::Series, iteration_encoding::IterationEncoding)::Nothing
"""
function set_iteration_encoding!(series::Series, iteration_encoding::IterationEncoding)
    @ccall libopenPMD_c.openPMD_Series_setIterationEncoding(series.c_series_ptr::Ptr{Cvoid}, iteration_encoding::Cint)::Cvoid
    return nothing
end
export set_iteration_encoding!

"""
    function get_iteration_format(series::Series)::AbstractString
"""
function get_iteration_format(series::Series)
    c_iteration_format = @ccall libopenPMD_c.openPMD_Series_iterationFormat(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    iteration_format = unsafe_string(c_iteration_format)
    @ccall free(c_iteration_format::Ptr{Cvoid})::Cvoid
    return iteration_format::AbstractString
end
export get_iteration_format

"""
    function set_iteration_format!(series::Series, iteration_format::AbstractString)::Nothing
"""
function set_iteration_format!(series::Series, iteration_format::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setIterationFormat(series.c_series_ptr::Ptr{Cvoid}, iteration_format::Cstring)::Cvoid
    return nothing
end
export set_iteration_format!

"""
    function get_name(series::Series)::AbstractString
"""
function get_name(series::Series)
    c_name = @ccall libopenPMD_c.openPMD_Series_name(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    name = unsafe_string(c_name)
    @ccall free(c_name::Ptr{Cvoid})::Cvoid
    return name::AbstractString
end
export get_name

"""
    function set_name!(series::Series, name::AbstractString)::Nothing
"""
function set_name!(series::Series, name::AbstractString)
    @ccall libopenPMD_c.openPMD_Series_setName(series.c_series_ptr::Ptr{Cvoid}, name::Cstring)::Cvoid
    return nothing
end
export set_name!

"""
    function get_backend(series::Series)::AbstractString
"""
function get_backend(series::Series)
    c_backend = @ccall libopenPMD_c.openPMD_Series_backend(series.c_series_ptr::Ptr{Cvoid})::Ptr{Cchar}
    backend = unsafe_string(c_backend)
    @ccall free(c_backend::Ptr{Cvoid})::Cvoid
    return backend::AbstractString
end
export get_backend

"""
    function flush(series::Series, backend_config::Union{Nothing,AbstractString}=nothing)::Nothing
"""
function Base.flush(series::Series, backend_config::Union{Nothing,AbstractString}=nothing)
    if backend_config === nothing
        @ccall libopenPMD_c.openPMD_Series_flush(series.c_series_ptr::Ptr{Cvoid}, Ptr{Cchar}()::Ptr{Cchar})::Cvoid
    else
        @ccall libopenPMD_c.openPMD_Series_flush(series.c_series_ptr::Ptr{Cvoid}, backend_config::Cstring)::Cvoid
    end
    return nothing
end

#    openPMD_ReadIterations *
#    openPMD_Series_readIteration(openPMD_Series *series);

"""
    function parse_base(series::Series)::Nothing
"""
function parse_base(series::Series)
    @ccall libopenPMD_c.openPMD_Series_parseBase(series.c_series_ptr::Ptr{Cvoid})::Cvoid
    return nothing
end
export parse_base

#    openPMD_WriteIterations *
#    openPMD_Series_writeIteration(openPMD_Series *series);

"""
    function close(series::Series)::Nothing
"""
function Base.close(series::Series)
    @ccall libopenPMD_c.openPMD_Series_close(series.c_series_ptr::Ptr{Cvoid})::Cvoid
    return nothing
end

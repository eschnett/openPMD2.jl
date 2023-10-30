"""
    struct Attributes <: AbstractDict{AbstractString,Datatypes}
"""
struct Attributes <: AbstractDict{AbstractString,Datatypes}
    # `c_attributable_ptr` is non-owning. We thus store a corresponding owning pointer in `parent`.
    c_attributable_ptr::Ptr{Cvoid}
    parent::Any
    Attributes(c_attributable_ptr::Ptr{Cvoid}, parent::Any) = new(c_attributable_ptr, parent)
end
export Attributes

"""
    function set_attribute!(attributes::Attributes, key::AbstractString, value::Datatypes)::Bool
"""
function set_attribute! end

Base.cconvert(::Type{Ptr{Cvoid}}, attributes::Attributes) = attributes.c_attributable_ptr

# We leave out `long` (and `unsigned long`) since this is equal to either `int` or `long long`, and types must be unique.
# We leave out `long double` and `complex long double` since these are not supported by Julia.
for (suffix, Type) in [("schar", Cchar), ("short", Cshort), ("int", Cint), ("longlong", Clonglong),
                       ("uchar", Cuchar), ("ushort", Cushort), ("uint", Cuint), ("ulonglong", Culonglong),
                       ("float", Cfloat), ("double", Cdouble),
                       ("cfloat", Complex{Cfloat}), ("cdouble", Complex{Cdouble})]
    funname = Symbol(:openPMD_Attributable_setAttribute_, suffix)
    @eval function set_attribute!(attributes::Attributes, key::AbstractString, value::$Type)
        did_exist = @ccall libopenPMD_c.$funname(attributes::Ptr{Cvoid}, key::Cstring, value::$Type)::UInt8
        return Bool(did_exist)
    end
    funname = Symbol(:openPMD_Attributable_setAttribute_vec_, suffix)
    @eval function set_attribute!(attributes::Attributes, key::AbstractString, values::AbstractVector{$Type})
        did_exist = @ccall libopenPMD_c.$funname(attributes::Ptr{Cvoid}, key::Cstring, values::Ref{$Type},
                                                 length(values)::Csize_t)::UInt8
        return Bool(did_exist)
    end
end
function set_attribute!(attributes::Attributes, key::AbstractString, value::Char)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_char(attributes::Ptr{Cvoid}, key::Cstring,
                                                                           value::Cchar)::UInt8
    return Bool(did_exist)
end
function set_attribute!(attributes::Attributes, key::AbstractString, value::AbstractString)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_string(attributes::Ptr{Cvoid}, key::Cstring,
                                                                             value::Cstring)::UInt8
    return Bool(did_exist)
end
function set_attribute!(attributes::Attributes, key::AbstractString, values::AbstractVector{Char})
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_vec_char(attributes::Ptr{Cvoid}, key::Cstring,
                                                                               values::Ref{Cchar}, length(values)::Csize_t)::UInt8
    return Bool(did_exist)
end
function set_attribute!(attributes::Attributes, key::AbstractString, values::AbstractVector{<:AbstractString})
    c_values = Ptr{Cchar}[Base.unsafe_convert(Ptr{Cchar}, val) for val in values]
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_vec_string(attributes::Ptr{Cvoid}, key::Cstring,
                                                                                 c_values::Ptr{Ptr{Cchar}},
                                                                                 length(c_values)::Csize_t)::UInt8
    # Keep Julia strings alive
    for value in values
        @ccall snprintf(Ptr{Cchar}()::Ptr{Cchar}, 0::Csize_t, ""::Cstring, value::Cstring)::Cvoid
    end
    return Bool(did_exist)
end
function set_attribute!(attributes::Attributes, key::AbstractString, value::Bool)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_bool(attributes::Ptr{Cvoid}, key::Cstring,
                                                                           value::UInt8)::UInt8
    return Bool(did_exist)
end

"""
    function setindex!(attributes::Attributes, value::Datatypes, key::AbstractString)::Bool
"""
Base.setindex!(attributes::Attributes, value::Datatypes, key::AbstractString) = set_attribute!(attributes, key, value)

"""
    function get_attribute(attributes::Attributes, key::AbstractString)::Union{Nothing,Datatypes}
"""
function get_attribute(attributes::Attributes, key::AbstractString)
    c_datatype = @ccall libopenPMD_c.openPMD_Attributable_attributeDatatype(attributes::Ptr{Cvoid}, key::Cstring)::Cint
    datatype = Datatype(c_datatype)
    T = get(julia_types, datatype, nothing)
    T === nothing && throw(TypeError(:get_attribute, "openPMD type $datatype is not supported in Julia", Any, datatype))
    attribute = get_attribute(T, attributes, key)
    attribute === nothing && return nothing
    return attribute::Datatypes
end

"""
    function get_attribute(::Type{<:Datatypes}, attributes::Attributes, key::AbstractString)::Union{Nothing,Datatypes}
"""
function get_attribute end

# We leave out `long` (and `unsigned long`) since this is equal to either `int` or `long long`, and types must be unique.
# We leave out `long double` and `complex long double` since these are not supported by Julia.
for (suffix, Type) in [("schar", Cchar), ("short", Cshort), ("int", Cint), ("longlong", Clonglong),
                       ("uchar", Cuchar), ("ushort", Cushort), ("uint", Cuint), ("ulonglong", Culonglong),
                       ("float", Cfloat), ("double", Cdouble),
                       ("cfloat", Complex{Cfloat}), ("cdouble", Complex{Cdouble})]
    funname = Symbol(:openPMD_Attributable_getAttribute_, suffix)
    @eval function get_attribute(::Type{$Type}, attributes::Attributes, key::AbstractString)
        c_value = Ref{$Type}()
        did_exist = @ccall libopenPMD_c.$funname(attributes::Ptr{Cvoid}, key::Cstring, c_value::Ref{$Type})::UInt8
        !Bool(did_exist) && return nothing
        return c_value[]::$Type
    end
    funname = Symbol(:openPMD_Attributable_getAttribute_vec_, suffix)
    @eval function get_attribute(::Type{<:AbstractVector{$Type}}, attributes::Attributes, key::AbstractString)
        c_values_ptr_ref = Ref{Ptr{$Type}}()
        c_size = Ref{Csize_t}()
        did_exist = @ccall libopenPMD_c.$funname(attributes::Ptr{Cvoid}, key::Cstring, c_values_ptr_ref::Ref{Ptr{$Type}},
                                                 c_size::Ref{Csize_t})::UInt8
        !Bool(did_exist) && return nothing
        size = Int(c_size[])
        c_values_ptr = c_values_ptr_ref[]
        values = $Type[unsafe_load(c_values_ptr, n) for n in 1:size]
        @ccall free(c_values_ptr::Ptr{Cvoid})::Cvoid
        return values::AbstractVector{$Type}
    end
end
function get_attribute(::Type{Char}, attributes::Attributes, key::AbstractString)
    value = _getattribute(Cchar, attributes, key)
    value === nothing && return value
    return Char(value)
end
function get_attribute(::Type{<:AbstractString}, attributes::Attributes, key::AbstractString)
    c_value_ref = Ref{Ptr{Cchar}}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_getAttribute_string(attributes::Ptr{Cvoid}, key::Cstring,
                                                                             c_value_ref::Ref{Ptr{Cchar}})::UInt8
    !Bool(did_exist) && return nothing
    c_value = c_value_ref[]
    value = unsafe_string(c_value)
    @ccall free(c_value::Ptr{Cvoid})::Cvoid
    return value::AbstractString
end
function get_attribute(::Type{<:AbstractVector{<:AbstractString}}, attributes::Attributes, key::AbstractString)
    c_values_ptr_ref = Ref{Ptr{Ptr{Cchar}}}()
    c_size = Ref{Csize_t}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_getAttribute_vec_string(attributes::Ptr{Cvoid}, key::Cstring,
                                                                                 c_values_ptr_ref::Ref{Ptr{Ptr{Cchar}}},
                                                                                 c_size::Ref{Csize_t})::UInt8
    !Bool(did_exist) && return nothing
    c_values_ptr = c_values_ptr_ref[]
    size = Int(c_size[])
    values = String[unsafe_string(unsafe_load(c_values_ptr, n)) for n in 1:size]
    for n in 1:size
        @ccall free(unsafe_load(c_values_ptr, n)::Ptr{Cvoid})::Cvoid
    end
    @ccall free(c_values_ptr::Ptr{Cvoid})::Cvoid
    return values::AbstractVector{<:AbstractString}
end
function get_attribute(::Type{Bool}, attributes::Attributes, key::AbstractString)
    c_value = Ref{UInt8}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_getAttribute_bool(attributes::Ptr{Cvoid}, key::Cstring,
                                                                           c_value::Ref{UInt8})::UInt8
    !Bool(did_exist) && return nothing
    return Bool(c_value[])
end

"""
    function getindex(attributes::Attributes, key::AbstractString)::Datatypes
"""
function Base.getindex(attributes::Attributes, key::AbstractString)
    attribute = get_attribute(attributes, key)
    attribute === nothing && throw(KeyError(key))
    return attribute::Datatypes
end

"""
    delete!(attributes::Attributes, key::AbstractString)::Bool
"""
function Base.delete!(attributes::Attributes, key::AbstractString)
    did_exist = Ref{UInt8}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_deleteAttribute(attributes::Ptr{Cvoid}, key::Cstring)::UInt8
    return Bool(did_exist)
end

"""
    struct AttributeKeys <: AbstractDict{AbstractString,Datatypes}
"""
struct AttributeKeys <: AbstractVector{AbstractString}
    attributes::Attributes
    AttributeKeys(attributes::Attributes) = new(attributes)
end
export AttributeKeys

"""
    function Base.keys(attributes::Attributes)::AttributeKeys
"""
Base.keys(attributes::Attributes)::AttributeKeys = AttributeKeys(attributes)

"""
    function Base.collect(attribute_keys::AttributeKeys)::AbstractVector{<:AbstractString}
"""
function Base.collect(attribute_keys::AttributeKeys)
    c_table = @ccall libopenPMD_c.openPMD_Attributable_attributes(attribute_keys.attributes::Ptr{Cvoid})::Ptr{Ptr{Cchar}}
    table = String[]
    i = 0
    while true
        i += 1
        c_attr = unsafe_load(c_table, i)
        c_attr == Ptr{Cchar}() && break
        push!(table, unsafe_string(c_attr))
        @ccall free(c_attr::Ptr{Cvoid})::Cvoid
    end
    @ccall free(c_table::Ptr{Cvoid})::Cvoid
    return table::AbstractVector{<:AbstractString}
end

"""
    function iterate(attribute_keys::AttributeKeys)
"""
Base.iterate(attribute_keys::AttributeKeys) = iterate(collect(attribute_keys))

"""
    function length(attributes::Attributes)::Int
"""
function Base.length(attributes::Attributes)
    len = @ccall libopenPMD_c.openPMD_Attributable_numAttributes(attributes::Ptr{Cvoid})::Csize_t
    return Int(len)
end

"""
    function length(attribute_keys::AttributeKeys)::Int
"""
Base.length(attribute_keys::AttributeKeys) = length(attribute_keys.attributes)

"""
    function haskey(attributes::Attributes, key::AbstractString)::Bool
"""
function Base.haskey(attributes::Attributes, key::AbstractString)
    contains = @ccall libopenPMD_c.openPMD_Attributable_containsAttribute(attributes::Ptr{Cvoid}, key::Cstring)::UInt8
    return Bool(contains)
end

"""
    function in(key::AbstractString, attribute_keys::AttributeKeys)::Bool
"""
Base.in(key::AbstractString, attribute_keys::AttributeKeys) = haskey(attribute_keys.attributes, key)

"""
    function get_comment(attributes::Attributes)::AbstractString
"""
function get_comment(attributes::Attributes)
    c_comment = @ccall libopenPMD_c.openPMD_Attributable_comment(attributes::Ptr{Cvoid})::Ptr{Cchar}
    comment = unsafe_string(c_comment)
    @ccall free(c_comment::Ptr{Cvoid})::Cvoid
    return comment::AbstractString
end
export get_comment

"""
    function set_comment!(attributes::Attributes, comment::AbstractString)::Nothing
"""
function set_comment!(attributes::Attributes, comment::AbstractString)
    @ccall libopenPMD_c.openPMD_Attributable_setComment(attributes::Ptr{Cvoid}, comment::Cstring)::Cvoid
    return nothing
end
export set_comment!

"""
    function series_flush(attributes::Attributes)::Nothing
"""
function series_flush(attributes::Attributes)
    @ccall libopenPMD_c.openPMD_Attributable_seriesFlush(attributes::Ptr{Cvoid})::Cvoid
    return nothing
end
export series_flush

"""
    struct MyPath
        directory::AbstractString
        series_name::AbstractString
        series_extension::AbstractString
        group::AbstractVector{<:AbstractString}
        access::Access
    end
"""
struct MyPath
    directory::AbstractString
    series_name::AbstractString
    series_extension::AbstractString
    group::AbstractVector{<:AbstractString}
    access::Access
    c_my_path::Ptr{Cvoid}
end
export MyPath

"""
    function file_path(my_path::MyPath)::AbstractString
"""
file_path(my_path::MyPath) = my_path.directory * my_path.series_name * my_path.series_extension
export file_path

"""
    function my_path(attributes::Attributes)::MyPath
"""
function my_path(attributes::Attributes)
    c_my_path = @ccall libopenPMD_c.openPMD_Attributable_myPath(attributes::Ptr{Cvoid})::Ptr{Cvoid}
    c_directory = unsafe_load(Ptr{Ptr{Cvoid}}(c_my_path), 1)
    c_series_name = unsafe_load(Ptr{Ptr{Cvoid}}(c_my_path), 1)
    c_series_extension = unsafe_load(Ptr{Ptr{Cvoid}}(c_my_path), 1)
    c_group = unsafe_load(Ptr{Ptr{Cvoid}}(c_my_path), 4)
    c_access = unsafe_load(Ptr{Cint}(Ptr{Ptr{Cvoid}}(c_my_path) + 4))
    directory = unsafe_string(c_directory)
    series_name = unsafe_string(c_series_name)
    series_extension = unsafe_string(c_series_extension)
    group = String[]
    i = 0
    while true
        i += 1
        c_dir = unsafe_load(c_group, i)
        c_dir == Ptr{Cchar}() && break
        push!(group, unsafe_string(c_dir))
    end
    access = Access(c_access)
    my_path = MyPath(directory, series_name, series_extension, group, access)
    @ccall libopenPMD_c.openPMD_Attributable_myPath_free(c_my_path::Ptr{Cvoid})::Cvoid
    return my_path::MyPath
end
export my_path

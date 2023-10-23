struct Attributable
    c_attributable_ptr::Ptr{Cvoid}
    object::Object
end

"""
    function set_attribute!(attributable::Attributable, key::AbstractString, value::Datatypes)::Bool
"""
function set_attribute! end

# We leave out `long` (and `unsigned long`) since this is equal to either `int` or `long long`, and types must be unique.
# We leave out `long double` and `complex long double` since these are not supported by Julia.
for (suffix, Type) in [("schar", Cchar), ("short", Cshort), ("int", Cint), ("longlong", Clonglong),
                       ("uchar", Cuchar), ("ushort", Cushort), ("uint", Cuint), ("ulonglong", Culonglong),
                       ("float", Cfloat), ("double", Cdouble),
                       ("cfloat", Complex{Cfloat}), ("cdouble", Complex{Cdouble})]
    funname = Symbol(:openPMD_Attributable_setAttribute_, suffix)
    @eval function set_attribute!(attributable::Attributable, key::AbstractString, value::$Type)
        did_exist = @ccall libopenPMD_c.$funname(attributable.c_attributable_ptr::Ptr{Attributable}, key::Cstring,
                                                 value::$Type)::UInt8
        return Bool(did_exist)
    end
end
function set_attribute!(attributable::Attributable, key::AbstractString, value::Char)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_char(attributable::Ptr{Attributable}, key::Cstring,
                                                                           value::Cchar)::UInt8
    return Bool(did_exist)
end
function set_attribute!(attributable::Attributable, key::AbstractString, value::AbstractString)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_char(attributable::Ptr{Attributable}, key::Cstring,
                                                                           value::Cstring)::UInt8
    return Bool(did_exist)
end
function set_attribute!(attributable::Attributable, key::AbstractString, value::Bool)
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_setAttribute_bool(attributable::Ptr{Attributable}, key::Cstring,
                                                                           value::UInt8)::UInt8
    return Bool(did_exist)
end

"""
    function get_attribute(attributable::Attributable, key::AbstractString)::Union{Nothing,Datatypes}
"""
function get_attribute(attributable::Attributable, key::AbstractString)
    c_datatype = @ccall libopenPMD_c.openPMD_Attributable_attributeDatatype(attributable.c_attributable_ptr::Ptr{Cvoid},
                                                                            key::Cstring)::Cint
    datatype = Datatype(c_datatype)
    T = get(julia_types, datatype, nothing)
    T === nothing && throw(TypeError("openPMD type $datatype is not supported in Julia"))
    return _get_attribute(T, attributable, key)
end

# We leave out `long` (and `unsigned long`) since this is equal to either `int` or `long long`, and types must be unique.
# We leave out `long double` and `complex long double` since these are not supported by Julia.
for (suffix, Type) in [("schar", Cchar), ("short", Cshort), ("int", Cint), ("longlong", Clonglong),
                       ("uchar", Cuchar), ("ushort", Cushort), ("uint", Cuint), ("ulonglong", Culonglong),
                       ("float", Cfloat), ("double", Cdouble),
                       ("cfloat", Complex{Cfloat}), ("cdouble", Complex{Cdouble})]
    funname = Symbol(:openPMD_Attributable_getAttribute_, suffix)
    @eval function _get_attribute(::Type{$Type}, attributable::Attributable, key::AbstractString)
        c_value = Ref{$Type}()
        did_exist = @ccall libopenPMD_c.$funname(attributable.c_attributable_ptr::Ptr{Cvoid}, key::Cstring,
                                                 c_value::Ref{$Type})::UInt8
        !Bool(did_exist) && return nothing
        return c_value[]::$Type
    end
end
function _get_attribute(::Type{Char}, attributable::Attributable, key::AbstractString)
    value = _get_attribute(Cchar, attributable, key)
    value === nothing && return value
    return Char(value)
end
function _get_attribute(::Type{<:AbstractString}, attributable::Attributable, key::AbstractString)
    c_value_ref = Ref{Ptr{Cchar}}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_getAttribute_string(attributable.c_attributable_ptr::Ptr{Cvoid},
                                                                             key::Cstring,
                                                                             c_value_ref::Ref{Ptr{Cchar}})::UInt8
    !Bool(did_exist) && return nothing
    c_value = c_value_ref[]
    value = unsafe_string(c_value)
    @ccall free(c_value::Ptr{Cvoid})::Cvoid
    return value::AbstractString
end
function _get_attribute(::Type{Bool}, attributable::Attributable, key::AbstractString)
    c_value = Ref{UInt8}()
    did_exist = @ccall libopenPMD_c.openPMD_Attributable_getAttribute_bool(attributable.c_attributable_ptr::Ptr{Cvoid},
                                                                           key::Cstring,
                                                                           c_value::Ref{UInt8})::UInt8
    !Bool(did_exist) && return nothing
    return Bool(c_value[])
end

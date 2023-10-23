"""
    function openPMD_getVersion()::AbstractString
"""
function openPMD_get_version()
    version = @ccall libopenPMD_c.openPMD_getVersion()::Cstring
    return unsafe_string(version)
end
export openPMD_get_version

"""
    function openPMD_getStandard()::AbstractString
"""
function openPMD_get_standard()
    standard = @ccall libopenPMD_c.openPMD_getStandard()::Cstring
    return unsafe_string(standard)
end
export openPMD_get_standard

"""
    function openPMD_getStandardMinimum()::AbstractString
"""
function openPMD_get_standard_minimum()
    standard_minimum = @ccall libopenPMD_c.openPMD_getStandardMinimum()::Cstring
    return unsafe_string(standard_minimum)
end
export openPMD_get_standard_minimum

struct CVariant
    variant::Cstring
    supported::UInt8
end

"""
    function openPMD_getVariants()::AbstractDict{AbstractString,Bool}
"""
function openPMD_get_variants()
    c_variants = @ccall libopenPMD_c.openPMD_getVariants()::Ptr{CVariant}
    variants = Dict{AbstractString,Bool}()
    n = 0
    while true
        n += 1
        c_variant = unsafe_load(c_variants, n)
        c_variant.variant == Ptr{Cchar}() && break
        variants[unsafe_string(c_variant.variant)] = Bool(c_variant.supported)
    end
    return variants::Dict{AbstractString,Bool}
end
export openPMD_get_variants

"""
    function openPMD_getFileExtensions()::AbstractSet{<:AbstractString}
"""
function openPMD_get_file_extensions()
    c_file_extensions = @ccall libopenPMD_c.openPMD_getFileExtensions()::Ptr{Cstring}
    file_extensions = Set{String}()
    n = 0
    while true
        n += 1
        c_file_extension = unsafe_load(c_file_extensions, n)
        c_file_extension == Ptr{Cchar}() && break
        push!(file_extensions, unsafe_string(c_file_extension))
    end
    return file_extensions::AbstractSet{<:AbstractString}
end
export openPMD_get_file_extensions

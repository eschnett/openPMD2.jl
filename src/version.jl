"""
    function openPMD2.getVersion()::AbstractString
"""
function getVersion()
    version = @ccall libopenPMD_c.openPMD_getVersion()::Cstring
    return unsafe_string(version)
end

"""
    function openPMD2.getStandard()::AbstractString
"""
function getStandard()
    standard = @ccall libopenPMD_c.openPMD_getStandard()::Cstring
    return unsafe_string(standard)
end

"""
    function openPMD2.getStandardMinimum()::AbstractString
"""
function getStandardMinimum()
    standard_minimum = @ccall libopenPMD_c.openPMD_getStandardMinimum()::Cstring
    return unsafe_string(standard_minimum)
end

struct CVariant
    variant::Cstring
    supported::UInt8
end

"""
    function openPMD2.getVariants()::Dict{AbstractString,Bool}
"""
function getVariants()
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

"""
    function openPMD2.getFileExtensions()::Set{<:AbstractString}
"""
function getFileExtensions()
    c_file_extensions = @ccall libopenPMD_c.openPMD_getFileExtensions()::Ptr{Cstring}
    file_extensions = Set{String}()
    n = 0
    while true
        n += 1
        c_file_extension = unsafe_load(c_file_extensions, n)
        c_file_extension == Ptr{Cchar}() && break
        push!(file_extensions, unsafe_string(c_file_extension))
    end
    return file_extensions::Set{<:AbstractString}
end

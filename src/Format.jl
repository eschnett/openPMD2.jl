"""
    @enum Format
"""
@enum Format begin
    Format_HDF5 = 0
    Format_ADIOS2_BP = 1
    Format_ADIOS2_BP4 = 2
    Format_ADIOS2_BP5 = 3
    Format_ADIOS2_SST = 4
    Format_ADIOS2_SSC = 5
    Format_JSON = 6
    Format_TOML = 7
    Format_DUMMY = 8
end

"""
    function openPMD2.determineFormat(filename::AbstractString)::Format
"""
function determineFormat(filename::AbstractString)::Format
    format = @ccall libopenPMD_c.openPMD_determineFormat(filename::Cstring)::Cint
    return Format(format)
end

"""
    function openPMD2.suffix(format::Format)::String
"""
function suffix(format::Format)
    #TODO suf = @ccall libopenPMD_c.openPMD_suffix(format::Format)::Cstring
    suf = @ccall libopenPMD_c.suffix(format::Format)::Cstring
    return unsafe_string(suf)
end

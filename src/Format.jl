"""
    @enum Format begin
        Format_HDF5
        Format_ADIOS2_BP
        Format_ADIOS2_BP4
        Format_ADIOS2_BP5
        Format_ADIOS2_SST
        Format_ADIOS2_SSC
        Format_JSON
        Format_TOML
        Format_DUMMY
    end
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
export Format, Format_HDF5, Format_ADIOS2_BP, Format_ADIOS2_BP4, Format_ADIOS2_BP5, Format_ADIOS2_SST, Format_ADIOS2_SSC,
       Format_JSON, Format_TOML, Format_DUMMY

"""
    function determineFormat(filename::AbstractString)::Format
"""
function determine_format(filename::AbstractString)::Format
    format = @ccall libopenPMD_c.openPMD_determineFormat(filename::Cstring)::Cint
    return Format(format)
end
export determine_format

"""
    function suffix(format::Format)::AbstractString
"""
function suffix(format::Format)
    suf = @ccall libopenPMD_c.openPMD_suffix(format::Format)::Cstring
    return unsafe_string(suf)
end
export suffix

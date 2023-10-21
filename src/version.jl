"""
    function openPMD2.getVersion()::String
"""
function getVersion()
    version = @ccall libopenPMD_c.openPMD_getVersion()::Cstring
    return unsafe_string(version)
end

"""
    function openPMD2.getStandard()::String
"""
function getStandard()
    standard = @ccall libopenPMD_c.openPMD_getStandard()::Cstring
    return unsafe_string(standard)
end

"""
    function openPMD2.getStandardMinimum()::String
"""
function getStandardMinimum()
    standard_minimum = @ccall libopenPMD_c.openPMD_getStandardMinimum()::Cstring
    return unsafe_string(standard_minimum)
end

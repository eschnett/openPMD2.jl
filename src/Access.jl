"""
    @enum Access
"""
@enum Access begin
    Access_READ_ONLY = 0
    Access_READ_LINEAR = 1
    Access_READ_WRITE = 2
    Access_CREATE = 3
    Access_APPEND = 4
end
const Access_READ_RANDOM_ACCESS = Access_READ_ONLY

"""
    function openPMD2.Access_readOnly(access::openPMD2.Access)::Bool
"""
function Access_readOnly(access::Access)
    readOnly = @ccall libopenPMD_c.openPMD_Access_readOnly(access::Cint)::UInt8
    return Bool(readOnly)
end

"""
    function openPMD2.Access_read(access::openPMD2.Access)::Bool
"""
function Access_read(access::Access)
    read = @ccall libopenPMD_c.openPMD_Access_read(access::Cint)::UInt8
    return Bool(read)
end

"""
    function openPMD2.Access_writeOnly(access::openPMD2.Access)::Bool
"""
function Access_writeOnly(access::Access)
    writeOnly = @ccall libopenPMD_c.openPMD_Access_writeOnly(access::Cint)::UInt8
    return Bool(writeOnly)
end

"""
    function openPMD2.Access_write(access::openPMD2.Access)::Bool
"""
function Access_write(access::Access)
    write = @ccall libopenPMD_c.openPMD_Access_write(access::Cint)::UInt8
    return Bool(write)
end

"""
    @enum Access begin
        Access_READ_ONLY
        Access_READ_RANDOM_ACCESS
        Access_READ_LINEAR
        Access_READ_WRITE
        Access_CREATE
        Access_APPEND
    end
"""
@enum Access begin
    Access_READ_ONLY = 0
    Access_READ_LINEAR = 1
    Access_READ_WRITE = 2
    Access_CREATE = 3
    Access_APPEND = 4
end
const Access_READ_RANDOM_ACCESS = Access_READ_ONLY
export Access, Access_READ_ONLY, Access_READ_LINEAR, Access_READ_WRITE, Access_CREATE, Access_APPEND, Access_READ_RANDOM_ACCESS

"""
    function isreadonly(access::Access)::Bool
"""
function Base.isreadonly(access::Access)
    readOnly = @ccall libopenPMD_c.openPMD_Access_readOnly(access::Cint)::UInt8
    return Bool(readOnly)
end

"""
    function isreadable(access::Access)::Bool
"""
function Base.isreadable(access::Access)
    read = @ccall libopenPMD_c.openPMD_Access_read(access::Cint)::UInt8
    return Bool(read)
end

"""
    function iswriteonly(access::Access)::Bool
"""
function iswriteonly(access::Access)
    writeOnly = @ccall libopenPMD_c.openPMD_Access_writeOnly(access::Cint)::UInt8
    return Bool(writeOnly)
end
export iswriteonly

"""
    function iswritable(access::Access)::Bool
"""
function Base.iswritable(access::Access)
    write = @ccall libopenPMD_c.openPMD_Access_write(access::Cint)::UInt8
    return Bool(write)
end

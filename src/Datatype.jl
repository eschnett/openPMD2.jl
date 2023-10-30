@enum Datatype begin
    Datatype_CHAR = 0
    Datatype_UCHAR = 1
    Datatype_SCHAR = 2
    Datatype_SHORT = 3
    Datatype_INT = 4
    Datatype_LONG = 5
    Datatype_LONGLONG = 6
    Datatype_USHORT = 7
    Datatype_UINT = 8
    Datatype_ULONG = 9
    Datatype_ULONGLONG = 10
    Datatype_FLOAT = 11
    Datatype_DOUBLE = 12
    Datatype_LONG_DOUBLE = 13
    Datatype_CFLOAT = 14
    Datatype_CDOUBLE = 15
    Datatype_CLONG_DOUBLE = 16
    Datatype_STRING = 17
    Datatype_VEC_CHAR = 18
    Datatype_VEC_SHORT = 19
    Datatype_VEC_INT = 20
    Datatype_VEC_LONG = 21
    Datatype_VEC_LONGLONG = 22
    Datatype_VEC_UCHAR = 23
    Datatype_VEC_USHORT = 24
    Datatype_VEC_UINT = 25
    Datatype_VEC_ULONG = 26
    Datatype_VEC_ULONGLONG = 27
    Datatype_VEC_FLOAT = 28
    Datatype_VEC_DOUBLE = 29
    Datatype_VEC_LONG_DOUBLE = 30
    Datatype_VEC_CFLOAT = 31
    Datatype_VEC_CDOUBLE = 32
    Datatype_VEC_CLONG_DOUBLE = 33
    Datatype_VEC_SCHAR = 34
    Datatype_VEC_STRING = 35
    Datatype_ARR_DBL_7 = 36
    Datatype_BOOL = 37
    Datatype_UNDEFINED = 38
end

const datatypes = Type[Cchar, Cuchar, Cchar,
                       Cshort, Cint, Clong, Clonglong,
                       Cushort, Cuint, Culong, Culonglong,
                       Cfloat, Cdouble,
                       Complex{Cfloat}, Complex{Cdouble},
                       AbstractString,
                       AbstractVector{Cchar}, AbstractVector{Cuchar}, AbstractVector{Cchar},
                       AbstractVector{Cshort}, AbstractVector{Cint}, AbstractVector{Clong}, AbstractVector{Clonglong},
                       AbstractVector{Cushort}, AbstractVector{Cuint}, AbstractVector{Culong}, AbstractVector{Culonglong},
                       AbstractVector{Cfloat}, AbstractVector{Cdouble},
                       AbstractVector{Complex{Cfloat}}, AbstractVector{Complex{Cdouble}},
                       AbstractVector{<:AbstractString},
                       Bool]
const Datatypes = Union{datatypes...}

# Clong is the same as either Cint or Clonglong, similarly for Culong
openpmd_datatype(::Type{Cchar}) = Datatype_SCHAR
openpmd_datatype(::Type{Cuchar}) = Datatype_UCHAR
openpmd_datatype(::Type{Cshort}) = Datatype_SHORT
openpmd_datatype(::Type{Cint}) = Datatype_INT
openpmd_datatype(::Type{Clonglong}) = Datatype_LONGLONG
openpmd_datatype(::Type{Cushort}) = Datatype_USHORT
openpmd_datatype(::Type{Cuint}) = Datatype_UINT
openpmd_datatype(::Type{Culonglong}) = Datatype_ULONGLONG
openpmd_datatype(::Type{Cfloat}) = Datatype_FLOAT
openpmd_datatype(::Type{Cdouble}) = Datatype_DOUBLE
openpmd_datatype(::Type{Complex{Cfloat}}) = Datatype_CFLOAT
openpmd_datatype(::Type{Complex{Cdouble}}) = Datatype_CDOUBLE
openpmd_datatype(::Type{<:AbstractString}) = Datatype_STRING
openpmd_datatype(::Type{<:AbstractVector{Cchar}}) = Datatype_VEC_SCHAR
openpmd_datatype(::Type{<:AbstractVector{Cuchar}}) = Datatype_VEC_UCHAR
openpmd_datatype(::Type{<:AbstractVector{Cshort}}) = Datatype_VEC_SHORT
openpmd_datatype(::Type{<:AbstractVector{Cint}}) = Datatype_VEC_INT
openpmd_datatype(::Type{<:AbstractVector{Clonglong}}) = Datatype_VEC_LONGLONG
openpmd_datatype(::Type{<:AbstractVector{Cushort}}) = Datatype_VEC_USHORT
openpmd_datatype(::Type{<:AbstractVector{Cuint}}) = Datatype_VEC_UINT
openpmd_datatype(::Type{<:AbstractVector{Culonglong}}) = Datatype_VEC_ULONGLONG
openpmd_datatype(::Type{<:AbstractVector{Cfloat}}) = Datatype_VEC_FLOAT
openpmd_datatype(::Type{<:AbstractVector{Cdouble}}) = Datatype_VEC_DOUBLE
openpmd_datatype(::Type{<:AbstractVector{Complex{Cfloat}}}) = Datatype_VEC_CFLOAT
openpmd_datatype(::Type{<:AbstractVector{Complex{Cdouble}}}) = Datatype_VEC_CDOUBLE
openpmd_datatype(::Type{<:AbstractVector{<:AbstractString}}) = Datatype_VEC_STRING
openpmd_datatype(::Type{Bool}) = Datatype_BOOL
# openpmd_datatype(::Type) = Datatype_UNDEFINED
openpmd_datatype(::T) where {T<:Datatypes} = datatype(T)

const julia_types = Dict{Datatype,Type}(Datatype_CHAR => Cchar,
                                        Datatype_SCHAR => Cchar,
                                        Datatype_UCHAR => Cuchar,
                                        Datatype_SHORT => Cshort,
                                        Datatype_INT => Cint,
                                        Datatype_LONG => Clong,
                                        Datatype_LONGLONG => Clonglong,
                                        Datatype_USHORT => Cushort,
                                        Datatype_UINT => Cuint,
                                        Datatype_ULONG => Culong,
                                        Datatype_ULONGLONG => Culonglong,
                                        Datatype_FLOAT => Cfloat,
                                        Datatype_DOUBLE => Cdouble,
                                        Datatype_CFLOAT => Complex{Cfloat},
                                        Datatype_CDOUBLE => Complex{Cdouble},
                                        Datatype_STRING => AbstractString,
                                        Datatype_VEC_CHAR => AbstractVector{Cchar},
                                        Datatype_VEC_SCHAR => AbstractVector{Cchar},
                                        Datatype_VEC_UCHAR => AbstractVector{Cuchar},
                                        Datatype_VEC_SHORT => AbstractVector{Cshort},
                                        Datatype_VEC_INT => AbstractVector{Cint},
                                        Datatype_VEC_LONG => AbstractVector{Clong},
                                        Datatype_VEC_LONGLONG => AbstractVector{Clonglong},
                                        Datatype_VEC_USHORT => AbstractVector{Cushort},
                                        Datatype_VEC_UINT => AbstractVector{Cuint},
                                        Datatype_VEC_ULONG => AbstractVector{Culong},
                                        Datatype_VEC_ULONGLONG => AbstractVector{Culonglong},
                                        Datatype_VEC_FLOAT => AbstractVector{Cfloat},
                                        Datatype_VEC_DOUBLE => AbstractVector{Cdouble},
                                        Datatype_VEC_CFLOAT => AbstractVector{Complex{Cfloat}},
                                        Datatype_VEC_CDOUBLE => AbstractVector{Complex{Cdouble}},
                                        Datatype_VEC_STRING => AbstractVector{AbstractString},
                                        Datatype_BOOL => Bool)

# size_t openPMD_toBytes(openPMD_Datatype datatype);
# size_t openPMD_toBits(openPMD_Datatype datatype);
# bool openPMD_isVector(openPMD_Datatype datatype);
# bool openPMD_isFloatingPoint(openPMD_Datatype datatype);
# bool openPMD_isComplexFloatingPoint(openPMD_Datatype datatype);
# bool openPMD_isInteger(openPMD_Datatype datatype);
# bool openPMD_isSigned(openPMD_Datatype datatype);
# bool openPMD_isChar(openPMD_Datatype datatype);
# bool openPMD_isSame(openPMD_Datatype datatype1, openPMD_Datatype datatype2);
# openPMD_Datatype openPMD_basicDatatype(openPMD_Datatype datatype);
# openPMD_Datatype openPMD_toVectorType(openPMD_Datatype datatype);
# const char *openPMD_datatypeToString(openPMD_Datatype datatype);
# openPMD_Datatype openPMD_stringToDatatype(const char *string);

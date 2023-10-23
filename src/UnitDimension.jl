"""
    @enum UnitDimension begin
        UnitDimension_L
        UnitDimension_M
        UnitDimension_T
        UnitDimension_I
        UnitDimension_θ
        UnitDimension_N
        UnitDimension_J
    end

- `L`: length (metre)
- `M`: mass (kilogram)
- `T`: time (second)
- `I`: electric current (ampere)
- `θ` ("theta"): thermodynamic temperature (kelvin)
- `N`: amount of substance (mole)
- `J`: luminous intensity (candela)
"""
@enum UnitDimension begin
    UnitDimension_L = 0
    UnitDimension_M = 1
    UnitDimension_T = 2
    UnitDimension_I = 3
    UnitDimension_θ = 4
    UnitDimension_N = 5
    UnitDimension_J = 6
end
export UnitDimension, UnitDimension_L, UnitDimension_M, UnitDimension_T, UnitDimension_I, UnitDimension_θ, UnitDimension_N,
       UnitDimension_J

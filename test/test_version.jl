@testset "version" begin
    version = openPMD2.getVersion()
    @test version isa String
    @test length(version) > 0

    standard = openPMD2.getStandard()
    @test standard isa String
    @test length(standard) > 0

    standard_minimum = openPMD2.getStandardMinimum()
    @test standard_minimum isa String
    @test length(standard_minimum) > 0

    variants = openPMD2.getVariants()
    @test variants isa Dict{AbstractString,Bool}
    @test "json" in keys(variants)
    @test "mpi" in keys(variants)
    @test "toml" in keys(variants)
    @test variants["json"]
    @test variants["mpi"]
    @test variants["toml"]

    file_extensions = openPMD2.getFileExtensions()
    @test file_extensions isa Set{<:AbstractString}
    @test "bp" in file_extensions
    @test "h5" in file_extensions
    @test "json" in file_extensions
    @test "toml" in file_extensions
end

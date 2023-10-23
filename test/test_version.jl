@testset "version" begin
    version = openPMD_get_version()
    @test version isa String
    @test length(version) > 0

    standard = openPMD_get_standard()
    @test standard isa String
    @test length(standard) > 0

    standard_minimum = openPMD_get_standard_minimum()
    @test standard_minimum isa String
    @test length(standard_minimum) > 0

    variants = openPMD_get_variants()
    @test variants isa AbstractDict{<:AbstractString,Bool}
    @test "json" in keys(variants)
    @test "mpi" in keys(variants)
    @test "toml" in keys(variants)
    @test variants["json"]
    @test variants["mpi"]
    @test variants["toml"]

    file_extensions = openPMD_get_file_extensions()
    @test file_extensions isa AbstractSet{<:AbstractString}
    @test "bp" in file_extensions
    @test "h5" in file_extensions
    @test "json" in file_extensions
    @test "toml" in file_extensions
end

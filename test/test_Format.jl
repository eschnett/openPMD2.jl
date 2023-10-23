@testset "Format" begin
    @test Format isa Type

    format = determine_format("file.h5")
    @test format === Format_HDF5

    format = determine_format("file.bp")
    @test format === Format_ADIOS2_BP

    format = determine_format("file.bp4")
    @test format === Format_ADIOS2_BP4

    format = determine_format("file.bp5")
    @test format === Format_ADIOS2_BP5

    format = determine_format("file.json")
    @test format === Format_JSON

    format = determine_format("file.toml")
    @test format === Format_TOML

    for format in instances(Format)
        suf = suffix(format)
        @test suf isa String
        if format === Format_DUMMY
            @test isempty(suf)
        else
            @test startswith(suf, ".")
            @test length(suf) > 1

            format′ = determine_format("file$suf")
            @test format′ === format
            suf′ = suffix(format′)
            @test suf′ == suf
        end
    end
end

@testset "Format" begin
    @test openPMD2.Format isa Type

    format = openPMD2.determineFormat("file.h5")
    @test format == openPMD2.Format_HDF5

    format = openPMD2.determineFormat("file.bp")
    @test format == openPMD2.Format_ADIOS2_BP

    format = openPMD2.determineFormat("file.bp4")
    @test format == openPMD2.Format_ADIOS2_BP4

    format = openPMD2.determineFormat("file.bp5")
    @test format == openPMD2.Format_ADIOS2_BP5

    format = openPMD2.determineFormat("file.json")
    @test format == openPMD2.Format_JSON

    format = openPMD2.determineFormat("file.toml")
    @test format == openPMD2.Format_TOML

    for format in instances(openPMD2.Format)
        suffix = openPMD2.suffix(format)
        @test suffix isa String
        @test length(suffix) > 0
    end
end

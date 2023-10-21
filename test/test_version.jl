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
end

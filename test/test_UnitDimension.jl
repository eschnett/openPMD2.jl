@testset "UnitDimension" begin
    @test UnitDimension isa Type

    @test length(instances(UnitDimension)) == 7
end

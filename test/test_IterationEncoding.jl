@testset "IterationEncoding" begin
    @test IterationEncoding isa Type

    @test length(instances(IterationEncoding)) == 3
end

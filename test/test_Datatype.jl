@testset "Datatype" begin
    @test openPMD2.datatypes isa AbstractVector{<:Type}
    @test openPMD2.Datatype isa Type
end

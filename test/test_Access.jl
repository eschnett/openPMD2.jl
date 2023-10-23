@testset "Access" begin
    @test Access isa Type

    ro = Access_READ_ONLY
    ra = Access_READ_RANDOM_ACCESS
    rl = Access_READ_LINEAR
    rw = Access_READ_WRITE
    cr = Access_CREATE
    ap = Access_APPEND

    @test ro isa Access
    @test ra isa Access
    @test rl isa Access
    @test rw isa Access
    @test cr isa Access
    @test ap isa Access

    @test isreadonly(ro)
    @test isreadonly(ra)
    @test isreadonly(rl)
    @test !isreadonly(rw)
    @test !isreadonly(cr)
    @test !isreadonly(ap)

    @test isreadable(ro)
    @test isreadable(ra)
    @test isreadable(rl)
    @test isreadable(rw)
    @test !isreadable(cr)
    @test !isreadable(ap)

    @test !iswriteonly(ro)
    @test !iswriteonly(ra)
    @test !iswriteonly(rl)
    @test !iswriteonly(rw)
    @test iswriteonly(cr)
    @test iswriteonly(ap)

    @test !iswritable(ro)
    @test !iswritable(ra)
    @test !iswritable(rl)
    @test iswritable(rw)
    @test iswritable(cr)
    @test iswritable(ap)
end

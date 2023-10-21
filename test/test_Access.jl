@testset "Access" begin
    @test openPMD2.Access isa Type

    ro = openPMD2.Access_READ_ONLY
    ra = openPMD2.Access_READ_RANDOM_ACCESS
    rl = openPMD2.Access_READ_LINEAR
    rw = openPMD2.Access_READ_WRITE
    cr = openPMD2.Access_CREATE
    ap = openPMD2.Access_APPEND

    @test ro isa openPMD2.Access
    @test ra isa openPMD2.Access
    @test rl isa openPMD2.Access
    @test rw isa openPMD2.Access
    @test cr isa openPMD2.Access
    @test ap isa openPMD2.Access

    @test openPMD2.Access_readOnly(ro)
    @test openPMD2.Access_readOnly(ra)
    @test openPMD2.Access_readOnly(rl)
    @test !openPMD2.Access_readOnly(rw)
    @test !openPMD2.Access_readOnly(cr)
    @test !openPMD2.Access_readOnly(ap)

    @test openPMD2.Access_read(ro)
    @test openPMD2.Access_read(ra)
    @test openPMD2.Access_read(rl)
    @test openPMD2.Access_read(rw)
    @test !openPMD2.Access_read(cr)
    @test !openPMD2.Access_read(ap)

    @test !openPMD2.Access_writeOnly(ro)
    @test !openPMD2.Access_writeOnly(ra)
    @test !openPMD2.Access_writeOnly(rl)
    @test !openPMD2.Access_writeOnly(rw)
    @test openPMD2.Access_writeOnly(cr)
    @test openPMD2.Access_writeOnly(ap)

    @test !openPMD2.Access_write(ro)
    @test !openPMD2.Access_write(ra)
    @test !openPMD2.Access_write(rl)
    @test openPMD2.Access_write(rw)
    @test openPMD2.Access_write(cr)
    @test openPMD2.Access_write(ap)
end

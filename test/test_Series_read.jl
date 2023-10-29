@testset "Series" begin
    series = Series(filename, Access_READ_ONLY)
    @test isvalid(series)

    @test "hello" in keys(attributes(series))
    @test attributes(series)["hello"] === Cint(42)

    openPMD_version = get_openPMD_version(series)
    @test openPMD_version isa AbstractString
    @test !isempty(openPMD_version)

    openPMD_extension = get_openPMD_extension(series)
    @test openPMD_extension isa Unsigned

    base_path = get_base_path(series)
    @test base_path isa AbstractString
    @test !isempty(base_path)

    meshes_path = get_meshes_path(series)
    @test meshes_path isa AbstractString
    @test !isempty(meshes_path)
    @test meshes_path == "meshes/"

    particles_path = get_particles_path(series)
    @test particles_path isa AbstractString
    @test !isempty(particles_path)
    @test get_particles_path(series) == "particles/"

    @test get_author(series) == "Anton Notenquetscher"

    software = get_software(series)
    @test !isempty(software)
    software_version = attributes(series)["softwareVersion"]
    @test !isempty(software_version)

    date = get_date(series)
    @test !isempty(date)

    software_dependencies = get_software_dependencies(series)
    @test !isempty(software_dependencies)
    @test software_dependencies == """{"ADIOS2","HDF5"}"""

    machine = get_machine(series)
    @test !isempty(machine)
    @test machine == gethostname()

    iteration_encoding = get_iteration_encoding(series)
    @test iteration_encoding isa IterationEncoding
    @test iteration_encoding in [IterationEncoding_fileBased, IterationEncoding_groupBased, IterationEncoding_variableBased]

    iteration_format = get_iteration_format(series)
    @test !isempty(iteration_format)

    name = get_name(series)
    @test !isempty(name)
    @test name == "hello"

    backend = get_backend(series)
    @test !isempty(backend)
    @test backend == "JSON"

    # Read serially
    read_iters = read_iterations(series)
    #TODO iter = read_iters[]
    #TODO
    #TODO @test !isclosed(iter)
    #TODO 
    #TODO get_time(iter)
    #TODO get_dt(iter)
    #TODO get_time_unit_SI(iter)
    #TODO 
    #TODO close(iter)
    #TODO @test isclosed(iter)

    # Read with random access
    iters = iterations(series)
    iter = iters[0]

    @test !isclosed(iter)

    get_time(iter)
    get_dt(iter)
    get_time_unit_SI(iter)

    @test attributes(iter)["ship"] === 43

    close(iter)
    @test isclosed(iter)

    close(series)
end

GC.gc()

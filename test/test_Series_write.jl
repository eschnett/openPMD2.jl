@testset "Series" begin
    let
        series = Series()
        @test !isvalid(series)
    end

    series = Series(filename, Access_CREATE)
    @test isvalid(series)

    @test attributes(series) isa Attributes
    @test keys(attributes(series)) isa AttributeKeys
    @test length(keys(attributes(series))) == length(attributes(series))
    @test length(collect(keys(attributes(series)))) == length(keys(attributes(series)))

    attributes(series)["hello"] = Cint(42)
    @test "hello" in keys(attributes(series))
    @test attributes(series)["hello"] === Cint(42)

    openPMD_version = get_openPMD_version(series)
    @test openPMD_version isa AbstractString
    @test !isempty(openPMD_version)
    set_openPMD_version!(series, openPMD_version)

    openPMD_extension = get_openPMD_extension(series)
    @test openPMD_extension isa Unsigned
    set_openPMD_extension!(series, openPMD_extension)

    base_path = get_base_path(series)
    @test base_path isa AbstractString
    @test !isempty(base_path)
    @test_throws ErrorException set_base_path!(series, base_path)

    if "meshesPath" in keys(attributes(series))
        meshes_path = get_meshes_path(series)
    else
        meshes_path = "meshes"
    end
    @test meshes_path isa AbstractString
    @test !isempty(meshes_path)
    set_meshes_path!(series, meshes_path)
    @test get_meshes_path(series) == "meshes/"

    if "particlesPath" in keys(attributes(series))
        particles_path = get_particles_path(series)
    else
        particles_path = "particles"
    end
    @test particles_path isa AbstractString
    @test !isempty(particles_path)
    set_particles_path!(series, particles_path)
    @test get_particles_path(series) == "particles/"

    @test !("author" in keys(attributes(series)))
    set_author!(series, "Anton Notenquetscher")
    @test "author" in keys(attributes(series))
    @test get_author(series) == "Anton Notenquetscher"

    software = get_software(series)
    @test !isempty(software)
    software_version = attributes(series)["softwareVersion"]
    @test !isempty(software_version)
    set_software!(series, software, software_version)

    date = get_date(series)
    @test !isempty(date)
    set_date!(series, date)

    if "softwareDependencies" in keys(attributes(series))
        software_dependencies = get_software_dependencies(series)
    else
        software_dependencies = """{"ADIOS2","HDF5"}"""
    end
    @test !isempty(software_dependencies)
    set_software_dependencies!(series, software_dependencies)
    @test get_software_dependencies(series) == software_dependencies

    if "machine" in keys(attributes(series))
        machine = get_machine(series)
    else
        machine = gethostname()
    end
    @test !isempty(machine)
    set_machine!(series, machine)
    @test get_machine(series) == machine

    iteration_encoding = get_iteration_encoding(series)
    @test iteration_encoding isa IterationEncoding
    @test iteration_encoding in [IterationEncoding_fileBased, IterationEncoding_groupBased, IterationEncoding_variableBased]
    set_iteration_encoding!(series, iteration_encoding)

    iteration_format = get_iteration_format(series)
    @test !isempty(iteration_format)
    set_iteration_format!(series, iteration_format)

    if "name" in keys(attributes(series))
        name = get_name(series)
    else
        name = "hello"
    end
    @test !isempty(name)
    set_name!(series, name)
    @test get_name(series) == name

    backend = get_backend(series)
    @test !isempty(backend)
    @test backend == "JSON"

    flush(series)

    parse_base(series)

    write_iters = write_iterations(series)
    iter = write_iters[0]

    curr = current_iteration(write_iters)

    @test !isclosed(iter)

    @test get_time(iter) == 0
    @test get_dt(iter) == 1
    @test get_time_unit_SI(iter) == 1
    set_time!(iter, 10)
    set_dt!(iter, 1)
    set_time_unit_SI!(iter, 1476.6250614046494)
    @test get_time(iter) == 10
    @test get_dt(iter) == 1
    @test get_time_unit_SI(iter) == 1476.6250614046494

    attributes(iter)["ship"] = 43
    @test attributes(iter)["ship"] === 43

    close(iter)
    @test isclosed(iter)

    close(series)
end

GC.gc()

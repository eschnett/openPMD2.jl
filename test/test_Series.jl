@testset "Series" begin
    let
        series = Series()
        @test !isvalid(series)
    end

    # tmpdir = Filesystem.mktempdir(; cleanup=true)
    tmpdir = "/tmp"
    filename = joinpath(tmpdir, "hello.json")

    series = Series(filename, Access_CREATE)
    @test isvalid(series)

    series["hello"] = Cint(42)
    @test "hello" in series
    @test series["hello"] === Cint(42)

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

    if "meshesPath" in series
        meshes_path = get_meshes_path(series)
    else
        meshes_path = "meshes"
    end
    @test meshes_path isa AbstractString
    @test !isempty(meshes_path)
    set_meshes_path!(series, meshes_path)
    @test get_meshes_path(series) == "meshes/"

    if "particlesPath" in series
        particles_path = get_particles_path(series)
    else
        particles_path = "particles"
    end
    @test particles_path isa AbstractString
    @test !isempty(particles_path)
    set_particles_path!(series, particles_path)
    @test get_particles_path(series) == "particles/"

    @test !("author" in series)
    set_author!(series, "Anton Notenquetscher")
    @test "author" in series
    @test get_author(series) == "Anton Notenquetscher"

    software = get_software(series)
    @test !isempty(software)
    software_version = series["softwareVersion"]
    @test !isempty(software_version)
    set_software!(series, software, software_version)

    date = get_date(series)
    @test !isempty(date)
    set_date!(series, date)

    if "softwareDependencies" in series
        software_dependencies = get_software_dependencies(series)
    else
        software_dependencies = """{"ADIOS2","HDF5"}"""
    end
    @test !isempty(software_dependencies)
    set_software_dependencies!(series, software_dependencies)
    @test get_software_dependencies(series) == software_dependencies

    if "machine" in series
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

    if "name" in series
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

    close(series)
end

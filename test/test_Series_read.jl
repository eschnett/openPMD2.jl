@testset "Series" begin
    series = Series(filename, Access_READ_ONLY)
    @test isvalid(series)

    # Test attributes
    for T in [Int8, Int16, Int32, Int64,
              UInt8, UInt16, UInt32, UInt64,
              Float32, Float64,
              Complex{Float32}, Complex{Float64},
              String,
              Vector{Int8}, Vector{Int16}, Vector{Int32}, Vector{Int64},
              Vector{UInt8}, Vector{UInt16}, Vector{UInt32}, Vector{UInt64},
              Vector{Float32}, Vector{Float64},
              Vector{Complex{Float32}}, Vector{Complex{Float64}},
              Vector{String},
              Bool]
        if T <: Bool
            value = true
        elseif T <: Union{Integer,Real,Complex}
            value = T(42)
        elseif T <: String
            value = "42"
        elseif T <: Vector{<:Union{Integer,Real,Complex}}
            value = eltype(T)[10, 11, 13]
        elseif T <: Vector{String}
            value = eltype(T)["hello", "world", "∇Δ☐√π"]
        else
            @assert false
        end
        @test "hello-$T" in keys(attributes(series))
        if T <: Union{AbstractString,AbstractVector}
            @test attributes(series)["hello-$T"] == value
        else
            @test attributes(series)["hello-$T"] === value
        end
    end

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

    # Streaming read
    read_iters = read_iterations(series)

    # TODO: Implement this

    # Random access read
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

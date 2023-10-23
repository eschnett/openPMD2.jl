# Generate documentation with this command:
# (cd docs && julia make.jl)

push!(LOAD_PATH, "..")

using Documenter
using openPMD2

makedocs(; sitename="openPMD2", format=Documenter.HTML(), modules=[openPMD2])

deploydocs(; repo="github.com/eschnett/openPMD2.jl.git", devbranch="main", push_preview=true)

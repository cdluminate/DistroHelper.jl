#!/usr/bin/julia
push!(LOAD_PATH, dirname(@__FILE__))

using DistroHelper
using Pkg

function Usage(argv)
	println("dh_julia -- DistroHelper.jl command line interface")
end

function main(argv)
	if length(argv) == 0
		Usage(argv)
		exit(0)
	elseif argv[1] in ("slug", "depends")  # raw print
		print(getfield(DistroHelper, Symbol(argv[1]))(argv[2:end]...))
	elseif argv[1] in ("gather_stdlib_manifest", )  # requires pretty print
		result = getfield(DistroHelper, Symbol(argv[1]))(argv[2:end]...)
		Pkg.TOML.print(result)
	elseif argv[1] in ("distro_project",)  # no print
		getfield(DistroHelper, Symbol(argv[1]))(argv[2:end]...)
	else
		throw(Base.error("unsupported args"))
	end
end

main(ARGS)

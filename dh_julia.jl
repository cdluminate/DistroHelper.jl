#!/usr/bin/julia
push!(LOAD_PATH, dirname(@__FILE__))

using DistroHelper

function Usage(argv)
	println("dh_julia -- DistroHelper.jl command line interface")
	println("./dh_julia.jl slug data/Package.toml data/Versions.toml")
	println("./dh_julia.jl slug data/Package.toml data/Versions.toml 0.20.0")
end

function main(argv)
	if length(argv) == 0
		Usage(argv)
		exit(0)
	elseif argv[1] in ("slug", "depends")
		print(getfield(DistroHelper, Symbol(argv[1]))(argv[2:end]...))
	else
		throw(Base.error("unsupported args"))
	end
end

main(ARGS)

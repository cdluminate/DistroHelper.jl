"""
Copyright (C) 2019 Mo Zhou <lumin@debian.org>
MIT/Expat license.
"""
module DistroHelper

using Pkg

"""
Return the slug string for the given package in specific version.
The latest version will be used when version is omitted.

```
slug("Package.toml", "Versions.toml", "0.20.0")
slug("Package.toml", "Versions.toml")
```
"""
function slug(package::AbstractString, versions::AbstractString, version::Any = nothing)
	if !any(map(isfile, (package, versions)))
		uuid = Base.UUID(package)
		sha1 = Base.SHA1(hex2bytes(versions))
	else
		Package  = Pkg.TOML.parsefile(package)
		Versions = Pkg.TOML.parsefile(versions)
		latest_ver = maximum(VersionNumber.(keys(Versions)))
		version = string((version == nothing) ? latest_ver : version)
		uuid = Base.UUID(Package["uuid"])
		sha1 = Base.SHA1(hex2bytes(Versions[version]["git-tree-sha1"]))
	end
	return Base.version_slug(uuid,sha1)
end



"""
Return the dependencies for a specific version

```
depends("Deps.toml", "0.20.0")
depends("Deps.toml")
```
"""
function depends(deps::AbstractString, version::Any = nothing)
	alldeps = Pkg.TOML.parsefile(deps)
	bounds = map(x -> VersionNumber.(x), split.(keys(alldeps), "-"))
	ver	= (version == nothing) ? maximum(maximum(bounds)) : VersionNumber(version) 
	mask = [ver >= x[1] && ver <= x[2] for x in bounds]
	realdeps = Dict{String,Any}()
	for (k, v) in zip(mask, values(alldeps))
		if k for (i, j) in v realdeps[i] = j end end
	end
	return realdeps
end


"""
Gather manifest for stdlib
"""
function gather_stdlib_manifest()
	p = "/usr/share/julia/stdlib/v1.0"
	stdlibs = values(Pkg.Types.gather_stdlib_uuids())
	manifest = Dict{String,Any}()
	for lib in stdlibs
		d = Dict{String,Any}()
		project = Pkg.TOML.parsefile(joinpath(p, lib, "Project.toml"))
		name, uuid = project["name"], project["uuid"]
		d["uuid"] = uuid
		if haskey(project, "deps")
			d["deps"] = sort(string.(keys(project["deps"])))
		end
		manifest[name] = [d]
	end
	#Pkg.TOML.print(manifest)
	return manifest
end


"""
Generate Project.toml based on the given METADATA/Registry files.
Output will be written to pwd if dest is not specified.
"""
function distro_project(package::AbstractString, dest::Any = nothing)
	package = Pkg.TOML.parsefile(package)
	name, uuid = package["name"], package["uuid"]
	project = Dict{String,Any}()
	deps = Dict{String,Any}()
	deps[name] = uuid
	project["deps"] = deps
	open((dest==nothing) ? "dh_Project.toml" : dest, "w") do io
		Pkg.TOML.print(io, project)
	end
end


"""
Generate Manifest.toml entry for a specific package
"""
function distro_manifest_(package::AbstractString, versions::AbstractString, deps::AbstractString)
	d = Dict{String,Any}()
	package = Pkg.TOML.parsefile(package)
	versions = Pkg.TOML.parsefile(versions)
	latest_ver = string(maximum(VersionNumber.(keys(versions))))
	deps = depends(deps, latest_ver)  # XXX: version?
	d["deps"] = sort(collect(keys(deps)))
	d["git-tree-sha1"] = versions[latest_ver]["git-tree-sha1"]
	d["uuid"] = package["uuid"]
	d["version"] = latest_ver
	manifest = Dict{String,Any}()
	manifest[package["name"]] = [d]
	return manifest
end


"""
Generate Manifest.toml based on the given METADATA
FIXME: WIP
"""
function distro_manifest(package::AbstractString, versions::AbstractString, deps::AbstractString, dest::Any=nothing)
	manifest = gather_stdlib_manifest()
	merge!(manifest, distro_manifest_(package, versions, deps))
	open((dest==nothing) ? "dh_Manifest.toml" : dest, "w") do io
		Pkg.TOML.print(io, manifest)
	end
end


"""
Merge different Project.toml and Manifest.toml files
"""
function distro_merge(p::AbstractString, dest::Any=nothing)
	packages = filter(x -> isdir(joinpath(p, x)), readdir(p))
	println("Found $(length(packages)) packages: $packages")
	env = nothing
	for package in packages
		e = Pkg.Types.EnvCache(joinpath(p, package, "Project.toml"))
		if nothing == env
			env = e
		else
			merge!(env.project["deps"], e.project["deps"])
			merge!(env.manifest, e.manifest)
		end
	end
	mkpath(dest)
	open(joinpath(nothing==dest ? "." : dest, "Project.toml"), "w") do io
		Pkg.TOML.print(io, env.project)
	end
	open(joinpath(nothing==dest ? "." : dest, "Manifest.toml"), "w") do io
		Pkg.TOML.print(io, env.manifest)
	end
	#Pkg.Types.write_env(Pkg.Types.Context(env=env))
end

end # module

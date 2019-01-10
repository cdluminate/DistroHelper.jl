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
	Package  = Pkg.TOML.parsefile(package)
	Versions = Pkg.TOML.parsefile(versions)
	latest_ver = maximum(VersionNumber.(keys(Versions)))
	version = string((version == nothing) ? latest_ver : version)
	uuid = Base.UUID(Package["uuid"])
	sha1 = Base.SHA1(hex2bytes(Versions[version]["git-tree-sha1"]))
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
Output will be written to pwd.
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

end # module

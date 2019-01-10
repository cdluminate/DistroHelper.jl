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
	version = (version == nothing) ? latest_ver : version
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
	for (k, v) in zip(mask, values(alldeps))
		if k for (i,j) in v println(i, " = ", repr(j)) end end
	end
end

end # module

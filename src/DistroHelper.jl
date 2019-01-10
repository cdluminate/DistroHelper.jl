module DistroHelper

using Pkg

"""
Return the slug string for the given package in specific version.

```
slug("Package.toml", "Versions.toml", "0.20.0")
```
"""
function slug(package::AbstractString, versions::AbstractString, version::AbstractString)
	Package  = Pkg.TOML.parsefile(package)
	Versions = Pkg.TOML.parsefile(versions)
	uuid = Base.UUID(Package["uuid"])
	sha1 = Base.SHA1(hex2bytes(Versions[version]["git-tree-sha1"]))
	return Base.version_slug(uuid,sha1)
end

"""
Return the slug string for the latest version of the given package.

```
slug("Package.toml", "Versions.toml")
```
"""
function slug(package::AbstractString, versions::AbstractString)
	vers = Pkg.TOML.parsefile(versions)
	latest_ver = maximum(VersionNumber.(keys(vers)))
	return slug(package, versions, string(latest_ver))
end

end # module

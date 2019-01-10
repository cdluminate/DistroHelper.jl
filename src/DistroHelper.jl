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

end # module

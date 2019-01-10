DistroHelper.jl
===

Distribution helper snippets.

## CLI example

```
./dh_julia.jl slug data/Package.toml data/Versions.toml
./dh_julia.jl slug data/Package.toml data/Versions.toml 0.20.0

```

## API List

```
12:function slug(package::AbstractString, versions::AbstractString, version::AbstractString)
27:function slug(package::AbstractString, versions::AbstractString)
```

### Reference

https://github.com/JuliaLang/julia/issues/30528

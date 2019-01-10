DistroHelper.jl
===

Distribution helper snippets.

## CLI example

```
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml 0.20.0
./dh_julia.jl depends data/JSON/Deps.toml
./dh_julia.jl depends data/JSON/Deps.toml 0.20.0
```

## API List

```
$ ripgrep function
```

### Reference

https://github.com/JuliaLang/julia/issues/30528

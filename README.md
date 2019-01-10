DistroHelper.jl
===

Distribution helper snippets (WIP and experimental). For documentation please
read code or read them in REPL's help mode.

## CLI examples

```
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml 0.20.0
./dh_julia.jl gather_stdlib_manifest
./dh_julia.jl distro_project data/JSON/Package.toml
./dh_julia.jl distro_project data/JSON/Package.toml custom_destination
./dh_julia.jl depends data/JSON/Deps.toml
./dh_julia.jl depends data/JSON/Deps.toml 0.20.0
./dh_julia.jl distro_manifest data/JSON/Package.toml data/JSON/Versions.toml data/JSON/Deps.toml
```

## API List

```
$ ripgrep function
```

### Reference

https://github.com/JuliaLang/julia/issues/30528

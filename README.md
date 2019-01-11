DistroHelper.jl
===

Distribution helper snippets (WIP and experimental). For documentation please
read code or read them in REPL's help mode. And please expect hacky code.

## CLI examples

```
./dh_julia.jl metadata UnicodePlots
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml
./dh_julia.jl slug data/JSON/Package.toml data/JSON/Versions.toml 0.20.0
./dh_julia.jl slug 682c06a0-de6a-54ab-a142-c8b1cf79cde6 1f7a25b53ec67f5e9422f1f551ee216503f4a0fa
./dh_julia.jl gather_stdlib_manifest
./dh_julia.jl distro_project data/JSON/Package.toml
./dh_julia.jl distro_project data/JSON/Package.toml custom_destination
./dh_julia.jl depends data/JSON/Deps.toml
./dh_julia.jl depends data/JSON/Deps.toml 0.20.0
./dh_julia.jl distro_manifest data/JSON/Package.toml data/JSON/Versions.toml data/JSON/Deps.toml
./dh_julia.jl distro_merge /usr/share/julia/__distrohelper__/ /usr/share/julia/environments/distro
```

## API List

```
$ ripgrep function
```

### Reference

https://github.com/JuliaLang/julia/issues/30528

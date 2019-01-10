using DistroHelper
using Test

@testset "slug" begin
	@test DistroHelper.slug("./data/JSON/Package.toml", "./data/JSON/Versions.toml", "0.20.0") == "ebvl3"
	@test DistroHelper.slug("./data/JSON/Package.toml", "./data/JSON/Versions.toml") == "ebvl3"
end

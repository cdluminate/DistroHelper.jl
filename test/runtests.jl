using DistroHelper
using Test

@testset "slug" begin
	@test DistroHelper.slug("./data/Package.toml", "./data/Versions.toml", "0.20.0") == "ebvl3"
	@test DistroHelper.slug("./data/Package.toml", "./data/Versions.toml") == "ebvl3"
end

using DistroHelper
using Test

@testset "slug" begin
	@test DistroHelper.slug("./data/Package.toml", "./data/Versions.toml", "0.20.0") == "ebvl3"
end

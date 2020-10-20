@testset "test_file.jl" begin
    @testset "load mat filter" begin
        fname=joinpath(amaroot,"data","AMAdataDisparity.jld2")
        filter=loadfilter(fname)
        @test 1 == 1
    end
    @testset "load mat stim" begin
        fname=joinpath(amaroot,"data","AMAdataDisparity.jld2")
        stim=loadstim(fname)
        @test 1 == 1
    end
end

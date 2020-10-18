module AMA
import Random 
import MAT 
import NLopt 
import StatsBase 
import FFTW 
import Zygote

    # low
    include("Util/Stim.jl")
    include("Util/Filter.jl")
    include("Util/Neuron.jl")
    # mid
    include("Util/Objective.jl")
    include("Util/Posterior.jl")
    # high
    include("ama.jl")
    include("opt.jl")
    include("file.jl")

    #export
end # module

module AMA
import Random 
import MAT 
import NLopt 
import StatsBase 
import FFTW 
import Zygote

    # inteface
    include("ama.jl")
    include("load.jl")
    include("opt.jl")

    # low level
    include("Util/Stim.jl")
    include("Util/Neuron.jl")
    include("Util/Filters.jl")
    include("Util/Posterior.jl")
    include("Util/Objective.jl")

    #export
end # module

module AMA
import Random 
import MAT 
import NLopt 
import StatsBase 
import FFTW 
import Zygote
import JLD2


    amaroot=normpath(joinpath(@__FILE__,"..",".."))
    export amaroot

    # low
    include("Util/Stim.jl")
    export Stim, plot_S
    include("Util/Filter.jl")
    include("Util/Neuron.jl")
    # mid
    include("Util/Objective.jl")
    include("Util/Posterior.jl")
    # high
    include("ama.jl")
    export AMAopt
    include("opt.jl")
    include("file.jl")
    export loadfilter, loadstim

    #export
end # module

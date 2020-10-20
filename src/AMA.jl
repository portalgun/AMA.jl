module AMA
import Random 
import MAT 
import NLopt 
import StatsBase 
import FFTW 
import FileIO
import Plots
import LinearAlgebra
using JLD2
using Zygote

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
    export AMAOpt
    include("opt.jl")
    include("file.jl")
    export loadfilter, loadstim

    #export
end # module

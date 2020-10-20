using FileIO
using MAT

abstract type AbstractFile end

struct MatFile <: AbstractFile
    path::String
end

struct JLD2File <: AbstractFile
    path::String
end


function parsefname(fname::String)

    if endswith(fname,".mat")
        f=MatFile(fname)
    elseif endswith(fname,".jld2")
        f=JLD2File(fname)
    end

    return f
end

# FILTER
function loadfilter(fname::JLD2File)::Filter
    vars=load(fname.path)
    filter=getfilter(vars)
    return filter
end
function loadfilter(fname::MatFile)::Filter
    vars=matread(fname.path)
    filter=getfilter(vars)
    return filter
end
function loadfilter(fname::String)::Filter
    f=parsefname(fname)
    if !isa(f, AbstractFile)
        error("Not valid file type")
    end
    filter=loadfilter(f)
    return filter
end
function getfilter(filter::Filter)::Filter
    return filter
end
#function getfilter(N::Neuron)::Filter
#    return  N.filter
#end
function getfilter(D::Dict)::Filter
    if haskey(D,"S") && !haskey(D,"f")
        D=D["S"]
    end
    f=D["f"]
    if haskey(D,"Nf")
        Nf=D["Nf"]
    elseif size(f,2) > 1
        Nf=size(f,2)
    end
    if haskey(D,"nPixX")
        nPixX=D["nPixX"]
    elseif size(f,2) > 1
        nPixX=size(f,1)
    end
    if isa(f,Array)
        filter=Filter(f)
    else
        filter=Filter(f,Nf,nPixX)
    end
    return filter
end

# STIM
function loadstim(fname::String)::Stim
    f=parsefname(fname)
    if !isa(f, AbstractFile)
        error("Not valid file type")
    end
    stim=loadstim(f)
    return stim
end
function loadstim(fname::MatFile)::Stim
    vars=matread(fname.path)
    stim=getstim(vars,fname)
    return stim
end
function loadstim(fname::JLD2File)::Stim
    vars=load(fname.path)
    stim=getstim(vars,fname)
    return stim
end
function getstim(D::Dict, fname::AbstractFile)
    if haskey(D,"S") && !haskey(D,"X")
        D=D["S"]
    end
    X=D["X"][1,:]
    ctgInd=D["ctgInd"][:,1]
    img=D["s"]

    if isa(ctgInd,Array)
        ctgInd=Vector{UInt8}(vec(ctgInd))
    end
    if isa(X,Array)
        X=Vector{Float32}(vec(X))
    end

    stim=Stim(fname.path,img,ctgInd,X)

    return stim
end


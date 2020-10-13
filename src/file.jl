module AMA
using MAT

abstract type File
end

struct MatFile <: File
    fname::String
end

function parsefname!(fname::String)::File
    if endswith(fname,".mat")
        fname=MatFile(fname)
    end
    return fname
end

# FILTER
function loadfilter(fname::String)
    parsefname!(fname)
    filter=loadfilter(fname)
    return filter
end
function loadfilter(fname::Matfile)
    vars=matread(fname)
    filter=getfilter(vars)
    return filter
end
function getfilter(filter::Filter)
    return filter
end
function getfilter(N::Neuron)
    return  N.filter
end
function getfilter(D::Dict)
    f=D['f']
    Nf=D['Nf']
    filter=Filter(f,Nf)
    return filter
end

# STIM
function loadstim(fname::String)
    parsefname!(fname)
    stim=loadstim(fname)
    return stim
end
function loadstim(fname::Matfile)
    vars=matread(fname)
    stim=getstim(vars,fname)
    return stim
end
function getstim(D::Dict,fname::String)
    X=Dict['X'][1,:]
    ctgInd=vars['ctgInd'][:,1]
    img=vars['s']

    stim=Stim(fname,img,ctgInd,X)

    return stim
end

end

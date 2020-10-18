struct ObjSpec
    errType::Int8
    bMean::Bool
end
ObjSpec(errType=2,bMean=0)=ObjSpec(errType,bMean)
function eval(neu::Neuron, stim::Stim, objSpec::ObjSpec, fs::FilterSpec, f::Vector, grad::Vector)
    if length(grad)>0
        grad=eval'(neu,stim,objSpec,fs,f)
    end
    cost=eval(neu,stim,objSpec,fs,f)
    return cost
end

function eval(neu::Neuron, stim::Stim, objSpec::ObjSpec, fs::FilterSpec, f::Vector)

    filter   = Filter(f, fs)

    resposne = respond(neu, stim)
    p        = postdist(response, stim, objSpec)
    cost     = cost(p)

    return cost
end


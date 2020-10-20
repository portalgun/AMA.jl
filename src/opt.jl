function setopt(optSpec::OptSpec, neu::Neuron, stim::Stim, objSpec::ObjSpec, fs::FilterSpec)
    opt=NLopt.Opt(:LD_SLSQP, stim.nPixAll) # TODO

    opt.min_objective = (x,g) -> eval(neu, stim, objSpec, fs, x, g)

    opt.xtol_rel=optSpec.xtolrel
    opt.xtol_abs=optSpec.xtolabs
    opt.xtol_rel=optSpec.ftolrel
    opt.xtol_abs=optSpec.ftolabs
    opt.maxeval=optSpec.maxeval
    opt.maxtime=optSpec.maxtime
    # opt.step=optSpec.step TODO
    opt.stopval=optSpec.stopval

    return opt
end

function setcons!(opt::NLopt.Opt,stim::Stim, conspec::ConSpec, fs::FilterSpec)
    if conspec.blb
        opt.lower_bounds=conspec.lb .* ones(stim.nPixAll)
    end
    if conspec.bub
        opt.upper_bounds= conspec.ub .* ones(stim.nPixAll)
    end

    f=(r,x,g) -> simplexcon(r, x, g, fs)
    #tol=repeat(collect(conspec.tol), fs.Nf)
    tol=conspec.tol
    NLopt.equality_constraint!(opt, f, tol)
end

function simplexcon(result::Vector, x::Vector, grad::Matrix, fs::FilterSpec)
    if grad.size > 0
        grad[:]=simplexcon'(x,fs)
    end
    result[:]=simplexcon(x,fs)
    return result
end

function simplexcon(x::Vector, fs::FilterSpec )
    vec=zeros(Float64,fs.Nf)
    for i = 1:fs.Nf
        f=x[fs.ind==i].^2
        vec[i]=LinearAlgebra.dot(f,f)
    end
    println(size(vec))
    return vec
end

function optimize!(opt::NLopt.Opt, fs::FilterSpec)
    filter=Filter(fs)
    (minf,minx,ret)=optimize!(opt, filter.f)

    numevals = opt.numevals # the number of function evaluations
    println("got $minf at $minx after $numevals iterations (returned $ret)")
    return opt
end

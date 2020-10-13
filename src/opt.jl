using NLopt
module AMA

    function setopt(optSpec::OptSpec,neu::Neuron)
        opt=Opt(:LD_MMA, neu.nPixAll)
        setcons!(opt,optSpec, neu)
        f(x,g)=full_eval(neu,stim,objSpec,fs,f,x,g)
        opt.min_opjective=f
        return opt
    end

    function setcons!(opt::Opt,optSpec::OptSpec,neu::Neuron)
        if optSpec.blb
            opt.lower_bounds=optOpt.lb .* ones(neu.nPixAll)
        end
        if optSpec.bub
            opt.upper_bounds= otpSpec.ub .* ones(neu.nPixAll)
        end
        opt.xtol_rel=optSpec.xtolrel
        opt.xtol_abs=optSpec.xtolabs
        opt.xtol_rel=optSpec.ftolrel
        opt.xtol_abs=optSpec.ftolabs
        add_equality_mconstraint()

        self.jac=jacfwd(lambda x: self.vec_mag_one_fun_core(x))
        inequality_constraint!(opt, (x,g) -> myconstraint(x,g,2,0), 1e-8)
    end

    function optimize!(opt::Opt, fs::FilterSpec)
        filter=Filter(fs)
        (minf,minx,ret)=optimize!(opt, filter.f)

        numevals = opt.numevals # the number of function evaluations
        println("got $minf at $minx after $numevals iterations (returned $ret)")
        return opt
    end

    function simplexcon(neu::Neuron,result,x::Vector,g::Vector)
        g=self.jac(x)
        if grad.size > 0:
            grad[:]=jac(x)
        return result
    end


    function simplexcon(neu::Neuron,result,x::Vector)
        vec=count(neu.filter_ind, wv=x.^2)
        return vec
    end
end

struct Posterior
    p::Float32
    y::Float32
    z::Float32

    errType::Int8
    Nlvl::Int8
    nStim::Int8
    X::Vector
    labels::Array
end
Posterior(p,y,z, opts, stim) = Posterior(p,y,z, opts.errType, stim.Nlvl, stim.nStim, stim.X, stim.labels)

    function postdist(response::Response,stim::Stim, opts::ObjSpec) ::Posterior
        # each stimulus response gets its own posterior distribution across categories
        # r    [Nlvl, Ni, Nf]
        # mean [Nlvl, Ni, Nf]
        #
        # single LPstm  [Nlvl]
        # PPstm         [Nlvl, Ni, NLvl]

        pStd=1 ./ prod(sqrt(response.var),dims=3)

        if opts.bMean==1
            r=response.mean
        else
            r=response.r
        end

        if opts.errType == 1
            # TODO only need at correct label
        else
            f = x -> numer(x,pStd,response.mean,response.var)
            y = f.(r) # for each response
        end

        z = repeat(sum(y,3),outer=[1,1, stim.Nlvl])
        p=y./z
        post=Posterior(p,y,z, opts, stim)

        return post
    end

    function numer(r::Array, pStd::Array, mean::Array, var::Array)
        # R [Nf]
        # mean [Nlvl, Ni, Nf]

        y=sum(pStd.*exp(-0.5.*sum( (r.-mean).^2 ./ var,2)),2)
        return y
    end

    function cost(post::Posterior)
        if post.errType==1
            cost=-log(post.p);
        elseif post.errType==2
            cost=( LinearAlgebra.dot(post.p, post.X)  - post.labels) .^2
        end
        cost = Statistics.mean(cost)
    end


# PLOTTING
    #function plot(post::Posterior)
    #    # TODO
    #end
    #function plotmean(post::Posterior)
    #    # TODO
    #    colors = plot.cm.rainbow(range(0, 1, post.Nlvl))
    #    for i in range(post.Nlvl)
    #        plot( sum( post.p[i,:,:], 2)/post.nStim, color=colors[i])
    #    end

    #    plot.show()
    #    return 0
    #end

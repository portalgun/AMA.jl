module AMA
    struct Posterior
        p::Float32
        y::Float32
        z::Float32

        errType::Int8
        Nlvl::Int8
        labels:: #XXX
        nStim::Int8
    end
    Posterior(p,y,z, opts, stim) = Posterior(p,y,z, opts.errType, stim.Nlvl, stim.labels, stim.nStim)

        function postdist(response::Response,stim::Stim, opts::ObjSpec) ::Posterior
            # each stimulus response gets its own posterior distribution across categories
            # r    [Nlvl, Ni, Nf]
            # mean [Nlvl, Ni, Nf]
            #
            # single LPstm  [Nlvl]
            # PPstm         [Nlvl, Ni, NLvl]

            pStd=1./prod(sqrt(response.var),dims=3)

            if errType == 1
                # XXX
            else
                y = get_numerator.(get_numerator(pStd, response, opts))
            end

            z = repeat(sum(y,3),outer=[1,1, Nlvl])
            p=y/z
            post=Posterior(p,y,z, opts, stim)

            return post
        end

        function numer(pStd, response::Response, opts::ObjSpec)
            # R [Nf]
            # r [Nlvl, Ni, Nf]
            # LPstm [Nlvl]

            if opts.bMean==1
                r=response.mean
            else
                r=response.r
            end

            y=sum(pStd.*exp(-0.5.*sum(square(r.-response.mean)./resposne.var,2)),2)
            return y
        end

        function cost(post::Posterior)
            if post.errType==1
                cost=-log(post.p);
            elseif post.errType==2
                cost=square( dot(P.PPstm, stim.X) - S.labels)
            end
            cost=mean(cost)
        end


# PLOTTING
        function plot(post::Posterior)
        end
        function plotmean(post::Posterior)
            # TODO
            colors = plot.cm.rainbow(linspace(0, 1, S.Nlvl))
            for i in range(S.Nlvl):
                plot( sum(post.p[i,:,:],2)/post.nStim, color=colors[i])
            end

            plot.show()
            return 0
        ende


end

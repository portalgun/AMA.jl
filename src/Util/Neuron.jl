struct Neuron
    rng::Random.AbstractRNG
    alpha::Float32
    s0::Float32
    Rmax::Float32
    bRectify::Bool
    normType::UInt8
    bNormF::Bool

    function Neuron(seed::Int, alpha::Float64, s0::Float64, Rmax::Float64, bRectify::Bool, normType::Int, bNormF::Bool)
        rng=Random.MersenneTwister(seed)
        new(rng,alpha,s0,Rmax,bRectify,normType,bNormF)
    end
end
Neuron(;seed = 123, alpha = 1.3600, s0=0.230, Rmax=5.70, bRectify=false, normType=2, bNormF=false) = Neuron(seed, alpha, s0, Rmax, bRectify, normType, bNormF)

struct Response
    r::Array
    mean::Array
    var::Vector
end
# RESPOND
    function respond(filter::Filter,neu::Neuron,stim::Stim)::Response
        """
        X      [Nlvl, 1]
        lvlInd [Nstm]
        stimS      [Nlvl,Ni,nPix]
        f      [nPix Nf]

        r      [Nlvl, Ni, Nf}

        normType1: Ac Nf
        normType2: Ac,[], xpix,ypix,nstim
        """

        mean = neu.Rmax*dot(stim.img,filter.f)
        var = neu.alpha .* abs(mean) .+ neu.s0
        noise = randn(neu.rng,0,1,size(var))*sqrt(var)
        r = mean+noise

        if neu.bRectify
            r[r < 0]=0
        end

        #norm!(r,neu,stim) # TODO

        response=Response(r,mean,var)

        return response
    end
    #function norm!(r,neu,stim)
    #    # TODO
    #    if neu.normType==1
    #        # Ac neu
    #        normbrd!(r,stim)
    #    elseif neu.normType==2
    #        normnrw!(r,stim)
    #    end
    #end
# NORMALIZE
    #function normbrd!(r)
    #    # TODO
    #end

    #function normnrw!(r)
    #    # TODO
    #end
# PLOT
    #function plot(response::Response)
    #    # TODO
    #end

    #function plotmean(response::Response)
    #    # TODO
    #end
#

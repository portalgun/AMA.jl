using Random

struct Neuron
    rng::AbstractRNG
    alpha::Float32
    s0::Float32
    Rmax::Float32
    bRectify::Bool
    normType::UInt8
    bNormF::Bool

end
Neuron(seed = 123, alpha = 1.3600, s0=0.230, Rmax=5.70, bRectify=0, normType=2, bNormF=0) = Neuron( MersenneTwister(123), alpha, s0, Rmax, bRectify, normType, bNormF)

struct Response
    r::Array
    mean::Array
    var::Vector
end
# RESPOND
    function respond(filter::Filter,N::Neuron,stim::Stim)::Response
        """
        X      [Nlvl, 1]
        lvlInd [Nstm]
        stimS      [Nlvl,Ni,nPix]
        f      [nPix Nf]

        r      [Nlvl, Ni, Nf}

        normType1: Ac Nf
        normType2: Ac,[], xpix,ypix,nstim
        """

        mean = N.Rmax*dot(stim.img,filter.f)
        var = N.alpha .* abs(mean) .+ N.s0
        noise = randn(N.rng,0,1,size(N.varR))*sqrt(N.varR)
        r = mean+noise

        if N.bRectify
            r[r < 0]=0
        end

        norm!(r)

        response=Response(r,mean,var)

        return response
    end
    function norm!(r,stim)
        if N.normType==1
            # Ac Nf
            normbrd!(r,stim)
        elseif N.normType==2
            R=normnrw!(r,stim)
        end
    end
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

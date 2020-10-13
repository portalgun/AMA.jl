module AMA

struct Stim 
    fname::String
    img::Stim
    nStim::Int32
    nPix::Int32
    nPixX::Int32
    nPixAll::Int32

    X::Real
    Ni::Int32
    Nlvl::Int8
    lvlInd::Int8
    ctgInd:: # XXX

    Ac:: # XXX

    function Stim(fname::String,img,ctgInd,X)
        nStim=size(ctgInd,1)
        Nlvl =max(ctgInd)
        Ni   =nStim/Nlvl # num stim per lvl
        nPix = size(img,1)

        S2D=reshape(img,(Nlvl, Ni, nPixX, yPix))
        Ac=abs(fft(S2D,axes=(2,3))) # constant, piecwize, XXX
        new(fname,img,nStim,nPix,nPixX,nPixAll,X,Ni,Nlvl,lvlInd,ctgInd,Ac)
    end
end


    # RESHAPING
    function reshape4(stim::Stim)
        img=reshape(stim.img,(stim.Nlvl, stim.Ni, stim.xPix, stim.yPix))
        return img
    end
    function reshape_AMA(stim::Stim):
        # XXX
        Simg=NP.empty([Nlvl,Ni,nPix])
        S=NP.transpose(S)
        for i in unique(ctgInd):
            Snew[i,:,:]=S[ctgInd==i,:]
        end

        return S
    end
    # PLOTTING

    function plot_S(self,lvl,n):
        # TODO
        S=self.OPT.AMA.reshape_S()
        plot.imshow(S[lvl,n,:,:],cmap="gray")
        plot.show()
    end
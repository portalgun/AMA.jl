struct Stim
    fname::String
    nStim::UInt32
    nPix::UInt32
    nPixX::UInt32
    nPixAll::UInt32

    X::Vector{Float32}
    Ni::UInt32
    Nlvl::UInt8
    ctgInd::Vector{UInt8}

    img::Array
    Ac::Array
    labels::Array

    function Stim(fname::String, img::Array, ctgInd::Vector, X::Vector)
        nStim::UInt32 = size(ctgInd,1)
        Nlvl::UInt8   = maximum(ctgInd)
        Ni::UInt32    = nStim/Nlvl 
        nPix::UInt32  = size(img,1)
        nPixX::UInt32 = sqrt(nPix)
        nPixAll::UInt32 = nPix*Ni*Nlvl

        S2D=reshape(img, Nlvl, Ni, nPixX, nPixX)
        Ac=zeros(Float32,Nlvl, Ni, nPixX, nPixX)
        for i = 1:Nlvl, j= 1:Ni
            Ac[i,j,:,:]=abs.( FFTW.fft(S2D[i,j,:,:], (1,2)) )
        end
        labels=reshape(X[ctgInd],(Nlvl,Ni))
        new(fname, nStim,nPix,nPixX,nPixAll,X,Ni,Nlvl,ctgInd,img,Ac,labels)

    end
end

    # RESHAPING
    function reshape4(stim::Stim)
        img=reshape(stim.img,(stim.Nlvl, stim.Ni, stim.nPixX, stim.nPixX))
        return img
    end
    function reshape_AMA(stim::Stim)
        # XXX
        Simg=empty([stim.Nlvl,stim.Ni,stim.nPix])
        stim.img=transpose(stim.img)
        for i in unique(stim.ctgInd)
            Simg[i,:,:]=stim[stim.ctgInd==i,:]
        end

        return Simg
    end
    # PLOTTING

    function plot_S(self,lvl,n)
        # TODO
        S=self.OPT.AMA.reshape_S()
        Plots.plot.imshow(S[lvl,n,:,:],cmap="gray")
        Plots.plot.show()
    end

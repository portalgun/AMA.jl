struct FilterSpec
    ind::Vector
    Nf::UInt32
    nPix::UInt32
    nPixX::UInt32
    nPixAll::UInt32

    function FilterSpec(Nf::Int,nPixX::Int)
        nPix=nPixX^2
        nPixAll=Nf*nPix
        ind=repeat( collect([1:fs.Nf]), inner=nPix )
        new(ind,Nf,nPix,nPixX,nPixAll)
    end
end

mutable struct Filter <: supertype(AbstractArray)
    f::Vector

    function Filter(f::Vector,fs::FilterSpec)
        reshape!(f, (fs.nPix, fs.Nf))
        new(f)
    end
    function Filter(fs::FilterSpec)
        f=randn(fs.nPixAll)
        sums=count(ind, wv=f.^2)
        sums=repeat(sums, inner=nPix)
        f=f/sqrt(sums)
        reshape!(f, (fs.nPix, fs.Nf))
        new(f)
    end
end
# RESHAPING
    function flatten(f::Filter)
        f=filter.f.ravel()
        return f
    end

    function reshape2!(filter::Filter, fs::FilterSpec)
        filter.f=reshape(filter.f, (fs.nPix, fs.Nf))
        return filter
    end

    function reshape2(filter::Filter, fs::FilterSpec)
        f=reshape(filter.f, (fs.nPix, fs.Nf))
        return f
    end

    function reshape3(filter::Filter, fs::FilterSpec)
        f=reshape2(filter,fs)
        f=reshape(filter.f, (fs.xPix, fs.yPix, fs.Nf))
        return f
    end
# PLOTTING
    function plotraw(self)
        # TODO
        f =self.OPT.AMA.f
        Nf=self.OPT.AMA.Nf
        for i in range(Nf)
            plot.subplot(1,Nf,i)
            ff=f[:,i]
            plot.imshow(ff[:,NP.newaxis])
        end

        plot.show()
        return 0
    end

    function plot(self)
        # TODO
        f=self.OPT.AMA.reshape_f(self.OPT.fopt)
        for i in range(self.OPT.AMA.Nf)
            plot.subplot(1,self.OPT.AMA.Nf,i+1)
            plot.imshow(f[:,:,i], cmap="gray")
        end
        plot.show()
        return 0
    end
#

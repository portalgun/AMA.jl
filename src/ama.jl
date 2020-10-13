module AMA
using MAT

mutable struct AMA
    optSpec::OptSpec
    objSpec::ObjSpec
    conSpec::ConSpec
    fSpec::FilterSpec
    neu::Neuron
    stim::Stim
    opt::Opt
end

struct OptSpec
    lib::String
    alg::String

    xtolabs::Float
    xtolrel::Float
    ftolabs::Float
    ftolrel::Float

    maxeval::UInt
    maxtime::UInt
    step::Float
    stopval::Float


    bPrint::Bool
    bPrintCons::Bool
end

struct ConSpec
    bsimplex::Bool
    blb::Bool
    bub::Bool
    lb::Float
    ub::Float
end

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

function AMA(Nf::Int, nPixX::Int;

        stimfname::String="",
        filterfname::String="",
        verboselvl::Int=0,

        lib::String="NLopt",
        alg::String="SLSQP",

        xtolabs::Float=0.0,
        xtolrel::Float=0.0,
        ftolabs::Float=0.0,
        ftolrel::Float=0.0,

        maxeval::UInt=0,
        maxtime::UInt=0,
        step::Float=0,
        stopval::Float=0,

        bsimplex::Bool=1,
        blb::Bool=1,
        bub::Bool=1,
        lb::Float=-0.4,
        ub::Float=0.4

        seed::UInt = 123,
        alpha::Flaot = 1.3600,
        s0=::Float 0.230,
        Rmax::Float=5.70,
        bRectify::Bool=0,
        normType::Uint=2,
        bNormF::Bool=0,



    ) :: AMA

    if verboselvl>=1
        bPrint=1
    else
        bPrint=0
    end
    if verboselvl>=2
        bPrintCons=1
    else
        bPrintCons=1
    end

    optSpec=OptSpec(
                    lib,
                    alg,

                    xtolabs,
                    xtolrel,
                    ftolabs<
                    ftolrel,

                    maxeval,
                    maxtime,
                    step,
                    stopval,

                    bPrint,
                    bPrintCons
    )

    conSpec=ConSpec(
                    bsimplex,
                    blb,
                    bub,
                    lb
                    ub
    )

    neu= Neuron(seed, alpha, s0, Rmax, bRectify, normType, bNormF)
    setcons!(opt,optSpec,neu)
    filterSpec=FilterSpec(Nf,nPixX)
    opt=setopt(OptSpec,neu)
    stim=loadstim(stimfname)

    a=new(optSpec, objSpec, conSpec, filterSpec,  neu, stim, opt)
    println("now run optimize!(⋅)")
    return a
end
function optimize!(ama::AMA)
    optimize!(ama.opt, ama.fSpec)
end

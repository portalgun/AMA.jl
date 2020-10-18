using NLopt

struct OptSpec
    lib::String
    alg::String

    xtolabs::Float32
    xtolrel::Float32
    ftolabs::Float32
    ftolrel::Float32

    maxeval::UInt
    maxtime::UInt
    step::Float32
    stopval::Float32

    bPrint::Bool
    bPrintCons::Bool
end

struct ConSpec
    bsimplex::Bool
    blb::Bool
    bub::Bool
    lb::Float32
    ub::Float32
end




mutable struct AMAopt
    optSpec::OptSpec
    objSpec::ObjSpec
    conSpec::ConSpec
    fSpec::FilterSpec
    neu::Neuron
    stim::Stim
    opt::Opt
end


function AMAopt(Nf::Int, nPixX::Int;
        stimfname::String   = "",
        filterfname::String = "",
        verboselvl::Int     = 0,

        lib::String         = "NLopt",
        alg::String         = "SLSQP",

        xtolabs::Float32      = 0.0,
        xtolrel::Float32      = 0.0,
        ftolabs::Float32      = 0.0,
        ftolrel::Float32      = 0.0,

        maxeval::UInt       = 0,
        maxtime::UInt       = 0,
        step::Float32        = 0,
        stopval::Float32     = 0,

        bsimplex::Bool      = 1,
        blb::Bool           = 1,
        bub::Bool           = 1,
        lb::Float32         = -0.4,
        ub::Float32         = 0.4,

        seed::UInt          = 123,
        alpha::Float32      = 1.3600,
        s0::Float32           = 0.230,
        Rmax::Float32         = 5.70,
        bRectify::Bool      = 0,
        normType::UInt      = 2,
        bNormF::Bool        = 0
    ) :: AMAopt

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
                    ftolabs,
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
                    lb,
                    ub
    )

    neu= Neuron(seed, alpha, s0, Rmax, bRectify, normType, bNormF)
    setcons!(opt,optSpec,neu)
    filterSpec=FilterSpec(Nf,nPixX)
    opt=setopt(OptSpec,neu)
    stim=loadstim(stimfname)

    a=new(optSpec, objSpec, conSpec, filterSpec,  neu, stim, opt)
end
function optimize!(ama::AMAopt)
    optimize!(ama.opt, ama.fSpec)
end

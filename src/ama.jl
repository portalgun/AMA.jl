struct OptSpec
    lib::String
    alg::String

    xtolabs::Float64
    xtolrel::Float64
    ftolabs::Float64
    ftolrel::Float64

    maxeval::Int
    maxtime::Int
    step::Float64
    stopval::Float64

    bPrint::Bool
    bPrintCons::Bool
end

struct ConSpec
    bsimplex::Bool
    blb::Bool
    bub::Bool
    lb::Float64
    ub::Float64
    tol::Float64
end


mutable struct AMAOpt
    optSpec::OptSpec
    objSpec::ObjSpec
    conSpec::ConSpec
    fSpec::FilterSpec
    neu::Neuron
    stim::Stim
    opt::NLopt.Opt
    filterfname::String

    function AMAOpt(Nf::Int,
                    nPixX::Int,
                    stimfname::String,
                    filterfname::String,
                    verboselvl::Int,
                    lib::String,
                    alg::String,
                    xtolabs::Float64,
                    xtolrel::Float64,
                    ftolabs::Float64,
                    ftolrel::Float64,
                    maxeval::Int,
                    maxtime::Int,
                    step::Float64,
                    stopval::Float64,
                    bsimplex::Bool,
                    blb::Bool,
                    bub::Bool,
                    lb::Float64,
                    ub::Float64,
                    ctol::Float64,
                    seed::Int,
                    alpha::Float64,
                    s0::Float64,
                    Rmax::Float64,
                    bRectify::Bool,
                    normType::Int,
                    bNormF::Bool,
                    errType::Int,
                    bMean::Bool)
        if verboselvl>=1
            bPrint=true
        else
            bPrint=false
        end
        if verboselvl>=2
            bPrintCons=true
        else
            bPrintCons=false
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
                        ub,
                        ctol
        )
        objSpec=ObjSpec(errType,bMean)
        stim=loadstim(stimfname)
        filterSpec=FilterSpec(Nf,nPixX)
        neu= Neuron(seed, alpha, s0, Rmax, bRectify, normType, bNormF)

        opt=setopt(optSpec, neu, stim, objSpec, filterSpec)
        setcons!(opt,stim, conSpec, filterSpec)

        new(optSpec, objSpec, conSpec, filterSpec,  neu, stim, opt, filterfname)
    end
end

AMAOpt( Nf::Int,
        nPixX::Int;
        stimfname::String   = "",
        filterfname::String = "",
        verboselvl::Int     = 0,

        lib::String         = "NLopt",
        alg::String         = "SLSQP",

        xtolabs::Float64    = 0.0,
        xtolrel::Float64    = 0.0,
        ftolabs::Float64    = 0.0,
        ftolrel::Float64    = 0.0,

        maxeval::Int        = 0,
        maxtime::Int        = 0,
        step::Float64       = 0.0,
        stopval::Float64    = 0.0,

        bsimplex::Bool      = true,
        blb::Bool           = true,
        bub::Bool           = true,
        lb::Float64         = -0.4,
        ub::Float64         = 0.4,
        ctol::Float64       = 0.0,

        seed::Int           = 123,
        alpha::Float64      = 1.3600,
        s0::Float64         = 0.230,
        Rmax::Float64       = 5.70,
        bRectify::Bool      = false,
        normType::Int       = 2,
        bNormF::Bool        = false,
        errType::Int        = 2,
        bMean::Bool         = false
        ) = AMAOpt(Nf,
                   nPixX,
                   stimfname,
                   filterfname,
                   verboselvl,
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
                   bsimplex,
                   blb,
                   bub,
                   lb,
                   ub,
                   ctol,
                   seed,
                   alpha,
                   s0,
                   Rmax,
                   bRectify,
                   normType,
                   bNormF,
                   errType,
                   bMean
        )

function optimize!(ama::AMAOpt)
    optimize!(ama.opt, ama.fSpec)
end

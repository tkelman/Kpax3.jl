# This file is part of Kpax3. License is MIT.

function clusterweight(n::Real,
                       priorR::EwensPitmanPAUT)
  log(n - priorR.α)
end

function clusterweight(n::Real,
                       priorR::EwensPitmanPAZT)
  log(n - priorR.α)
end

function clusterweight(n::Real,
                       priorR::EwensPitmanZAPT)
  log(n)
end

function clusterweight(n::Real,
                       priorR::EwensPitmanNAPT)
  log(n - priorR.α)
end

function clusterweight(n::Real,
                       k::Real,
                       priorR::EwensPitmanPAUT)
  log(priorR.θ + priorR.α * k)
end

function clusterweight(n::Real,
                       k::Real,
                       priorR::EwensPitmanPAZT)
  log(priorR.α * k)
end

function clusterweight(n::Real,
                       k::Real,
                       priorR::EwensPitmanZAPT)
  log(priorR.θ)
end

function clusterweight(n::Real,
                       k::Real,
                       priorR::EwensPitmanNAPT)
  log(priorR.α * (k - priorR.L))
end

function logratiopriorrowmerge!(k::Real,
                                ep::EwensPitmanPAUT,
                                support::MCMCSupport)
  support.lograR = lgamma(1 - ep.α) + lgamma(support.vi + support.vj - ep.α) -
                   log(ep.θ + k * ep.α) - lgamma(support.vi - ep.α) -
                   lgamma(support.vj - ep.α)
  nothing
end

function logratiopriorrowmerge!(k::Real,
                                ep::EwensPitmanPAZT,
                                support::MCMCSupport)
  support.lograR = lgamma(1 - ep.α) + lgamma(support.vi + support.vj - ep.α) -
                   log(k) - log(ep.α) - lgamma(support.vi - ep.α) -
                   lgamma(support.vj - ep.α)
  nothing
end

function logratiopriorrowmerge!(k::Real,
                                ep::EwensPitmanZAPT,
                                support::MCMCSupport)
  support.lograR = lgamma(support.vi + support.vj) - log(ep.θ) -
                   lgamma(support.vi) - lgamma(support.vj)
  nothing
end

function logratiopriorrowmerge!(k::Real,
                                ep::EwensPitmanNAPT,
                                support::MCMCSupport)
  support.lograR = - log((k - ep.L) * ep.α * exp(lgamma(support.vi - ep.α) +
                   lgamma(support.vj - ep.α) - lgamma(1 - ep.α) -
                   lgamma(support.vi + support.vj - ep.α)))
  nothing
end

function logratiopriorrowsplit!(k::Real,
                                ep::EwensPitmanPAUT,
                                support::MCMCSupport)
  support.lograR = log(ep.θ + (k - 1) * ep.α) - lgamma(1 - ep.α) +
                   lgamma(support.vi - ep.α) + lgamma(support.vj - ep.α) -
                   lgamma(support.vi + support.vj - ep.α)
  nothing
end

function logratiopriorrowsplit!(k::Real,
                                ep::EwensPitmanPAZT,
                                support::MCMCSupport)
  support.lograR = log(k - 1) + log(ep.α) - lgamma(1 - ep.α) +
                   lgamma(support.vi - ep.α) + lgamma(support.vj - ep.α) -
                   lgamma(support.vi + support.vj - ep.α)
  nothing
end

function logratiopriorrowsplit!(k::Real,
                                ep::EwensPitmanZAPT,
                                support::MCMCSupport)
  support.lograR = log(ep.θ) + lgamma(support.vi) + lgamma(support.vj) -
                   lgamma(support.vi + support.vj)
  nothing
end

function logratiopriorrowsplit!(k::Real,
                                ep::EwensPitmanNAPT,
                                support::MCMCSupport)
  support.lograR = log((k - 1 - ep.L) * ep.α * exp(lgamma(support.vi - ep.α) +
                   lgamma(support.vj - ep.α) - lgamma(1 - ep.α) -
                   lgamma(support.vi + support.vj - ep.α)))
  nothing
end

function logratiopriorrowmerge(k::Real,
                               vj::Real,
                               ep::EwensPitmanPAUT)
  log(vj - ep.α) - log(ep.θ + k * ep.α)
end

function logratiopriorrowmove(vi::Real,
                              vj::Real,
                              ep::EwensPitmanPAUT)
  log(vj - ep.α) - log(vi - 1 - ep.α)
end

function logratiopriorrowsplit(k::Real,
                               vi::Real,
                               ep::EwensPitmanPAUT)
  log(ep.θ + (k - 1) * ep.α) - log(vi - 1 - ep.α)
end

function logratiopriorrowmerge(k::Real,
                               vj::Real,
                               ep::EwensPitmanPAZT)
  log(vj - ep.α) - log(k) - log(ep.α)
end

function logratiopriorrowmove(vi::Real,
                              vj::Real,
                              ep::EwensPitmanPAZT)
  log(vj - ep.α) - log(vi - 1 - ep.α)
end

function logratiopriorrowsplit(k::Real,
                               vi::Real,
                               ep::EwensPitmanPAZT)
  log(k - 1) + log(ep.α) - log(vi - 1 - ep.α)
end

function logratiopriorrowmerge(k::Real,
                               vj::Real,
                               ep::EwensPitmanZAPT)
  log(vj) - log(ep.θ)
end

function logratiopriorrowmove(vi::Real,
                              vj::Real,
                              ep::EwensPitmanZAPT)
  log(vj) - log(vi - 1)
end

function logratiopriorrowsplit(k::Real,
                               vi::Real,
                               ep::EwensPitmanZAPT)
  log(ep.θ) - log(vi - 1)
end

function logratiopriorrowmerge(k::Real,
                               vj::Real,
                               ep::EwensPitmanNAPT)
  - log((k - ep.L) * ep.α * exp(lgamma(vj - ep.α) - lgamma(vj + 1 - ep.α)))
end

function logratiopriorrowmove(vi::Real,
                              vj::Real,
                              ep::EwensPitmanNAPT)
  log(vj - ep.α) - log(vi - 1 - ep.α)
end

function logratiopriorrowsplit(k::Real,
                               vi::Real,
                               ep::EwensPitmanNAPT)
  log((k - 1 - ep.L) * ep.α * exp(lgamma(vi - 1 - ep.α) - lgamma(vi - ep.α)))
end

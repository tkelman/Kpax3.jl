# This file is part of Kpax3. License is MIT.

function plotP(R::Vector{Int},
               P::Matrix{Float64};
               clusterorder::Vector{Int}=zeros(Int, 0),
               clusterlabel::Vector{String}=fill("", 0),
               linesep::Bool=true,
               width::Real=89.0,
               height::Real=89.0)
  n = length(R)
  k = maximum(R)

  if length(clusterorder) == 0 || length(clusterorder) != k
    clusterorder = collect(1:k)
  end

  if length(clusterlabel) == 0 || length(clusterlabel) != k
    clusterlabel = map(l -> string(l), clusterorder)
  end

  (ord, mid, sep) = reorderunits(R, P, clusterorder)

  N = n^2

  x = zeros(Int, N)
  y = zeros(Int, N)
  z = fill("", N)

  idx = 1
  pij = 0.0
  for j = 1:n, i = 1:n
    x[idx] = j
    y[idx] = i

    pij = P[ord[i], ord[j]]
    z[idx] = if pij <= 0.2
      "[0.0, 0.2]"
    elseif pij <= 0.4
      "(0.2, 0.4]"
    elseif pij <= 0.6
      "(0.4, 0.6]"
    elseif pij <= 0.8
      "(0.6, 0.8]"
    else
      "(0.8, 1.0]"
    end

    idx += 1
  end

  majorfontsize = computefontsize(width, height)
  minorfontsize = 0.8 * majorfontsize
  keytitlefontsize = majorfontsize
  keylabelfontsize = 0.8 * keytitlefontsize

  plot(layer(x=repeat(sep[1:k], outer=2), y=[sep[1:k]; sep[2:end]],
             xend=repeat(sep[2:end], outer=2), yend=[sep[1:k]; sep[2:end]],
             Geom.segment),
       layer(x=[sep[1:k]; sep[2:end]], y=repeat(sep[1:k], outer=2),
             xend=[sep[1:k]; sep[2:end]], yend=repeat(sep[2:end], outer=2),
             Geom.segment),
       layer(x=x, y=y, color=z, Geom.rectbin),
       Coord.cartesian(yflip=true, fixed=true, xmin=0.5, xmax=n + 0.5, ymin=0.5,
                       ymax=n + 0.5),
       Scale.color_discrete_manual(colorant"#FFFFFF", colorant"#CCCCCC",
                                   colorant"#999999", colorant"#666666",
                                   colorant"#333333", colorant"#000000",
                                   levels=["[0.0, 0.2]", "(0.2, 0.4]",
                                           "(0.4, 0.6]", "(0.6, 0.8]",
                                           "(0.8, 1.0]"]),
       Scale.x_continuous(labels=l -> string(clusterlabel[mid .== l][1])),
       Scale.y_continuous(labels=l -> string(clusterlabel[mid .== l][1])),
       Theme(default_color=colorant"black", background_color=colorant"white",
             panel_fill=colorant"white", grid_line_width=0mm,
             line_width=if linesep 0.3mm else 0mm end,
             lowlight_color=c->c, lowlight_opacity=0.0,
             major_label_font_size=majorfontsize,
             minor_label_font_size=minorfontsize,
             key_title_font_size=keytitlefontsize,
             key_label_font_size=keylabelfontsize),
       Guide.xticks(ticks=mid),
       Guide.yticks(ticks=mid),
       Guide.xlabel(""),
       Guide.ylabel(""),
       Guide.title(""),
       Guide.colorkey(""))
end

function plotC(site::Vector{Int},
               freq::Vector{Float64},
               C::Matrix{Float64};
               width::Real=183.0,
               height::Real=92.0)
  m = site[end]
  M = length(site)

  noise = zeros(Float64, m)
  weak = zeros(Float64, m)

  key = 1
  for b in 1:M
    if site[b] != key
      weak[key] += noise[key]
      key += 1
    end

    noise[key] += freq[b] * C[1, b]
    weak[key] += freq[b] * C[2, b]
  end

  weak[key] += noise[key]

  majorfontsize = computefontsize(width, height)
  minorfontsize = 0.8 * majorfontsize
  keytitlefontsize = majorfontsize
  keylabelfontsize = 0.8 * keytitlefontsize

  plot(layer(x=repeat(1:m, outer=3), ymin=[zeros(Float64, m); noise; weak],
             ymax=[noise; weak; ones(Float64, m)],
             color=[fill("Noise", m); fill("Weak", m);
                    fill("Strong", m)], Geom.ribbon),
       Coord.cartesian(xmin=1, xmax=m, ymin=0, ymax=1),
       Scale.x_continuous(minvalue=1, maxvalue=m),
       Scale.y_continuous(minvalue=0, maxvalue=1),
       Scale.color_discrete_manual(colorant"white", colorant"gray",
                                   colorant"black"),
       Theme(default_color=colorant"black", background_color=colorant"white",
             panel_fill=colorant"white", grid_line_width=0mm,
             lowlight_color=c->c, lowlight_opacity=0.0,
             major_label_font_size=majorfontsize,
             minor_label_font_size=minorfontsize,
             key_title_font_size=keytitlefontsize,
             key_label_font_size=keylabelfontsize),
       Guide.xlabel(""),
       Guide.ylabel("Posterior probability"),
       Guide.title(""),
       Guide.colorkey("Signal"))
end
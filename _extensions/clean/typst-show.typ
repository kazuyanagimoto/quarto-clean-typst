#show: clean-theme.with(
  aspect-ratio: "16-9",
  $if(handout)$
    handout: true,
  $endif$
  // Typography ---------------------------------------------------------------
  $if(fontsize)$
    font-size: $fontsize$,
  $elseif(brand.typography.base.size)$
    font-size: $brand.typography.base.size$,
  $endif$
  $if(sansfont)$
    font-family-heading: ("$sansfont$",),
  $elseif(brand.typography.headings.family)$
    font-family-heading: $brand.typography.headings.family$,
  $endif$
  $if(mainfont)$
    font-family-body: ("$mainfont$",),
  $elseif(brand.typography.base.family)$
    font-family-body: $brand.typography.base.family$,
  $endif$
  $if(font-weight-heading)$
    font-weight-heading: "$font-weight-heading$",
  $elseif(brand.typography.headings.weight)$
    font-weight-heading: $brand.typography.headings.weight$,
  $endif$
  $if(font-weight-body)$
    font-weight-body: "$font-weight-body$",
  $endif$
  // Colors --------------------------------------------------------------------
  $if(jet)$
    color-jet: rgb("$jet$"),
  $elseif(brand.color.foreground)$
    color-jet: brand-color.foreground,
  $endif$
  $if(accent)$
    color-accent: rgb("$accent$"),
  $elseif(brand.color.primary)$
    color-accent: brand-color.primary,
  $endif$
  $if(accent2)$
    color-accent2: rgb("$accent2$"),
  $elseif(brand.color.secondary)$
    color-accent2: brand-color.secondary,
  $endif$
  // Title slide ---------------------------------------------------------------
  $if(font-weight-title)$
    font-weight-title: $font-weight-title$,
  $elseif(brand.defaults.clean-typst.title-slide.title.weight)$
    font-weight-title: $brand.defaults.clean-typst.title-slide.title.weight$,
  $endif$
  $if(font-size-title)$
    font-size-title: $font-size-title$,
  $elseif(brand.defaults.clean-typst.title-slide.title.size)$
    font-size-title: $brand.defaults.clean-typst.title-slide.title.size$,
  $endif$
  $if(font-size-subtitle)$
    font-size-subtitle: $font-size-subtitle$,
  $elseif(brand.defaults.clean-typst.title-slide.subtitle.size)$
    font-size-subtitle: $brand.defaults.clean-typst.title-slide.subtitle.size$,
  $endif$
)

#title-slide(
  title: [$title$],
  subtitle: [$subtitle$],
  authors: (
    $for(by-author)$
      $if(it.name.literal)$
          ( name: [$it.name.literal$],
            affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
            email: [$it.email$],
            orcid: [$it.orcid$]),
      $endif$
    $endfor$
  ),
  date: [$date$],
)

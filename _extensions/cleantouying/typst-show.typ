#show: clean-theme.with(
  aspect-ratio: "16-9",
  $if(handout)$
    handout: true,
  $endif$
  $if(fontsize)$
    font-size: $fontsize$,
  $endif$
  $if(sansfont)$
    font-heading: ("$sansfont$",),
  $endif$
  $if(mainfont)$
    font-body: ("$mainfont$",),
  $endif$
  $if(font-weight-heading)$
    font-weight-heading: "$font-weight-heading$",
  $endif$
  $if(font-weight-body)$
    font-weight-body: "$font-weight-body$",
  $endif$
  $if(font-weight-title)$
    font-weight-title: "$font-weight-title$",
  $endif$
  $if(font-size-title)$
    font-size-title: $font-size-title$,
  $endif$
  $if(font-size-subtitle)$
    font-size-subtitle: $font-size-subtitle$,
  $endif$
  $if(jet)$
    color-jet: "$jet$",
  $endif$
  $if(accent)$
    color-accent: "$accent$",
  $endif$
  $if(accent2)$
    color-accent2: "$accent2$",
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

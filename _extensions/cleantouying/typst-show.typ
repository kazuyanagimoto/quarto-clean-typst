#show: clean-theme.with(
  aspect-ratio: "16-9",
  $if(sansfont)$
    font-heading: ("$sansfont$",),
  $endif$
  $if(mainfont)$
    font-body: ("$mainfont$",),
  $endif$
  $if(fontsize)$
    font-size: $fontsize$,
  $endif$
  $if(accent)$
    color-primary: "$accent$",
  $endif$
  $if(accent2)$
    color-secondary: "$accent2$",
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

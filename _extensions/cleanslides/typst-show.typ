#show: doc => slides(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
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
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(mainfont)$
  mainfont: ("$mainfont$",),
$endif$
$if(sansfont)$
  sansfont: ("$sansfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(accent)$
  accent: [$accent$],
$endif$
$if(accent2)$
  accent2: [$accent2$],
$endif$
  doc,
)

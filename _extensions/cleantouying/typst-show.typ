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
      email: [$it.email$] ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(font-haeding)$
  font-heading: [$font-heading$],
$endif$
$if(font-text)$
  font-text: [$font-text$],
$endif$
$if(font-monospace)$
  font-monospace: [$font-monospace$],
$endif$
$if(color-accent1)$
  color-accent1: $color-accent1$,
$endif$
$if(color-accent2)$
  color-accent2: $color-accent2$,
$endif$
  doc,
)

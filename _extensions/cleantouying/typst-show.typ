#let s = register(aspect-ratio: "16-9",
                  $if(sansfont)$
                    font-heading: ("$sansfont$",),
                  $endif$
                  $if(mainfont)$
                    font-body: ("$mainfont$",),
                  $endif$
                  $if(fontsize)$
                    font-size: $fontsize$,
                  $endif$
                  footer: self => self.info.institution)
#let s = (s.methods.info)(
  self: s,
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
)
#let s = (s.methods.colors)(
    self: s,
    $if(accent)$
      primary: rgb("$accent$"),
    $endif$
    $if(accent2)$
      secondary: rgb("$accent2$"),
    $endif$
)

#(s.enable-styled-warning = false)
#let (init, slides, touying-outline, alert, speaker-note, fg, bg, button) = utils.methods(s)
#show: init

#let (slide, empty-slide, title-slide, focus-slide) = utils.slides(s)
#show: slides
#import "@preview/touying:0.5.2": *
#import "@preview/fontawesome:0.3.0": *

#let new-section-slide(level: 1, title)  = touying-slide-wrapper(self => {
  let body = {
    set align(left + horizon)
    set text(size: 2.5em, fill: self.colors.primary, weight: "bold")
    title
  }
  self = utils.merge-dicts(
    self,
    config-page(margin: (left: 2em, top: -0.25em)),
  ) 
  touying-slide(self: self, body)
})

#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  // set page
  let header(self) = {
    set align(top)
    show: components.cell.with(inset: (x: 2em, y: 1.5em))
    set text(
      size: 1.6em,
      fill: self.colors.neutral-darkest,
      weight: "bold",
      font: self.store.font-heading,
    )
    utils.call-or-display(self, self.store.header)
  }
  let footer(self) = {
    set align(bottom)
    show: pad.with(.4em)
    set text(fill: self.colors.neutral-darkest, size: .8em)
    utils.call-or-display(self, self.store.footer)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
  }

  // Set the slide
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})


#let clean-theme(
  aspect-ratio: "16-9",
  header: utils.display-current-heading(level: 2),
  footer: [],
  font-heading: (),
  font-body: (),
  font-size: 20pt,
  color-primary: "#009f8c",
  color-secondary: "b75c9d",
  ..args,
  body,
) = {
  set text(size: font-size, font: font-body)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 4em, bottom: 1.5em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        show link: set text(fill: self.colors.secondary)
        // Unordered List
        set list(
          indent: 1em,
          marker: (text(fill: self.colors.primary)[ #sym.triangle.filled ],
                    text(fill: self.colors.primary)[ #sym.arrow]),
        )
        // Ordered List
        set enum(
          indent: 1em,
          full: true, // necessary to receive all numbers at once, so we can know which level we are at
          numbering: (..nums) => {
            let nums = nums.pos()
            let num = nums.last()
            let level = nums.len()

            // format for current level
            let format = ("1.", "i.", "a.").at(calc.min(2, level - 1))
            let result = numbering(format, num)
            text(fill: self.colors.primary, result)
          }
        ) 
        // Slide Subtitle
        show heading.where(level: 3): title => {
          set text(
            size: 1.1em,
            fill: self.colors.primary,
            font: font-body,
            weight: "light",
            style: "italic",
          )
          block(inset: (bottom: 0em))[#title]
        }

        set bibliography(title: none)

        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb(color-primary),
      secondary: rgb(color-secondary),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#272822"),
    ),
    // save the variables for later use
    config-store(
      header: header,
      footer: footer,
      font-heading: font-heading,
      ..args,
    ),
  )

  body
}

#let title-slide(
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  let body = {
    set align(left + horizon)
    block(
      inset: (y: 1em),
      [#text(size: 2em, fill: self.colors.neutral-darkest, weight: "bold", info.title)
       #if info.subtitle != none {
        linebreak()
        v(0em)
        text(size: 1.2em, style: "italic", fill: self.colors.primary, info.subtitle)
      }]
    )

    set text(fill: self.colors.neutral-darkest)

    if info.authors != none {
      let count = info.authors.len()
      let ncols = calc.min(count, 3)
      grid(
        columns: (1fr,) * ncols,
        row-gutter: 1.5em,
        ..info.authors.map(author =>
            align(left)[
              #text(size: 1.2em, weight: "medium")[#author.name]
              #if author.orcid != [] {
                show link: set text(size: 0.7em, fill: rgb("a6ce39"))
                link("https://orcid.org/" + author.orcid.text)[#fa-orcid()]
              } \
              #text(size: 0.7em, style: "italic")[
                #link("mailto:" + author.email.children.map(email => email.text).join())[#author.email]
              ] \
              #text(size: 0.8em, style: "italic")[#author.affiliation]
            ]
        )
      )
    }

    if info.date != none {
      block(if type(info.date) == datetime { info.date.display(self.datetime-format) } else { info.date })
    }
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true)
  )
  touying-slide(self: self, body)
})



// Functions
#let _fg = (self: none, it) => text(fill: self.colors.secondary, it)
#let _bg = (self: none, it) => highlight(
    fill: self.colors.primary,
    radius: 1pt,
    extent: 0.1em,
    it
  )
#let _button(self: none, it) = {
  box(inset: 5pt, radius: 6pt, fill: self.colors.primary)[
    #set text(size: 0.6em, fill: white)
    #sym.triangle.filled.r
    #it
  ]
}

#let fg(it) = touying-fn-wrapper(_fg.with(it))
#let bg(it) = touying-fn-wrapper(_bg.with(it))
#let button(it) = touying-fn-wrapper(_button.with(it))
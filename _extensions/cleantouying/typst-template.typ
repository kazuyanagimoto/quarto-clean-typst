#import "@preview/touying:0.4.2": *
#import "@preview/fontawesome:0.3.0": *


#let slide(self: none, title: auto, ..args) = {
  if title != auto {
    self.clean-title = title
  }
  (self.methods.touying-slide)(self: self, ..args)
}

#let title-slide(self: none, ..args) = {
  self = utils.empty-page(self)
  let info = self.info + args.named()
  let body = {
    set align(left + horizon)
    show: components.cell.with(inset: 3em)
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
              #text(size: 0.85em, style: "italic")[#author.affiliation]
            ]
        )
      )
    }

    if info.date != none {
      block(if type(info.date) == datetime { info.date.display(self.datetime-format) } else { info.date })
    }
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

#let new-section-slide(self: none, section) = {
  self = utils.empty-page(self)
  let body = {
    set align(left + horizon)
    set text(size: 2.5em, fill: self.colors.primary, weight: "bold")
    block(inset: 1em)[#section]
  }
  (self.methods.touying-slide)(self: self, repeat: none, section: section, body)
}

#let focus-slide(self: none, body) = {
  self = utils.empty-page(self)
  self.page-args += (
    fill: self.colors.primary,
    margin: 2em,
  )
  set text(fill: self.colors.neutral-lightest, size: 2em)
  (self.methods.touying-slide)(self: self, repeat: none, align(horizon + center, body))
}

#let slides(self: none, title-slide: true, slide-level: 1, ..args) = {
  if title-slide {
    (self.methods.title-slide)(self: self)
  }
  (self.methods.touying-slides)(self: self, slide-level: slide-level, ..args)
}

// Components
#let button(self: none, body) = {
  box(inset: 5pt, radius: 6pt, fill: self.colors.primary)[
    #set text(size: 0.6em, fill: white)
    #sym.triangle.filled.r
    #body
  ]
}

//------------------------------------------------------------------------------
// Register
//------------------------------------------------------------------------------
#let register(
  self: themes.default.register(),
  aspect-ratio: "16-9",
  font-heading: (),
  font-body: (),
  font-size: 20pt,
  footer: [],
) = {
  // color theme
  self = (self.methods.colors)(
    self: self,
    primary: rgb("#009f8c"),
    secondary: rgb("b75c9d"),
    neutral-lightest: rgb("#ffffff"),
    neutral-darkest: rgb("#272822"),
  )
  // variables for later use
  self.clean-title = []
  self.clean-footer = footer
  // set page
  let header(self) = {
    set align(top)
    show: components.cell.with(inset: (x: 2em, y: 1.5em))
    set text(
      size: 1.6em,
      fill: self.colors.neutral-darkest,
      weight: "bold",
      font: font-heading,
    )
    utils.call-or-display(self, self.clean-title)
  }
  let footer(self) = {
    set align(bottom)
    show: pad.with(.4em)
    set text(fill: self.colors.neutral-darkest, size: .8em)
    utils.call-or-display(self, self.clean-footer)
    h(1fr)
    states.slide-counter.display() + " / " + states.last-slide-number
  }
  self.page-args += (
    paper: "presentation-" + aspect-ratio,
    header: header,
    footer: footer,
    margin: (top: 4em, bottom: 1.5em, x: 2em),
  )

  // register methods
  self.methods.slide = slide
  self.methods.title-slide = title-slide
  self.methods.new-section-slide = new-section-slide
  self.methods.touying-new-section-slide = new-section-slide
  self.methods.focus-slide = focus-slide
  self.methods.slides = slides
  self.methods.alert = (self: none, it) => text(fill: self.colors.primary, it)
  self.methods.fg = (self: none, it) => text(fill: self.colors.secondary, it)
  self.methods.bg = (self: none, it) => highlight(
    fill: self.colors.primary,
    radius: 1pt,
    extent: 0.1em,
    it
  )
  self.methods.button = button

  self.methods.init = (self: none, body) => {
    set text(size: font-size, font: font-body)
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
  }
  self
}

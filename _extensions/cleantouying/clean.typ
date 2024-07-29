#import "@preview/touying:0.4.2": *

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
    if info.author != none {
      block(
        info.author
      )
    }
    if info.date != none {
      block(if type(info.date) == datetime { info.date.display(self.datetime-format) } else { info.date })
    }
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

#let slides(self: none, title-slide: true, slide-level: 1, ..args) = {
  if title-slide {
    (self.methods.title-slide)(self: self)
  }
  (self.methods.touying-slides)(self: self, slide-level: slide-level, ..args)
}


#let register(
  self: themes.default.register(),
  aspect-ratio: "16-9",
  color-accent1: "#009F8C",
  color-accent2: "#B75C9D",
  font-heading: "Josefin Sans",
  font-text: "Montserrat",
  footer: [],
) = {
  // color theme
  self = (self.methods.colors)(
    self: self,
    primary: rgb(color-accent1),
    secondary: rgb(color-accent2),
    neutral-lightest: rgb("#ffffff"),
    neutral-darkest: rgb("#272822"),
  )
  // variables for later use
  self.clean-title = []
  self.clean-footer = footer
  // set page
  let header(self) = {
    set align(top)
    show: components.cell.with(inset: 1.5em)
    set text(
      size: 2em,
      fill: self.colors.primary,
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
  self.methods.slides = slides
  self.methods.alert = (self: none, it) => text(fill: self.colors.primary, it)
  self.methods.init = (self: none, body) => {
    set text(
      size: 16pt,
      font: font-text,
    )
    body
  }
  self
}
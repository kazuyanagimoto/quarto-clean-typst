#import "@preview/touying:0.4.2": *
#import "@preview/fontawesome:0.3.0": *
#import "_extensions/cleantouying/clean.typ"

#let slides(
  title: none,
  subtitle: none,
  authors: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  font-heading: ("Josefin Sans", "Arial", "Helvetica", "Dejavu Sans"),
  font-text: ("Montserrat", "Arial", "Helvetica", "Dejavu Sans"),
  font-monospace: none,
  color-accent1: "#009F8C",
  color-accent2: "#B75C9D",
  doc,
) = {

  let s = clean.register(color-accent1: color-accent1,
                         color-accent2: color-accent2,
                         font-heading: "Josefin Sans",
                         font-text: "Montserrat",)
  let s = (s.methods.info)(
    self: s,
    title: title,
    subtitle: subtitle,
    author: [Author],
    date: date,
    institution: [Institution],
  )
  let (init, slides) = utils.methods(s)
  show: init

  let (slide, empty-slide, title-slide) = utils.slides(s)
  show: slides

  doc 
}


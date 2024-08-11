#import "@preview/fontawesome:0.3.0": *

#let slides(
	title: none,
  subtitle: none,
  authors: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  margin: (x: 1.5em, y: 1.5em),
  paper: "presentation-16-9",
  lang: "en",
  region: "US",
  mainfont: ("Montserrat", "Arial", "Helvetica", "Dejavu Sans"),
  sansfont: ("Josefin Sans", "Arial", "Helvetica", "Dejavu Sans"),
  accent: [009f8c],
  accent2: [b75c9d],
  doc,
) = {
	// Variables for configuration.
  let font-heading = sansfont
  let font-text = mainfont
  let color-accent1 = rgb(accent.text)
  let color-accent2 = rgb(accent2.text)

	set document(
		title: title,
	)
	set text(
    lang: lang,
    region: region,
		font: font-text,
    size: 18pt,
    fill: rgb("#272822")
	)

	set page(
    paper: paper,
		margin: margin
  )

  show heading.where(level: 1): title => {
    set text(size: 2em, weight: "bold", font: font-heading, fill: color-accent1)
    pagebreak(weak: true)
    block(inset: (y: 2.7em))[#title]
  }

	show heading.where(level: 2): title => {
    set text(size: 1.4em, weight: "bold", font: font-heading)
		pagebreak(weak: true)
    block(inset: (bottom: -0.1em))[#title]
	}

  show heading.where(level: 3): title => {
  set text(
    size: 1em,
    fill: color-accent1,
    font: "Montserrat",
    weight: "light",
    style: "italic",
  )
  block(inset: (bottom: 0em))[#title]
}

  // Unordered List
  set list(
    indent: 1em,
    marker: (text(fill: color-accent1)[ #sym.triangle.filled ],
              text(fill: color-accent1)[ #sym.arrow]),
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
      text(fill: color-accent1, result)
    }
  )  

  // Title Slide
  let title-slide = {
    set align(left + horizon)
    block(
      inset: (y: 3em),
      [#text(size: 2em, weight: "bold", title)
      #if subtitle != none {
        linebreak()
        v(0em)
        text(size: 1.2em, style: "italic", fill: color-accent1, subtitle)
      }]
      )

    if authors != none {
        let count = authors.len()
        let ncols = calc.min(count, 3)
        grid(
          columns: (1fr,) * ncols,
          row-gutter: 1.5em,
          ..authors.map(author =>
              align(left)[
                #text(size: 1em, weight: "medium")[#author.name]
                #text(size: 0.7em, fill: rgb("a6ce39"))[
                  #if author.orcid != [] {
                    link("https://orcid.org/" + author.orcid.text)[#fa-orcid()]
                  }
                ] \
                #text(size: 0.7em, style: "italic")[
                  #link("mailto:" + author.email.children.map(email => email.text).join())[#author.email]
                ] \
                #text(size: 0.8em, style: "italic")[#author.affiliation]
              ]
          )
        )
      }

    if date != none {
      block(if type(date) == datetime { date.display(self.datetime-format) } else { date })
    }
    pagebreak(weak: true)
    counter(page).update(1)

  }
	
  title-slide
	doc
}

// Button
#let button(body, fill: rgb("009f8c")) = {
  block(inset: 5pt, radius: 6pt, fill: fill)[
    #set text(size: 0.6em, fill: white)
    #sym.triangle.filled.r
    #body
  ]
}
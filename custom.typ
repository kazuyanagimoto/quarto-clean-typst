#let _small-cite(self: none, it) = text(
  size: 0.7em,
  fill: self.colors.neutral-darkest.lighten(30%),
  it
)

#let small-cite(it) = touying-fn-wrapper(_small-cite.with(it))
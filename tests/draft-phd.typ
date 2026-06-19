#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "en",
  degree: "phd",
  draft: true,
  paper-size: (width: 182mm, height: 257mm),
  page-margin: (
    left: 24mm,
    right: 24mm,
    top: 18mm,
    bottom: 18mm,
  ),
  appendices: (
    (title: [Draft Appendix], body: [Appendix content for a draft Ph.D. build.]),
  ),
)

= Draft Body

The Ph.D. draft renders without approval metadata and still supports appendices.

#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "en",
  cover-language: "en",
  degree: "phd",
  title: [Appendix Counter Fixture],
  title-alt: [부록 번호 확인],
  author: "Hong Gildong",
  student-number: "2026-00001",
  advisor: "Advisor",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "Chair",
    vice-chair: "Vice Chair",
    members: ("Member One", "Member Two"),
  ),
  abstract-ko: [국문초록입니다.],
  abstract-en: [English abstract.],
  bibliography: bibliography("/template/bibliography/references.bib", style: "apa", title: none),
  appendices: (
    (
      title: [First Appendix],
      body: [
        #figure(rect(width: 25mm, height: 8mm), caption: [Appendix image one.])

        #figure(table(columns: 2, [A], [B]), caption: [Appendix table one.])

        $ x = 1 $
      ],
    ),
    (
      title: [Second Appendix],
      body: [
        #figure(rect(width: 25mm, height: 8mm), caption: [Appendix image two.])

        #figure(table(columns: 2, [C], [D]), caption: [Appendix table two.])

        $ y = 2 $
      ],
    ),
  ),
)

#set math.equation(numbering: "(1)")

= Body

Main text with a main figure, table, and equation.

#figure(rect(width: 25mm, height: 8mm), caption: [Main image.])

#figure(table(columns: 2, [M], [N]), caption: [Main table.])

$ z = 0 $

@platt1964strong

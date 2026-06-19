// Expected compile failure: school-en must not include renderer-owned Seoul National University.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "en",
  cover-language: "en",
  degree: "bachelor",
  school-ko: "대학원",
  school-en: "Seoul National University Graduate School of Engineering",
  title: [Duplicate University Fixture],
  title-alt: [중복 학교명 예시],
  author: "Minseo Park",
  student-number: "2026-00000",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  abstract-ko: [국문초록.],
  abstract-en: [English abstract.],
)

= Body

This fixture ensures `school-en` rejects the fixed university name.

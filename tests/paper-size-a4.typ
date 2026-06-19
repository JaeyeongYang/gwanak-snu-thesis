#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "master",
  draft: true,
  paper-size: "a4",
  page-margin: (
    left: 25mm,
    right: 25mm,
    top: 20mm,
    bottom: 20mm,
  ),
)

= A4 page-size fixture

이 fixture는 학위별 규격이 아니라 Typst paper string pass-through를 검증합니다.

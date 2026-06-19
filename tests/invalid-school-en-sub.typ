// Expected compile failure: school-en-sub was removed because the renderer owns Seoul National University.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "bachelor",
  draft: true,
  school-en-sub: "Seoul National University",
)

= 본문

이 fixture는 `school-en-sub` compatibility path가 남아 있지 않고 고정 영문 대학명이 renderer-owned인지 확인합니다.

// Expected compile failure: paper-size no longer accepts the old "official" keyword.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "bachelor",
  draft: true,
  paper-size: "official",
)

= 본문

이 fixture는 공개 전 `paper-size: "official"` 호환 경로가 남아 있지 않은지 확인합니다.

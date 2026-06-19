// Expected compile failure: paper-size dictionaries require width and height.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "bachelor",
  draft: true,
  paper-size: (width: 182mm),
)

= 본문

잘못된 paper-size dictionary를 확인합니다.

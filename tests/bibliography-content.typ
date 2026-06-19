#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "bachelor",
  title: [참고문헌 슬롯 예시],
  title-alt: [Bibliography slot fixture],
  author: "홍길동",
  student-number: "2026-00011",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  abstract-ko: [참고문헌 슬롯은 사용자가 구성한 bibliography content를 그대로 받아야 합니다.],
  abstract-en: [The bibliography slot should pass through user-owned bibliography content.],
  bibliography: bibliography(path("/template/bibliography/references.bib"), style: "chicago-author-date", title: none),
)

= 본문

참고문헌 슬롯 검증을 위해 @platt1964strong 을 인용합니다.

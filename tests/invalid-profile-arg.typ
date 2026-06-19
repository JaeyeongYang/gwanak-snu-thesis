// Expected compile failure: profile is not a public option.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  profile: "official",
  degree: "bachelor",
  title: [프로필 인수 예시],
  title-alt: [Profile argument fixture],
  author: "홍길동",
  student-number: "2026-00010",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  abstract-ko: [profile 인수 실패 fixture입니다.],
  abstract-en: [Profile argument fixture.],
)

= 본문

이 문서는 컴파일에 실패해야 합니다.

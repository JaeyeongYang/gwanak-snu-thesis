// Expected compile failure: degree must be bachelor, master, or phd.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "under",
  title: [지원하지 않는 학위 예시],
  title-alt: [Unsupported degree fixture],
  author: "홍길동",
  student-number: "2026-00005",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  abstract-ko: [지원하지 않는 학위 값을 확인하는 국문초록입니다.],
  abstract-en: [This fixture verifies that unsupported degree values are rejected.],
)

= 본문

이 문서는 컴파일에 실패해야 합니다.

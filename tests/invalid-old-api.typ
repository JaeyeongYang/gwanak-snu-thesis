// Expected compile failure: language, bibliography-file, and bibliography-style are removed API names.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  language: "ko",
  degree: "master",
  title: [이전 API 예시],
  title-alt: [Old API fixture],
  author: "홍길동",
  student-number: "2026-00009",
  advisor: "김지도",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "박위원장",
    vice-chair: "이부위원장",
    members: (),
  ),
  abstract-ko: [이전 API 실패 fixture입니다.],
  abstract-en: [Old API fixture.],
  bibliography-file: path("/template/bibliography/references.bib"),
  bibliography-style: "apa",
)

= 본문

이 문서는 컴파일에 실패해야 합니다.

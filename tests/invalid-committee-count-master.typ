// Expected compile failure: master committees must not include non-advisor members.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "master",
  title: [잘못된 석사 위원 수],
  title-alt: [Invalid master committee count],
  author: "홍길동",
  student-number: "2026-00006",
  advisor: "김지도",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "박위원장",
    vice-chair: "이부위원장",
    members: ("초과위원",),
  ),
  abstract-ko: [석사 위원 수 실패 fixture입니다.],
  abstract-en: [Invalid master committee count fixture.],
)

= 본문

이 문서는 컴파일에 실패해야 합니다.

// Expected compile failure: advisor cannot duplicate a committee signer.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "master",
  title: [지도교수 중복 예시],
  title-alt: [Advisor overlap fixture],
  author: "홍길동",
  student-number: "2026-00008",
  advisor: "김지도",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "김지도",
    vice-chair: "이부위원장",
    members: (),
  ),
  abstract-ko: [지도교수 중복 실패 fixture입니다.],
  abstract-en: [Advisor overlap fixture.],
)

= 본문

이 문서는 컴파일에 실패해야 합니다.

// Expected compile failure: school-ko must not include renderer-owned 서울대학교.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  cover-language: "ko",
  degree: "bachelor",
  school-ko: "서울대학교 대학원",
  school-en: "Graduate School of Engineering",
  title: [중복 학교명 예시],
  title-alt: [Duplicate university fixture],
  author: "홍길동",
  student-number: "2026-00000",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  abstract-ko: [국문초록.],
  abstract-en: [English abstract.],
)

= 본문

이 fixture는 `school-ko`에 고정 학교명을 넣으면 실패하는지 확인합니다.

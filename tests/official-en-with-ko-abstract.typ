#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "en",
  cover-language: "en",
  approval-language: "ko",
  degree: "master",
  academic-ko: "공학",
  academic-en: "Engineering",
  school-ko: "대학원",
  school-en: "Graduate School of Engineering",
  major-ko: "컴퓨터공학부",
  major-en: "Computer Science and Engineering Major",
  title: [English Primary Thesis Title],
  title-alt: [국문 병기 논문 제목],
  author: "Jane Student",
  author-display: "Jane Student",
  student-number: "2026-00004",
  advisor: "Kim Advisor",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "Park Chair",
    vice-chair: "Lee Vice Chair",
    members: (),
  ),
  abstract-ko: [영문 본문 논문에서 뒤쪽 국문초록 경로를 확인합니다.],
  abstract-en: [This fixture verifies an English body, English-primary cover, and Korean approval page.],
  keywords-ko: ("영문", "국문초록"),
  keywords-en: ("english", "korean abstract"),
)

= Introduction

English body fixture.

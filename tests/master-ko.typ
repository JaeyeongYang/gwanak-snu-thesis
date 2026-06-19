#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  body-language: "ko",
  degree: "master",
  academic-ko: "심리학",
  academic-en: "Psychology",
  school-ko: "대학원",
  school-en: "Graduate School of Social Sciences",
  major-ko: "심리학과 심리학 전공",
  major-en: "Psychology Major",
  title: [한국어 석사 학위논문 예시],
  title-alt: [Minimal Korean master's thesis fixture],
  author: "홍길동",
  author-display: "홍 길 동",
  student-number: "2022-54321",
  advisor: "김지도",
  advisor-display: "김 지 도",
  grad-date-ko: "2026년 2월",
  grad-date-en: "February 2026",
  submission-date: "2025년 12월",
  approval-date: "2026년 1월",
  committee: (
    chair: "박위원장",
    vice-chair: "이부위원장",
    members: (),
  ),
  abstract-ko: [석사 승인 페이지 분기를 확인하기 위한 최소 국문초록입니다.],
  abstract-en: [A minimal English abstract for the Korean master's fixture.],
  keywords-ko: ("석사", "검증"),
  keywords-en: ("master", "fixture"),
  bibliography: bibliography(path("/template/bibliography/references.bib"), style: "apa", title: none),
)

= 본문

석사 학위논문 본문 예시입니다. 승인 페이지와 참고문헌 출력을 함께 확인하기 위해 @platt1964strong 을 인용합니다.

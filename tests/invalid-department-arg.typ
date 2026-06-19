// Expected compile failure: department-ko and department-en were renamed to major-ko and major-en.
#import "/lib.typ": snu-thesis

#show: snu-thesis.with(
  draft: true,
  department-ko: "컴퓨터공학부",
  department-en: "Computer Science and Engineering Major",
)

= 본문

이 fixture는 제거된 department 계열 compatibility path가 남아 있지 않은지 확인합니다.

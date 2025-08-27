# dAiry - iOS
> Supabase + GPT API 기반 감사 일기 작성 앱

![dAiry](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-FA7343?style=flat-square&logo=swift&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)
![OpenAI](https://img.shields.io/badge/OpenAI_GPT-412991?style=flat-square&logo=openai&logoColor=white)

## 📋 프로젝트 개요

현대인들이 바쁜 일상 속에서 놓치는 작은 행복과 감사함을 기록하고, AI 캐릭터와의 상담을 통해 긍정적인 마음가짐을 기를 수 있도록 개발된 감사 일기 작성 앱입니다.

### 개발 목적
- 매일 3가지 감사한 일을 기록하여 긍정적 사고 패턴 구축
- GPT 기반 캐릭터와의 대화를 통한 심리적 지원
- Supabase를 활용한 안전하고 실시간적인 데이터 관리
- 직관적이고 아름다운 사용자 인터페이스 제공

## 🍀 개발자
| 성규현 [@dmp100](https://github.com/dmp100) |
|:---:|
| <img width="150" src="https://github.com/user-attachments/assets/daa04602-4d2d-456e-a11b-0c97509ea0c1"/> |

## 📱 스크린샷
| 일기작성 | 채팅 | 리스트 |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/9a34f534-c671-47ef-a158-8c9aa63d491c"/> | <img width="200" src="https://github.com/user-attachments/assets/02a97857-11c7-4bd2-bd78-38bdb2197024"/> | <img width="200" src="https://github.com/user-attachments/assets/9e60302e-7c0e-4f86-8d1d-bb14c2878aa6"/> |

| 프로필 | 로그인 | 회원가입 |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/be5bfb46-16f3-4bb3-ab1f-fb4e7b66592a"/> | <img width="200" src="https://github.com/user-attachments/assets/bd0f0f3e-faa9-414e-92b8-a6cfec7b6db5"/> | <img width="200" src="https://github.com/user-attachments/assets/825215fb-e2e6-4526-aef1-4bfd5ad91256"/> |

## ✨ 주요 기능

### 🔐 사용자 인증 시스템
#### 로그인 화면 (LoginViewController)
- 이메일과 비밀번호 기반 로그인
- Supabase Auth를 통한 사용자 인증 처리
- 자동 로그인 상태 유지 (세션 관리)
- 회원가입 화면으로 전환 기능
- 입력 유효성 검사 및 에러 메시지 표시

#### 회원가입 화면 (SignUpViewController)
- 이메일과 비밀번호로 신규 계정 생성
- 실시간 입력 값 검증 (이메일 형식, 비밀번호 조건)
- Supabase Auth 연동 회원가입 처리
- 가입 완료 후 자동 로그인 처리

### 🌱 감사 일기 작성 시스템
#### 홈 화면 (HomeViewController)
- 현재 날짜 및 요일 표시 (실시간 업데이트)
- 3개의 독립적인 텍스트뷰로 감사한 일 입력
- 각 입력창별 50자 제한 및 실시간 글자 수 표시
- 동적 플레이스홀더 관리 ("오늘 감사한 일을 적어주세요")
- Supabase 실시간 저장 및 데이터 유효성 검증
- 이미 작성된 일기 불러오기 및 수정 기능
- 저장 성공/실패 피드백 메시지

### 🤖 AI 캐릭터 상담 서비스
#### 채팅 캐릭터 선택 화면 (ChatViewController)
- 3가지 AI 캐릭터 카드형 인터페이스
  - **사쿠라 🌸**: 따뜻하고 공감적인 감정 상담사
  - **올빼미 박사 🦉**: 논리적이고 현명한 심리 상담사
  - **토끼 🐰**: 활발하고 긍정적인 에너지 상담사 (준비중)
- 각 캐릭터별 특성 및 상담 스타일 설명
- 선택한 캐릭터로 채팅방 진입

#### AI 상담 채팅 화면 (ChatDetailViewController)
- 실시간 채팅 인터페이스 (말풍선 UI)
- OpenAI GPT-4 API 연동 자연어 처리
- 당일 작성된 감사일기 내용 기반 개인화된 대화 시작
- 메시지 전송 시 로딩 인디케이터 표시
- 채팅 히스토리 자동 스크롤 관리
- 사용자/AI 메시지 구분된 디자인
- 캐릭터별 맞춤형 응답 톤앤매너

### 📊 일기 관리 및 조회 시스템
#### 목록 화면 (ListViewController)
- 달력 기반 날짜 선택기 (UIDatePicker)
- 선택된 날짜의 감사일기 3개 항목 표시
- 일기가 없는 날짜 선택 시 "일기 없음" 상태 처리
- 과거 일기 검색 및 열람 기능
- 좌측 컬러 보더를 통한 시각적 구분
- 날짜별 일기 존재 여부 실시간 확인

### 📈 사용자 통계 및 프로필
#### 프로필 화면 (ProfileViewController)
- 사용자 이메일 정보 표시
- 감사일기 작성 관련 통계
  - 총 감사일기 작성 개수 (실시간 카운트)
  - 연속 작성일 추적 및 표시
  - 첫 감사일기 작성일부터 경과 일수
- 그라데이션 배경 디자인 적용
- 로그아웃 기능
- 계정 정보 관리

### 🎨 공통 UI/UX 기능
- Pretendard 폰트 적용으로 한글 가독성 최적화
- 브랜드 컬러(#34C759) 기반 일관된 디자인 시스템
- Auto Layout 기반 반응형 레이아웃 (다양한 화면 크기 지원)
- 부드러운 전환 애니메이션 및 사용자 피드백
- 그라데이션 및 그림자 효과를 통한 모던한 UI
- 키보드 자동 숨김 처리 (화면 탭 시)

## 🔧 기술 스택
| **Category** | **Technology** | **Purpose** |
|:---:|:---:|:---:|
| **Language** | Swift 5.0+ | iOS 네이티브 앱 개발 |
| **UI Framework** | UIKit + Storyboard | 사용자 인터페이스 구축 |
| **Architecture** | MVC Pattern | 코드 구조 및 관심사 분리 |
| **Backend** | Supabase | 실시간 데이터베이스 및 사용자 인증 |
| **AI Integration** | OpenAI GPT-4 API | 자연어 처리 기반 챗봇 상담 |
| **Font** | Pretendard | 한글 최적화 타이포그래피 |

## 🏗️ 프로젝트 구조

### 데이터베이스 구조 (Supabase)
```
gratitude_diaries 테이블
├── id: BIGINT (Primary Key)
├── user_id: VARCHAR (사용자 UUID)
├── content: TEXT (감사 내용)
├── created_at: TIMESTAMPTZ (작성 시간)
└── updated_at: TIMESTAMPTZ (수정 시간)

users 테이블 (Supabase Auth)
├── id: UUID (Primary Key)
├── email: VARCHAR (이메일)
├── created_at: TIMESTAMPTZ
└── updated_at: TIMESTAMPTZ
```

### 폴더 구조
```
📂 IosStoryBoard
┣ 📂 IosStoryBoard
┃ ┣ 📄 AppDelegate.swift              # 앱 생명주기 및 Supabase 초기화
┃ ┣ 📄 SceneDelegate.swift            # 씬 생명주기 관리
┃ ┣ 📄 Model.swift                    # 데이터 모델 정의
┃ ┣ 📄 Character.swift                # AI 캐릭터 모델
┃ ┣ 📄 LoginViewController.swift      # 로그인 화면
┃ ┣ 📄 SignUpViewController.swift     # 회원가입 화면
┃ ┣ 📄 HomeViewController.swift       # 감사일기 작성 메인 화면
┃ ┣ 📄 ChatViewController.swift       # AI 캐릭터 선택 화면
┃ ┣ 📄 ChatDetailViewController.swift # AI 상담 채팅 화면
┃ ┣ 📄 ListViewController.swift       # 일기 목록 및 검색 화면
┃ ┣ 📄 ProfileViewController.swift    # 사용자 프로필 및 통계 화면
┃ ┣ 📄 UIFont.swift                   # Pretendard 폰트 익스텐션
┃ ┣ 📂 Base.lproj
┃ ┃ ┣ 📄 Main.storyboard             # UI 스토리보드
┃ ┃ ┗ 📄 LaunchScreen.storyboard     # 런치 스크린
┃ ┣ 📂 Assets.xcassets               # 이미지 및 색상 리소스
┃ ┣ 📂 Fonts                         # Pretendard 폰트 파일들
┃ ┣ 📂 Images                        # 추가 이미지 리소스
┃ ┗ 📄 Info.plist                    # 앱 설정 정보
┗ 📂 IosStoryBoard.xcodeproj          # Xcode 프로젝트 파일
```

## 📗 참고 자료
- [iOS 개발 가이드](https://developer.apple.com/kr/ios/)
- [Supabase 문서](https://supabase.com/docs)
- [OpenAI API 문서](https://platform.openai.com/docs)
- [Xcode GitHub 연동 방법](https://brunch.co.kr/@ziinup/32)

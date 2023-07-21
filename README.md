# Unsplash_MVVMClean
전 세계 사진작가들의 고화질의 이미지를 제공하는 Unsplash앱의 API를 활용하여 클론코딩한 앱입니다.

## 목차
- [기능](#기능)
- [브랜치별 사용 기술 및 핵심 구현 내용](#브랜치별-사용-기술-및-핵심-구현-내용)

## 기능

---
### | 사진 목록 화면


| Scroll | Animation | Refresh |
|:---:|:---:|:---:|
| <img src = "/Images/ListView/ListViewPrefetching.gif" title="ListView"> | <img src = "/Images/ListView/ListViewAnimation.gif" title="ListView Animation"> | <img src = "/Images/ListView/ListViewRefresh.gif" title="ListView Refresh"> |
| 사진 목록을 가져와 세로로 스크롤할 수 있습니다. <br> 스크롤이 마지막에 도달하면 다음 사진 목록을 받아옵니다. | 사진 목록에서 하단으로 스크롤 할 시 하단 탭바를 숨깁니다. <br> 상단으로 스크롤 시 다시 하단 탭바가 나타납니다. | 사진 목록 최상단에서 상단 스크롤 시 사진 목록을 새로 받아옵니다. |

<br>
</br>

---------
### | 사진 상세 화면

| Animation | Scroll |
|:---:|:---:|
| <img src = "/Images/DetailView/DetailViewAnimation.gif" title="DetailView Animation"> </p> | <img src = "/Images/DetailView/DetailViewScrollToItem.gif" title="DetailView Scroll"> |
| 우측 상단의 공유 버튼을 눌러 사진을 공유할 수 있습니다. <br> 상세 사진을 하단으로 스와이프 시 사진 상세화면에서 빠져나와 이전 사진 목록 화면을 보여줍니다. | 사진 상세화면에서 가로로 스크롤 시 다음 / 이전 사진의 상세화면으로 넘어갑니다. |

<br>
</br>

---------
### | 로그인 Tab

| Login | SignUp | ResetPassword | Warning |
|:---:|:---:|:---:|:---:|
| <img src = "/Images/LoginTab/LoginDefault.png" title="LoginView" width="98%"> | <img src = "/Images/LoginTab/LoginSignup.png" title="SignUp" width="92%"> | <img src = "/Images/LoginTab/LoginReset.png" title="ResetView" width="75%"> | <img src = "/Images/LoginTab/LoginUnderLineTextField.png" title="UnderLineTextField" width="90%"> |
| 로그인 화면입니다. 각 버튼을 누르면 회원가입 화면 혹은 비밀번호를 리셋하는 화면으로 전환합니다. | 회원가입 화면입니다. | 비밀번호를 리셋하는 화면입니다. <br> 이메일 주소를 적으면 해당 이메일로 초기화한 패스워드를 발송합니다. | 로그인 탭의 모든 뷰에서 텍스트필드가 비어있는 채로 버튼을 누르면 비어있는 텍스트필드에 붉은 표시를 하고 경고문구가 띄워집니다. |

<br>
</br>

---------
### | 사진 검색 화면
<br>
</br>

| <img src = "/Images/SearchView/SearchView_compositional.gif" title="SearchView"> | 상단에는 사진 검색 바가 위치하고 검색 바를 클릭 시 검색어를 입력할 수 있고 우측에 취소버튼이 생성됩니다. <br> 하단에는 가로로 스크롤하는 `Category`, 세로로 스크롤하는 `Discover`라는 섹션이 존재합니다. |
|---|---|
<br>
</br>

---------
### | 검색 결과 화면
<br>
</br>

| <img src = "/Images/SearchView/SearchResultView.gif" title="SearchResultView"> | 검색 수행 시 검색 결과를 `Photos`, `Collections`, `Users` 탭으로 각각 나누어 보여줍니다. <br> 취소버튼 클릭 시 사진 검색 화면의 초기 화면으로 돌아옵니다. |
|---|---|
<br>
</br>

---------
## 브랜치별 사용 기술 및 핵심 구현 내용

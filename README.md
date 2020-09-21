# GIPHY Project

## 프로젝트 설계

* 주요 화면
  * 검색 화면
  * 즐겨찾기 화면 
  * 랜덤 화면 (추가 화면이고, [random API][random] 이용해서 기능 구현할 예정)

* 아키텍처 패턴 : ReactorKit
  * 이유 :  RxSwift 입문자가 적용하기 좋은 아키텍처 패턴이고, Rx를 좀 더 선언적으로 사용하기에 좋은 패턴이다.

* 의존성 관리자: Carthage
  * 이유: 추가한 의존성들은 prebuild 되기 때문에 빌드속도가 빠르다. 
  * Carthage로 사용할 수 없는 라이브러리는 SPM이나 Cocoapod을 사용한다.  

* 라이브러리
  * ReactorKit
  * RxSwift
  * Alamofire
    * 데이터 fetch 해서 decode 하는 것과 에러 타입이 잘 구현되어 있어서 사용함 
  * Kingfisher
    * 이미지 캐시하는데 사용할 것, gif 동적 이미지 적용하는데 사용함
  * SnapKit 
    * 오토레이아웃 설정하는데 사용함
  * Then
    * 객체 설정하는 것에 가독성을 높이기 위해 사용함
  * SwiftLint
    * 정적 분석 도구. 가독성을 높이기 위해 사용함 

* 접근성 고려하기 
  * UIControl 제대로 사용하기
  * Accessibility Inspector로 큰 사이즈의 폰트도 표현 가능한지 확인하기
  * Accessibility Inspector에서 Voice Over 방식으로 앱 둘러보기 
  * 접근성을 고려해 UITest가 쉬워지도록 하자

* 테스트 코드 작성 
  * ReactorKit의 Reactor 객체 Unit Test 코드 작성 
  * UITest 코드 작성

* 다크 모드 지원
  * 시간이 된다면 다크 모드를 고려하자. 

* 이미지 캐싱 정책 
  * 메모리 캐시: 검색 화면에서 검색하지 않을 때 [trend API][link] 의 이미지를 메모리 캐싱한다.
  * 디스크 캐시: 즐겨찾기의 gif 데이터는 디스크 캐시한다.

## Ground Rule 

### 브랜치 규칙 

* `master`: 최종 브랜치 - 토요일 자정 이전 최종 브랜치
* `dev`: 디폴트 브랜치
* `feature/xxx`: 기능 브랜치
  * `feature/xxx/issue-yyy`: 기능의 한 이슈 브랜치 

### 커밋 메시지 규칙 

```
[#36] feat: something something...

- description....
```

```
feat: (new feature for the user, not a new feature for build script)
fix: (bug fix for the user, not a fix to a build script)
docs: (changes to the documentation)
style: (formatting, missing semi colons, etc; no production code change)
refactor: (refactoring production code, eg. renaming a variable)
test: (adding missing tests, refactoring tests; no production code change)
chore: (updating grunt tasks etc; no production code change)
```





[random]: https://developers.giphy.com/docs/api/endpoint#random
[link]: https://developers.giphy.com/docs/api/endpoint/#trending

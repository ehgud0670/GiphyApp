# GIPHY Project

## 시작 전 프로젝트 설계

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
  * `issue-xxx`: 이슈로 기준으로 한 기능 브랜치 

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

# 완성 후 리드미 작성 

## 사용한 아키텍쳐와 라이브리리, 사용한 이유

> 사용한 아키텍쳐

* 검색 페이지
  * MVVM 패턴
  * 사용한 이유: 테이블 뷰 있는 화면은 ViewModel 객체를 만들어 다른 화면에서도 재사용하려고 MVVM 패턴을 적용하였습니다. VM 객체는 Vieless하여 테스트하기 좋습니다. 현재 VC에 네트워크 객체가 있지만, 다음에는 뷰모델에 네트워크 객체를 의존성 주입해보고 싶습니다.

* 즐겨찾기 페이지
  * MVC 패턴
  * 사용한 이유: VC가 CoreData에 의존성이 많은 상황(ex. VC가 NSFetchedResultsControllerDelegate의 역할로 해야합니다)이기에
  MVC 패턴을 적용하였습니다. 이상적으로 떼어낼 수 있다면 다른 패턴을 사용해보고 싶습니다.

* 랜덤 페이지( 추가 페이지 )
  * MVC 패턴
  * 사용한 이유: 뷰가 단순할때는 MVC패턴이 빠르고 한눈에 보기에도 좋다고 생각해 MVC패턴을 적용하였습니다.

> 사용한 라이브러리 

* RxSwift, RxCoCoa: 체이닝 방식으로 빠르게 기능 개발할 수 있고, 코드의 응집성이 매우 좋아져서 사용하였습니다. #함수형, #반응형, #강력한 operator  
* Then, SnapKit: 클로저로 해당 객체의 속성이나 레이아웃 적용할 수 있어 가독성이 좋아지는 이유 때문에 사용하였습니다.
* Kingfisher: Kingfisher의 ImageCache 객체를 이용해 메모리캐시 하기 위해 사용하였습니다. ImageCache의 크기나 클린 주기가 정해져있고 캐시와 관련된 메소드가 구현되어 있어 사용하기 편리했습니다.   
* Alamofire: 네트워크 응답받아서 모델 객체로 디코드하는 것까지 하기 위해 사용하였습니다. 또 AFError로 편리하게 에러 처리하기 위해 사용하였습니다. 
* SwiftLint: 정석 분석기로서 코드의 포맷을 잘 맞춰줍니다. Github Swift 스타일 가이드대로 코드를 작성하기 위해 사용하였습니다.  

## 각 기능의 최소 기능, 제한 사항에 O, X 표시하기

> 검색 페이지 

* 기본 기능
  * Giphy API를 이용해 정적인 GIF 이미지를 검색할 수 있습니다. => O, **추가 기능인 동적 이미지로 대체**
    *  상단 [검색하기] 텍스트필드가포커스 되면 키보드가 보여지도록합니다. 이
키보드는 스크롤뷰를스크롤했을때, 키보드의 엔터를 쳤을 때 내려가도록
합니다. => O
  * 영단어를 입력했을 때 마다 검색 API를 호출하도록합니다. => O
  * 검색 필드에 빈 텍스트가 입력되어 있다면 빈 화면을 보여줍니다. => O, **추가 기능인 Trend API를 이용해 트렌디한 이미지를 무한 스크롤 하는 것으로 대체** 
  *  페이징을 이용해 API의 최대로 조회 가능한 이미지 갯수 (limit = 24) 만큼 불러 온 후, 리스트 최하단에 <더보기> 버튼 을 두어, 이후의 더 많은 이미지를 불러 올 수 있도록 합니다. => O, **추가 기능인 무한 스크롤로 대체**
  * 각 이미지는 누를 수 있습니다. 누를 경우 Modal이 뜹니다. => O 

* 추가 기능
  * 정적인 GIF 이미지를 동적으로 움직이도록해주세요. => O
  * 무한 스크롤을 적용하여 끊임 없이 이미지가 로드될 수 있도록 해주세요. => O
  * 검색어가 입력되지 않았다면 trend API를 이용하여 최신 트렌드 GIF를 기본적으로 리스팅할 수 있도록 합니다. => O
  * 이미지가 로딩될 때 placeholder 이미지를 넣어주세요. => O
  * 네트워크 에러 등에 의해 API 통신이 불가능한 경우 Alert 등으로 사용자에게 안내 해주세요. => O

* 제한(필수) 사항 모두 만족하였습니다. 

> 즐겨찾기 페이지

* 기본 기능
  * 내가 즐겨찾기 한 이미지를 볼 수 있습니다. => O
  * 각 이미지는 누를 수 있습니다. 누를 경우 Modal이 뜹니다. => O

* 추가 기능
  * 정적인 GIF 이미지를 동적으로 움직이도록해주세요. => O
  * 즐겨찾기 한 내용이 없을 때 빈 화면을 효과적으로유저에게 커뮤니케이션해주세요. => O
  * 앱을 종료하더라도 Local Storage (UserDefault, CoreData, Realm 등) 을 이용하여 휘발되지 않도록 구현해주세요. => O, CoreData 사용하였습니다.
  * 가장 최근에 즐겨찾기한 이미지가 최상단에 보일 수 있도록 해주세요 => O
  * 이미지가 로딩될 때 placeholder 이미지를 넣어주세요. => O

* 제한(필수) 사항 모두 만족하였습니다. 

> Modal 페이지

* 기본 기능
  * Modal 로 보여집니다. => O
  * 정적인 이미지와 관련 정보 (이름, rate 등) 텍스트를 보여줄 수 있습니다. => O, **동적인 이미지로 대체** 
  * 타인에게 이미지 주소와 이름 (혹은 이미지 파일 자체)을 공유할 수 있는 버튼을 포함합니다. => O
  * 별 표시 버튼을 통해 마음에 드는 이미지를 즐겨찾기, 해제 할 수 있습니다. => O

* 추가 기능
  * 정적인 GIF 이미지를 동적으로 움직이도록해주세요. => O
  * 이미지가 로딩될 때 placeholder 이미지를 넣어주세요. => O

* 제한(필수) 사항 모두 만족하였습니다. 

## 추가한 기능 

> 랜덤 페이지

* 텍스트필드 값 기준으로 랜덤한 gif 불러오는 기능
  * 클릭! 버튼을 누를때 request를 보내고 데이터를 받는다. 
* 공유 기능 구현 

![random vc](https://user-images.githubusercontent.com/38216027/94283708-52549280-ff8c-11ea-83ad-7faf81459040.gif)

## 그리고 가장 재밌었던 것

* 이미지 다운 사이징하기: 이 [블로그][memory]를 보고 이미지를 다운사이징 할 수 있었습니다. 가져온 이미지를 결국 그려질 이미지뷰의 픽셀만큼만의 크기로 다운사이징하면 메모리를 효율적으로 관리할 수 있다는 아이디어가 재밌었고, 실제로 적용하니 더 재밌었습니다. 적용 전에는 디바이스(6s+)로 메모리 문제로 인한 이슈로 크래시가 많이 났는데 적용 후에는 그러지 않기 때문입니다. ( 관련 pr: https://github.com/ehgud0670/Banksalad_iOS_KimDoeHyung/pull/20) 

* 동적 이미지 만들기: 원래는 Kingfisher로 이미지를 가지고 와서 셀에 입혀줬지만 애니메이션이 적용되는 이미지가 있고, 적용안되는 이미지가 있는 문제가 있었습니다. 때문에 CG 객체들을 이용해 직접 동적 이미지를 만들어 셀에 적용해 이 문제를 해결하였습니다. ( 관련 pr: https://github.com/ehgud0670/Banksalad_iOS_KimDoeHyung/pull/21)  

## 제출기간 이후 리드미 작성 

### 문제점 보완한 점 

## 1. qos 의 성격에 맞지 않게 디스패치 큐를 사용한 점을 수정함 
 
이전에 TextField 입력 관련 코드는 디스패치 큐로 qos가 userInitiated인걸 사용하고, Networking 성격의 코드에서는 디스패치 큐로 qos가 userInteractive 인 걸 사용했습니다. 순전히 우선순위에 맞게 더 빨리 작동시키기 위해 이렇게 코드를 작성했지만, 계속 생각해보니 전혀 성격에 맞게 사용하지 않은 코드라 TextField 입력 관련 코드는 qos를 userInteractive로, 
Networking 관련 코드는 qos를 utility로 수정하였습니다. [관련 커밋][commit_1]

## 2. 스크롤하면 지나간 셀의 이미지 로드 및 이미지 처리 작업 중인던걸 취소하고, 다음 작업 진행되도록 수정함   

그 전 코드는 이미지를 로드하는 작업을 취소하지 않아 스크롤을 많이 하면 지나쳤던 모든 셀의 이미지를 로드해야 했기 때문에 (기다리느라) **지금 당장의 셀에 이미지가 바로 반영되지 않는 문제점**과 모든 이미지를 로드해야 했기 때문에 과도한 메모리 사용으로 **앱이 크래시 나는 문제점**이 발생하였습니다. 따라서 지나간 셀의 이미지 로드는 **취소**시킴으로써 현재 보이는 셀의 이미지를 빨리 로드해 보이도록 하고, 메모리로 인한 크래시(비교적 훨씬 적게)도 없도록 하게 하였습니다. [관련 커밋][commit_2]

* 이전 코드의 메모리 측정 

<img width="305" alt="cancel_Before" src="https://user-images.githubusercontent.com/38216027/94915751-61859400-04e8-11eb-9ba8-d8ed0fc8c3f3.png">

=> 그리곤 바로 앱이 크래시 되었습니다. 

* 코드 수정 후의 메모리 측정

<img width="306" alt="cancel_After" src="https://user-images.githubusercontent.com/38216027/94915820-85e17080-04e8-11eb-9aa3-e1f0dc6a0b7b.png">

## 3. fetchedResultController의 cacheName을 nil 처리함으로써 즐겨찾기 데이터가 모두 셀로 반영되도록 수정함

이전까지 fetch할때 cache 이름으로 미리 로드된 데이터를 반영하였기 때문에
**해당 cache로 저장되지 않은 즐겨찾기 데이터는 바로 반영되지 않는 문제가 있었습니다.**
따라서 fetch할때 cache 이름을 nil 처리함으로써  캐시가 적용 안된 데이터도 
가져오도록 하여 **모든 즐겨찾기 데이터가 즐겨찾기 페이지에 보이도록 하였습니다.**
[관련 커밋][commit_3]

[random]: https://developers.giphy.com/docs/api/endpoint#random
[link]: https://developers.giphy.com/docs/api/endpoint/#trending
[memory]: https://sungdoo.dev/programming/imag-and-memory-footprint/ 
[commit_1]: https://github.com/ehgud0670/Banksalad_iOS_KimDoeHyung/commit/7e290a0796c172bb2c1ae5e7d64b166c6ce75326
[commit_2]: https://github.com/ehgud0670/Banksalad_iOS_KimDoeHyung/commit/3e5dc2f9161504d4e848b905671a8e83c60b483b
[commit_3]: https://github.com/ehgud0670/Banksalad_iOS_KimDoeHyung/commit/986c88c6a6e3c2f6806b7c9761abcb50725a249e
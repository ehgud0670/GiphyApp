# GiphyApp

## 앱 소개 

[Giphy API][giphy_api]를 이용해 gif 이미지들을 보여주는 앱입니다. 화면은 홈 화면, 즐겨찾기 화면, 랜덤 화면, 상세(모달)화면이 있습니다. 

* 홈 화면 
  
  ![홈](https://user-images.githubusercontent.com/38216027/95969690-05a4fe80-0e4a-11eb-94d9-b25247a05188.gif)
 
  * Gif 이미지를 서버로부터 가져와 보여줍니다. 검색하지 않는 경우 [Trend API][trend_api]를 이용해 gif 이미지를 가져오고, 검색하는 경우 한 글자씩 입력할 때마다, [Search API][search_api]를 이용해 gif 이미지를 가져옵니다.
  * 이미지를 클릭하면 상세(모달)화면이 떠오릅니다. 상세(모달)화면으로 해당 gif를 공유하거나 즐겨찾기 할 수 있습니다. 

* 즐겨찾기 화면

  ![즐겨](https://user-images.githubusercontent.com/38216027/95969849-35ec9d00-0e4a-11eb-84d5-d567798a9a63.gif)

  * 사용자의 즐겨찾기 Gif 이미지들을 보여주는 화면입니다. **CoreData**를 사용해 앱을 껏다 다시 켜도 즐겨찾기 데이터가 유지되도록 하였고, 즐겨찾기 추가 및 삭제가 실시간으로 반영되도록 하였습니다. 
  * 즐겨찾기 이미지가 없는 경우 레이블을 이용해 사용자에게 데이터가 없음을 가이드합니다. 

* 랜덤 화면 

  ![랜덤](https://user-images.githubusercontent.com/38216027/95970296-bf9c6a80-0e4a-11eb-88c4-f82faa3c3e7c.gif)

  * [Random API][random_api] 를 이용해 랜덤하게 gif를 보여주는 화면입니다. 
  * 텍스트를 입력하면 텍스트 관련 gif를 랜덤하게 골라 보여줍니다. 
  * 공유 기능이 있습니다. 

* 상세(모달) 화면

  ![상세](https://user-images.githubusercontent.com/38216027/95970585-17d36c80-0e4b-11eb-95fe-df7f9f27ddbe.gif)

  * 셀을 클릭하면 나오는 화면으로, 해당 Gif 이미지의 제목도 같이 보여줍니다. 
  * 별 이미지를 누르면 해당 Gif이미지는 즐겨찾기 데이터로 추가됩니다.
  * 공유 기능이 있습니다.   

## 사용한 아키텍쳐와 이유

* 검색 페이지
  * MVVM 패턴
  * 사용한 이유: 테이블 뷰 있는 화면은 ViewModel 객체를 만들어 다른 화면에서도 재사용하려고 MVVM 패턴을 적용하였습니다. VM 객체는 Viewless하여 테스트하기 좋습니다. 

* 즐겨찾기 페이지
  * MVVM 패턴
  * 사용한 이유: CoreData의 데이터를 다루면서 뷰모델 역할을 하는 CoreDataGiphyViewModel 객체를 만들어 사용하였습니다. 즐겨찾기 화면의 셀 데이터들은 결국 CoreData의 데이터이므로, CoreData의 데이터를 다루는 객체가 해당 콜렉션 뷰 셀의 **뷰모델** 역할을 해도 된다고 판단했습니다(따라서 해당 객체가 콜렉션 뷰의 데이터소스 역할을 합니다). MVVM 패턴의 장점은 Massive 한 VC를 피할 수 있고, Viewless 한 테스트코드를 작성할 수 있다는 점이 있습니다.  

* 랜덤 페이지
  * MVC 패턴
  * 사용한 이유: 뷰가 단순할 때는 MVC 패턴이 빠르고 한눈에 보기에도 좋다고 생각해 MVC패턴을 적용하였습니다.

## 사용한 라이브러리와 이유 

* RxSwift, RxCoCoa: 체이닝 방식으로 빠르게 기능 개발할 수 있고, 코드의 응집성이 매우 좋아져서 사용하였습니다. #함수형, #반응형, #강력한 operator  
* Then, SnapKit: 클로저로 해당 객체의 속성이나 레이아웃 적용할 수 있어 가독성이 좋아지는 이유 때문에 사용하였습니다.
* Kingfisher: Kingfisher의 ImageCache 객체를 이용해 메모리캐시 하기 위해 사용하였습니다. ImageCache의 크기나 클린 주기가 정해져있고 캐시와 관련된 메소드가 구현되어 있어 사용하기 편리했습니다.   
* Alamofire: 네트워크 응답받아서 모델 객체로 디코드하는 것까지 하기 위해 사용하였습니다. 또 AFError로 편리하게 에러 처리하기 위해 사용하였습니다. 
* SwiftLint: 정석 분석기로서 코드의 포맷을 잘 맞춰줍니다. Github Swift 스타일 가이드대로 코드를 작성하기 위해 사용하였습니다.  

## 이미지 다운사이징

* 가져온 Gif 이미지들의 데이터가 너무 커서 앱이 계속 크래시나는 문제가 발생 했었습니다(디바이스는 6s+). 따라서 결국 그려질 이미지뷰의 픽셀 크기로 **Gif 이미지들을 다운사이징**하여 메모리를 효율적으로 관리해 문제를 해결할 수 있었습니다. 적용 전에는 디바이스(6s+)로 메모리 문제로 인한 이슈로 크래시가 많이 났는데 적용 후에는 크래시가 발생하지 않았습니다. ( 관련 pr: https://github.com/ehgud0670/GiphyApp/pull/20) 

## 애니메이션 이미지 직접 구현 

 * 원래는 Kingfisher로 이미지를 가지고 와서 셀에 입혀줬지만 애니메이션이 적용되는 이미지가 있고, 적용안되는 이미지가 있는 문제가 있었습니다. 때문에 CG 객체들을 이용해 직접 동적 이미지를 만들어 셀에 적용해 이 문제를 해결하였습니다. ( 관련 pr: https://github.com/ehgud0670/GiphyApp/pull/21)

 * 또 제대로 동적이미지에 제대로 frame과 duration값을 주어서 정상속도로 애니메이션이 나오도록 하였습니다. ( 관련 커밋: https://github.com/ehgud0670/GiphyApp/commit/0d6a50ab4eb31d40d8b92e0cc37b20dafc4cb7db)  

## 이미지 로드 취소 기능 구현 

 * 스크롤하면 지나간 셀의 이미지 로드 및 이미지 처리 작업 중인던걸 취소하고, 다음 작업 진행되도록 수정하였습니다.  

   * 그 전 코드는 이미지를 로드하는 작업을 취소하지 않아 스크롤을 많이 하면 지나쳤던 모든 셀의 이미지를 로드해야 했기 때문에 (기다리느라) **지금 당장의 셀에 이미지가 바로 반영되지 않는 문제점**과 모든 이미지를 로드해야 했기 때문에 과도한 메모리 사용으로 **앱이 크래시 나는 문제점**이 발생하였습니다. 따라서 지나간 셀의 이미지 로드는 **취소**시킴으로써 현재 보이는 셀의 이미지를 빨리 로드해 보이도록 하고, 메모리로 인한 크래시(비교적 훨씬 적게)도 없도록 하게 하였습니다. [관련 커밋][commit_2]

(기종: 6s+)

* 이전 코드의 메모리 측정

<img width="305" alt="cancel_Before" src="https://user-images.githubusercontent.com/38216027/94915751-61859400-04e8-11eb-9ba8-d8ed0fc8c3f3.png">

=> 그리곤 바로 앱이 크래시 되었습니다. 

* 코드 수정 후의 메모리 측정

<img width="306" alt="cancel_After" src="https://user-images.githubusercontent.com/38216027/94915820-85e17080-04e8-11eb-9aa3-e1f0dc6a0b7b.png">


## CoreData 사용

* 즐겨찾기 기능을 구현하는데 CoreData를 사용하였습니다. 

## Accessiblity 고려

### 각 레이블, 버튼, 텍스트필드의 폰트가 dynamic한 font가 되도록 설정하였고, Accessiblity Inspecter로 테스트하였습니다. 

* [관련 커밋 1][commit_7], [관련 커밋 2][commit_8]

> 검색 페이지

![dynamicFont_3](https://user-images.githubusercontent.com/38216027/95073150-4cf30700-0747-11eb-864c-ebacc0a3cb2a.gif)

> 즐겨찾기 페이지

![dynamicFont_1](https://user-images.githubusercontent.com/38216027/95072428-21235180-0746-11eb-8bb4-4c41682a9108.gif)


> 모달 페이지

![dynamicFont_2](https://user-images.githubusercontent.com/38216027/95072582-634c9300-0746-11eb-98d4-a712bd87ed4f.gif)

### Accessibility Audit을 이용하여 여러 뷰들을 수정하였습니다. 

* 일례로 Accessibility Audit을 통해 랜덤 페이지의 텍스트필드, 버튼들이 너무 작다는 진단을 받았고 크키를 키워 해결하였습니다. [관련 커밋][commit_9]

> 수정 전

<img width="1267" alt="run audit - before" src="https://user-images.githubusercontent.com/38216027/95073484-e8847780-0747-11eb-94a4-b58f752b5a1f.png">

> 수정 후 

<img width="1267" alt="run audit - after" src="https://user-images.githubusercontent.com/38216027/95073498-f0441c00-0747-11eb-9be0-3421e6ed567e.png">

# 실행화면

## 1. 홈(검색) 페이지

* 검색 하지 않은 경우, Giphy의 Trend API를 사용해 gif 이미지들을 보여줍니다. 

![Home_TrendAPI](https://user-images.githubusercontent.com/38216027/95959668-c07acf80-0e3d-11eb-9102-563d7724ad94.gif)

* 검색을 한 경우 한 글자씩 검색할 때 마다, Giphy의 Search API를 사용해 gif 이미지들을 보여줍니다.  

![Home_SearchAPI](https://user-images.githubusercontent.com/38216027/95960040-38e19080-0e3e-11eb-9f8d-7a231cd27d88.gif)

* 아래로 스크롤 하는 경우, 무한 스크롤(한번에 최대 24개 이미지)해서 gif 이미지들을 불러오도록 했습니다. 

![scroll](https://user-images.githubusercontent.com/38216027/95960863-44818700-0e3f-11eb-9fe1-2e30e8cf497d.gif)

* 네트워크 연결이 되지 않은 경우, Alert으로 사용자에게 알려주도록 했습니다.

<img width="250" alt="networkError" src="https://user-images.githubusercontent.com/38216027/95961388-ec975000-0e3f-11eb-9702-44173d65d0de.png">

## 2. 즐겨찾기 페이지

* 즐겨찾기 데이터가 없는 경우, 사용자에게 데이터 없음을 알려줍니다. 

<img width="280" alt="favorite_noData" src="https://user-images.githubusercontent.com/38216027/95963406-9e378080-0e42-11eb-851a-5cc303985826.png">

* 즐겨찾기 gif 사진을 추가할 수 있습니다. 
 
![favorite_create](https://user-images.githubusercontent.com/38216027/95963283-70ead280-0e42-11eb-9e52-160a18d4f490.gif)

* 즐겨찾기 gif 사진을 삭제할 수 있습니다. 

![favorite_delete](https://user-images.githubusercontent.com/38216027/95963015-16ea0d00-0e42-11eb-9b25-bb8ff533c1db.gif)


## 3. 랜덤 페이지

* Random API를 이용해 랜덤하게 Gif를 불러옵니다.  

![random_notext](https://user-images.githubusercontent.com/38216027/95963865-2a49a800-0e43-11eb-8ae9-c6d8459c133c.gif)

* 텍스트값이 있다면(아래의 경우 Bts), Random API를 이용해 텍스트 값으로 랜덤하게 Gif를 불러옵니다.  

![random_text](https://user-images.githubusercontent.com/38216027/95964036-5b29dd00-0e43-11eb-8766-e78fdb17d4e6.gif)

* 공유 기능이 있습니다. 

![random_share](https://user-images.githubusercontent.com/38216027/95966164-c7a5db80-0e45-11eb-8d7a-8a7f39705c47.gif)

## 4. 상세 페이지

* gif 이미지를 클릭하면 모달로 상세페이지가 떠오르고 별표를 누르면 즐겨찾기 목록에 해당 Gif가 추가됩니다.

![Home_Modal](https://user-images.githubusercontent.com/38216027/95962542-74318e80-0e41-11eb-8cb2-217c7e45eb07.gif)

* 공유 기능이 있습니다. 

![detail_share](https://user-images.githubusercontent.com/38216027/95966218-d5f3f780-0e45-11eb-99b4-423f0e057aaf.gif)

* 즐겨찾기 데이터가 20개 초과인 경우 즐겨찾기 추가를 할수 없다고 Alert을 띄우도록 했습니다.

<img width="300" alt="no_disk" src="https://user-images.githubusercontent.com/38216027/95965567-0a1ae880-0e45-11eb-9d0d-19906375491d.png">

![detail_share](https://user-images.githubusercontent.com/38216027/95966218-d5f3f780-0e45-11eb-99b4-423f0e057aaf.gif)

[giphy_api]: https://developers.giphy.com/docs/api
[trend_api]: https://developers.giphy.com/docs/api/endpoint#trending
[search_api]: https://developers.giphy.com/docs/api/endpoint#search
[kingfisher]: https://github.com/onevcat/Kingfisher 
[random_api]: https://developers.giphy.com/docs/api/endpoint#random
[commit_2]: https://github.com/ehgud0670/GiphyApp/commit/3e5dc2f9161504d4e848b905671a8e83c60b483b
[commit_7]: https://github.com/ehgud0670/GiphyApp/commit/e6768f46c579babb591cd5a7dde3cf9fe2318ee4
[commit_8]: https://github.com/ehgud0670/GiphyApp/commit/bb5374eedfe471505980bd63132f704a34c3a0f7 
[commit_9]: https://github.com/ehgud0670/GiphyApp/commit/5fb114e43ba3d3bf5caeb508685e5249e6be91b4 
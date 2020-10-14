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

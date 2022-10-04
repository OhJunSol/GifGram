# GifGram

움직이는 gif를 검색하는 앱입니다.
설정에서 레이아웃을 변경하거나, Gif를 멈출 수 있습니다.
데이터 소스는 Giphy에서 제공하는 API를 사용하였습니다. (https://developers.giphy.com/)

```
Swift + UIKit + Combine을 사용하여 MVVM 아키텍쳐로 구현하였습니다.
NSCache을 이용하여 Image caching을 구현하였습니다.
간단한 네트워크 테스트코드가 포함되어 있습니다.
Gif 재생을 위해 SwiftyGif 라이브러리를 사용했습니다. pod install을 필요로 합니다.
모든 기기에서 빌드가능합니다.
```

Screen shot

<image src="https://user-images.githubusercontent.com/112849158/191861997-ff5310e3-46bc-4cbf-a282-8cf9998196ef.png" width="200px" /><image src="https://user-images.githubusercontent.com/112849158/193775252-8df9ecbe-cc2e-42df-91c2-1ecaffebefb3.png" width="200px" /><image src="https://user-images.githubusercontent.com/112849158/191862006-93f9dc45-a9ee-4adb-8de0-7a906b7af5f2.png" width="200px" />
```
홈 화면에는 trending gif api를 이용하여 현재 자주 쓰이는 gif리스트 목록을 받아와 보여줍니다.
기본적으로 2줄 레이아웃이 적용되어있고 gif이미지들은 애니메이션이 자동으로 재생됩니다.
상단 검색창을 누르면 검색창으로 이동되고 키보드가 나옵니다. 이 키보드는 스크롤 했을 때, 검색버튼을 눌렀을 때 내려갑니다.
2초마다 자동으로 검색이 되고 검색창에 입력이 안되어있거나 text가 변경이 안되어 있는 경우는 동작하지 않습니다.
무한 스크롤과 place holder 이미지가 적용되어있습니다.
네트워크 에러가 발생했을 시 alert가 나옵니다.
```

<image src="https://user-images.githubusercontent.com/112849158/191862011-78ede78c-553c-40e6-a37a-36454c433a86.png" width="200px" /><image src="https://user-images.githubusercontent.com/112849158/191862014-d7881a3a-faef-4854-bc08-7add14498963.png" width="200px" /><image src="https://user-images.githubusercontent.com/112849158/191862793-853c841d-6336-4d4c-a4ce-f09de74b96da.png" width="200px" />

```
하단 세팅탭에서 Gif 리스트의 레이아웃 변경과 animaition 정지가 가능합니다.
```


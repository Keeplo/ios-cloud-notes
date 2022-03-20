## iOS 커리어 스타터 캠프

# 🗒 동기화 메모장 프로젝트
기간 : 2021.08.30 ~ 2021.09.17
팀원 : 개인 Marco([keeplo](https://github.com/Keeplo))

# Step 1
* 메모 리스트를 보여줄 UI 구현
  - UI를 Storyboard를 사용하지 않고 구현해보기, 객체 생성부터 위치 선정까지 코드로마 구현하는 방식 (Programmatically)
  - Size Class에 따라 다르게 표현되는 List View와 Detail View의 구성 (아이폰, 아이패드, Pro 아이폰 가로모드 등)
* 메모를 표현해 줄 Model 구현

# 📝 새롭게 알게된 개념
* **Apps Adaptive**    
  단순히 Auto Layout 적용 수준을 넘어서 다양한 기기와 기기에 Size Class에 따라 UI 구성을 다르게 해야 한다는 점을 알게 됨. 
  * **Size Class** : 기기마다 다른 화면 크기에 따라, 또는 Orientation 변화에 따라 자동으로 설정되며 아래 기준을 가지고 UI 구성의 변화를 줘야한다.
  * **Compact Size / Regular Size**
  > 이 부분을 공부할때는 SplitView를 공부하기 전 이어서 어느정도 자동으로 구현되어 있고 SizeClass 설정에 맞게 구현하면 된다는 걸 몰랐기 때문에 굉장히 걱정했다..
  > ![Uploading image.png…](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/0b101edf-10d2-47cd-a3fd-3d444a43b0f0/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210918%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210918T081237Z&X-Amz-Expires=86400&X-Amz-Signature=97e2dc7f271fd6a711ac0fa16876e4a11d56c4a39d88036756cc5260284bf61a&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22![image](https://user-images.githubusercontent.com/24707229/133881834-7b616b2d-0229-4b04-8adf-7533d9120eb1.png)
  > 

  > 관련 문서   
  > [HIG - Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)  
  > [Archive - AutoLayout Guide - SizeClass Specific Layout](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/Size-ClassSpecificLayout.html#//apple_ref/doc/uid/TP40010853-CH26-SW1)
* **Split View**  
  Regular Size 환경 화면에 대응해서 Compact Size에서 분리되었던 List-Detail 같은 계층 관계를 가진 Display를 가질 때 사용 함.  
  * **Container(SplitView) - Primary Column / (Optional) Supplementary Column / Secondary Pane column**  
    Container - Primary - (optional) Supplementary - Secondary 순서로 상위 계층을 가지고 각 View는 상위 View의 결정에 따라 변화가 있음.
  * **Display Mode** : SplitView의 Child Views를 어떻게 표현할지 정함
  * **Split Behavior** : 어떻게 SplitView르 변경할지 정함
  * **Multiple Windows** : 디바이스의 한 화면에 동시에 2개 이상의 앱을 구동시키는 기술
    Split 이라는 용어때문에 혼동이 있지만 SplitView 보다느 Scenes와 App 자체의 동기화(동시에 같은 앱 2개이상 구동) 등 다른 기능
   > 관련 문서   
  > [HIG - SplitView](https://developer.apple.com/design/human-interface-guidelines/ios/views/split-views/)  
  > [Archive - ViewController Guide - Implementing a Container View Controller](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html)
* **Internationalization and Localization**  
  국제화, 지역화 사용자의 지역 또는 사용 언어에 맞게 (디바이스 설정) 앱 내의 언어 또는 지역 설정을 변경해주는 작업
  > 관련 문서  
  > [Archive - Internationalization and Localization Guide](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LocalizingYourApp/LocalizingYourApp.html)  
  > [Documentation Localization](https://developer.apple.com/documentation/xcode/localization)

# 🤔 고민한 내용
1. UIElement를 Programmatically 방식으로 구현할 때 ViewController가 너무 복잡해지는 문제.
  
3. 앱 전반에 중요하 역할을 할 메모 Model 데이터가 어디에서 메인으로 다루어질지.

5. SplitView를 이용해서 동시에 나타나는 Child Views 간에 데이터 전달을 어떻게 할지?

7. 날짜 표시를 위한 지역화처리

<details><summary>예제코드</summary>
<div markdown="1">

```swift
let krPrice = 1290000
let usPrice = 1690
        
let formatter = NumberFormatter()
formatter.numberStyle = .currency
        
        
formatter.currencyCode = "KRW"
        
let krNumber = NSNumber(value: krPrice)
print(formatter.string(from: krNumber)!)
        
formatter.currencyCode = "USD"
        
let usNumber = NSNumber(value: usPrice)
print(formatter.string(from: usNumber)!)
```
![](https://i.imgur.com/Ld73hjA.png)

</div></details>

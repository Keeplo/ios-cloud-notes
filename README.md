## iOS 커리어 스타터 캠프

### 동기화 메모장 저장소

# 🗒 동기화 메모장 프로젝트
기간 : 2021.08.30 ~ 2021.09.17
팀원 : 개인 Marco([keeplo](https://github.com/Keeplo))

# Step 1
* 메모 리스트를 보여줄 UI 구현
  - UI를 Storyboard를 사용하지 않고 구현해보기, 객체 생성부터 위치 선정까지 코드로마 구현하는 방식 (Programmatically)
  - Size Class에 따라 다르게 표현되는 List View와 Detail View의 구성 (아이폰, 아이패드, Pro 아이폰 가로모드 등)
* 메모를 표현해 줄 Model 구현

# 구현한 요구 기능 시연
***iPhone 12 Pro Max Portrait***  
![Simulator Screen Recording - iPhone 12 Pro Max - 2021-09-18 at 19 34 52](https://user-images.githubusercontent.com/24707229/133885909-2dab14c6-717d-4348-ade8-100111879d37.gif)  

***iPhone 12 Pro Max Landscape Right***  
![ezgif com-video-to-gif-2](https://user-images.githubusercontent.com/24707229/133886470-ca114e63-fef9-4634-8ab1-fccb86479ad9.gif)

***iPad 11-inch Pro Portrait***  
![ezgif com-video-to-gif](https://user-images.githubusercontent.com/24707229/133886435-f6727672-63e0-48ac-bd31-9ce28eb62d3f.gif)

# 📝 새롭게 알게된 개념
* **Apps Adaptive**    
  단순히 Auto Layout 적용 수준을 넘어서 다양한 기기와 기기에 Size Class에 따라 UI 구성을 다르게 해야 한다는 점을 알게 됨. 
  * **Size Class** : 기기마다 다른 화면 크기에 따라, 또는 Orientation 변화에 따라 자동으로 설정되며 아래 기준을 가지고 UI 구성의 변화를 줘야한다.
  * **Compact Size / Regular Size**
  > **Note**  
  > 이 부분을 공부할때는 SplitView를 공부하기 전이라서,  
  > SplitView는 어느정도 자동으로 구현되어 있고 SizeClass 설정에 맞게 화면 구성으 변경하면 된다는 걸 몰랐기 때문에 굉장히 걱정했다.

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
  > [Documentation Locale](https://developer.apple.com/documentation/foundation/locale)

# 🤔 고민한 내용
1) UIElement를 Programmatically 방식으로 구현할 때 ViewController가 너무 복잡해지는 문제.
> 기초적으로 생각할때 사용자에게 보여질 화면은 ViewController를 가지고 있다.   
> 그런점에서 생각해보면 보여줄 화면의 구성은 ViewController가 아니라 ViewController의 Root View로 볼 수 있다.  
> 그래서 첫번째 아이디어는 ViewController의 Root View를 내가 구성한 CustomView로 바꿔버리는 거 였는 데 실패했다.   
> 고민해볼 시간과 이유를 이해 할 만한 지식이 아직 부족함을 느꼈다. 관련이슈 [질문](https://github.com/yagom-academy/ios-cloud-notes/pull/50#issue-988647918) [답변](https://github.com/yagom-academy/ios-cloud-notes/pull/50#pullrequestreview-747372339)  
> 결국 ViwController의 초기화 시점에서 Custom View를 생성해서 viewDidLoad 시점에서 RootView에 해당뷰를 addSubview 하는 형태로 구현해보았다. [참고자료](https://instabug.com/blog/creating-ui-elements-programmatically-using-purelayout/)  

<details><summary>예제코드</summary>
<div markdown="1">

```swift
class SecondaryViewController: UIViewController {
  private let secondaryView = SecondaryView()
  
  override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(secondaryView)
        NSLayoutConstraint.activate([
            secondaryView.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
```
</div></details>

> 관련 문서  
> [Article Displaying and Managing Views with a View Controller](https://developer.apple.com/documentation/uikit/view_controllers/displaying_and_managing_views_with_a_view_controller)

2) 앱 전반에 중요한 역할을 할 메모 Model 데이터가 어디에서 메인으로 다루어질지.
> 저장된 메모 리스트를 보여주기 위해서 TableView를 그려줄 배열 데이터 위치르 고민했다.  
> Storyboard에서 SplitViewController를 생성해도 default로 2개 이상의 화면이 생성되고,  
> Primary Column과 Secondary Column은 Container(SplitView)의 Subviews로 보기 때문에,
> 세 ViwController르 모두 다루는 데이터가 될 꺼라서 배열의 위치르 고민했다.  
> 일단 TableView를 그려주어야 하기때문에 Primary Column에 두었다.

3) SplitView를 이용해서 동시에 나타나는 Child Views 간에 데이터 전달을 어떻게 할지?
> TableView Delegate `func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)`을 사용해서 선택된 상황을 파악할 수 있는 데  
> 해당 데이터를 바로 Secondary Column인 DetailViewController로 주는 것보다 Container View를 거쳐야 한다는 내용을 보아서 통해서 전달하는 형태로 구현해보았다.
<details><summary>예제코드</summary>
<div markdown="1">

```swift
// MARK: - TableView Primary Column
class PrimaryTableViewDataSource: NSObject {
    typealias SelectedMemoAction = (Memo, IndexPath, Bool) -> Void
    
    private var selectedMemoAction: SelectedMemoAction?
    private var memos: [Memo] = []
    
    init(showDetailAction: @escaping SelectedMemoAction) {
        super.init()
        self.selectedMemoAction = showDetailAction
    }
}
// MARK: - TableView Delegate
extension PrimaryTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row]
        selectedMemoAction?(selectedMemo, indexPath, true)
    }
}
// MARK: - Container View
extension SplitViewController: SelectedCellDelegate {
    func showSelectedDetail(_ memo: Memo, isSelected: Bool) {
        secondaryViewController?.updateDetailView(by: memo)
        if isSelected {
            show(.secondary)
        }
    }
}
```
</div></details>

> 참고자료    
> [Documentation - SplitViewController](https://developer.apple.com/documentation/uikit/uisplitviewcontroller/)   
> ![Message Forwarding](https://user-images.githubusercontent.com/24707229/133885287-ce605b06-1bea-4d92-9533-908950a987ab.png)  
> 유튜브 [튜토리얼](https://www.youtube.com/watch?v=Gc1NSQS5lX0)

4) 날짜 표시를 위한 지역화처리  
> 사용자가 설정화면에서 사용하 언어와 지역으 1개만 설정하지 않고 1순위 2순위 ... 형태로 언어를 추가할 수 있다.  
> 일반적으로 [한글, 영어] 형태로 볼 수 있다.      
> 정확한 방법은 아니지만 내 생각엔 1순위 언어가 모국어이자 현재 지역 설정으로 볼 수 있지 않을까 생각해서,  
> 아래와 같이 1순위 언어를 가져오는 형태로 지역화를 시도해 보았다. 
  <details><summary>예제코드</summary>
<div markdown="1">  
  
```swift
static let dateformatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
    formatter.dateFormat = "yyyy. MM. dd"
    return formatter
}()
```
</div></details>

5) Summary String 만들기
> ![image](https://user-images.githubusercontent.com/24707229/133885584-537dc082-f3bc-4650-8392-98f13dcd2c7e.png)  
> 다음과 같이 요약 문장을 한 문장으로 하나 길게 모두 보여주나 Label에서 `label.lineBreakMode = .byTruncatingTail` 속성을 가지기 때문에  
> 아래처럼 문자열 처리를 생략함
 <details><summary>예제코드</summary>
<div markdown="1">

```swift
// 수정 전
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ...
        let body = memo.body
        let endIndex = body.firstIndex(of: "\n") ?? body.endIndex
        let summary: String = String(body.prefix(upTo: endIndex))
        
        cell.configure(memo.title, summary, date)
        return cell
    }
}
// 수정 후
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ...
        let summary: String = memo.body
        
        cell.configure(memo.title, summary, date)
        return cell
    }
}
```
</div></details>

# ➕ 더 공부할 내용
* ViewController Life Cycle
* App Life Cycle - Scene
* UIView - updateConstraints(), Auto Layout


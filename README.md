## iOS 커리어 스타터 캠프

# CloudNotes
## Information
* 프로젝트 기간 : 2021.09.27. ~ 2021.09.17.
* 프로젝트 인원 : 개인 Marco(@Keeplo)
* 프로젝트 소개 
    > Open API 를 이용해서 선택 지역 및 현재 위치의 날씨를 제공하는 앱
* Pull Requests
    * [Step 1](https://github.com/yagom-academy/ios-cloud-notes/pull/50)  
    * [Step 2](https://github.com/yagom-academy/ios-cloud-notes/pull/63)

### Tech Stack
* Swift 5.4
* Xcode 12.5
* iOS 14.0

## Demo
<details><summary>UML</summary><div markdown="1">
    

</div></details>
<details><summary>Demo Image</summary><div markdown="1">
    
**iPhone 12 Pro Max Portrait**

**iPhone 12 Pro Max Landscape Right**

**iPad 11-inch Pro Portrait**

</div></details>

## Troubleshootings
<details><summary> SplitView의 ChildViews 간에 데이터 전달 방법 </summary><div markdown="1">

> ContainerView(SplitViewController)
> PrimaryView(PrimaryViewController)  
> Secondary Column(SecondaryViewController)
    
구조를 가진 SplitView 형태에서 PrimaryView에서 선택된 메모를 Secondary Column인 ViewController로 데이터를 전달하는 과정을 고민함
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
직접 ChildViews (PrimaryView-SecondaryColumn) 간에 데이터를 전달하는 것보다 Container View를 거치는 형태로 위 예제코드처럼 구현함 아래 공식문서에서 Message Forwarding 자료를 참고함

> 참고자료 [Documentation - SplitViewController](https://developer.apple.com/documentation/uikit/uisplitviewcontroller/)
> 이미지


</div></details>
<details><summary> 엔티티(DataSource)의 위치 고민 </summary><div markdown="1">

> ViewController (Primary, Secondary)가 동일한 하나의 엔티티를 참조함  
> ContainerView에 위치하면 좋을지 실제로 사용할 ChildViewController에서 다뤄야 할지 고민
<details><summary>변화 과정 및 각 구현의 문제점 정리</summary>
<div markdown="1">

  **기존 위치**
  ```swift 
  // Step 1에서 List를 위한 Memo 배열 위치
  class PrimaryTableViewDataSource: NSObject {
    // ...
    private var memos: [Memo] = []
  }
  ```
  -> 문제점 : TableViewController와의 소통이 Container와 중복됨, SecondaryViewController와의 소통이 복잡함
  
  **AppDelegate에서 관리**
  ```swift
  // 첫번째 변경 아이디어 AppDelegate
  @main
  class AppDelegate: UIResponder, UIApplicationDelegate {
    var memos: [Memo] = []
  }

  // MARK: - TableView DataSource
  extension PrimaryViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memos.count
    }
  }
  ```
  -> 문제점 : 현재 앱에서 큰 문제가 되지 않지만 규모가 커진다면 Container를 벗어나 전역으로 관리하는 Resource는 좋지 않음..
  
  **DataManager**
  ```swift
  // CoreData Manager에서 해당 배열으 저장
  class MemoCoreDataManager {
    static let shared = MemoCoreDataManager()
    private var memos: [MemoData] {
  
  // MARK: - TableView DataSource
  extension PrimaryViewController {
    let coreManager MemoCoreDataManager.shared
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreManager.memos.count
    }
  }
  ```
  -> 상황에 따라 환경에 따라 다르겠지만 추후 CoreData(영구저장) 및 Cloud(동기화) 등 처리할 DataManager의 위치시킴
 
</div></details>
</div></details>

<details><summary> UML 그리기를 통해서 앱 전반의 모든 관계를 고민 </summary><div markdown="1">
    
* **Before**  
이미지  
두 ChildViews가 Container ViewController의 인스턴스를 참조하면서 집합관계와 합성관계를 동시에 가지거나, 모든 ViewController에서 의존관계가 얽혀 있음

UML을 그리고 나서 현재 구조에 문제점을 깨닫고 의존관계를 줄이는 작업을 시도함 
* **After**  
이미지  
CoreDataManager가 Data Resource 역할을 하고 각 Child ViewController에 의존관계가 되는 형태로 변경
</div></details>
//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    private var primaryViewController: PrimaryViewController?
    private var secondaryViewController: SecondaryViewController?
    private let coreManager = MemoCoreDataManager.shared
    var listResource: [MemoModel] = []
        
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        
        primaryViewController = PrimaryViewController(rootDelegate: self)
        secondaryViewController = SecondaryViewController(rootDelegate: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
        
        self.delegate = self
        primaryViewController?.rootViewDelegate = self
        secondaryViewController?.rootViewDelegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - Communication from Primary View
extension SplitViewController: PrimaryListDelegate {
    func showSelectedDetail(by memo: MemoModel, at indexPath: IndexPath, showPage isShowing: Bool) {
        secondaryViewController?.updateDetailView(by: memo, at: indexPath)
        if isShowing { show(.secondary) }
    }
    
    func dismissDetail() {
        secondaryViewController?.initDetailView()
        show(.primary)
    }
}

// MARK: - Communication from Secondary View
extension SplitViewController: SecondaryDetailDelegate {
    func detailDeleted(at indexPath: IndexPath) {
        primaryViewController?.deleteMemo(at: indexPath)
    }
    
    func detailEdited(at indexPath: IndexPath) {
    
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
}

// MARK: - CoreData process
extension SplitViewController {
    func readDataAsset() -> [MemoModel] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: "dietSample") else {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 파일 바인딩 실패")
            return []
        }
        do {
            let result = try decoder.decode([MemoSample].self, from: dataAsset.data)
            return result
        } catch {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 디코딩 실패")
            return []
        }
    }
    
    func deleteMemo(at indexPath: IndexPath, completion: (IndexPath) -> Void) {
        let index = indexPath.row
        if let deletingMemo = listResource[index] as? MemoData,
           let coreID = deletingMemo.objectID {
            if !coreManager.deleteData(objectID: coreID) {
                print("에러처리 필요 - PrimaryViewController.deleteMemo : 코어데이터에서 해당 셀 삭제 실패")
                return
            }
        }
        listResource.remove(at: index)
        completion(indexPath)
        if listResource.count > 0 {
            let showingMemo = index < listResource.endIndex ? listResource[index] : listResource[listResource.index(before: index)]
            showSelectedDetail(by: showingMemo, at: indexPath, showPage: false)
        } else {
            print("리스트 카운트 \(listResource.count)")
            dismissDetail()
        }
    }
}

//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift
import RxCocoa
import Action //화면 처리를 도와주는 라이브러리?
import RxDataSources

typealias MemoSectionModel = AnimatableSectionModel<Int, Memo> //Section 데이터 형식, row 데이터 형식

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
    }
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        //클로저를 통한 초기화
        let dataSource = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: {
            (dataSource, tableView, indexPath, memo) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { _, _ in return true }
        return dataSource
    }()
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "") //새로운 메모 생성
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in } //타입 맞춰주는 트릭?
                }
        }
    }
    
    //Action
    func performUpdate(memo: Memo) -> Action<String, Void> { //입력, 출력(Observable 방출 형태: Void)
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    //1) 내용이 없는 메모를 생성하고
    //2) update를 통해 메모 내용을 수정
    //3) 기존 생성된 메모를 삭제
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map{ _ in }
        }
    }
    
    //메서드 형태도 가능
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Void> = {
        return Action { memo in
            return self.storage.delete(memo: memo)
                .map{ _ in }
        }
    }()
}

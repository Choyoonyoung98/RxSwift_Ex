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

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
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
}

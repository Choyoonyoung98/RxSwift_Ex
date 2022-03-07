//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    let memo: Memo //이전 Scene에서의 메모가 전달
    
    //날짜 -> 문자열로 전환하기 위한 formatter
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    //일반 Observable이 아닌 왜 BehaviorSubject?
    //-> 메모보기 화면에서 편집 버튼을 누르고 편집한 후, 되돌아오면 편집 내용이 반영되어야한다.
    //이렇게 하려면 새로운 문자열 배열을 방출해야 하기 때문
    var contents: BehaviorSubject<[String]> //문자열 2개를 방출해야 하기 때문에 (content, 날짜)
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map{ _ in }
    }
    
    //update된 메모를 subject로 전달하도록 수정
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .map { [$0.content, self.formatter.string(from: $0.insertDate)] }
                .bind(onNext: { self.contents.onNext($0)}) //새로운 내용을 subject로 전달
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable()
                .map{ _ in }
        }
    }
}

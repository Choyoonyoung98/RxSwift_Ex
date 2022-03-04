//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    //클래스 외부에서 해당 데이터 배열에 접근할 필요가 없기에 private으로 선언
    //배열은 Observable을 통해 외부로 공개
    //Observable은 배열의 상태가 업데이트되면 새로운 next 이벤트를 방출해야한다.
    //그렇기 때문에 일반 Observable이 아닌, subject의 형태로 구현해야 한다
    //또한 더미 데이터를 포함한 초기 데이터를 가지고 있기 때문에 behaviorSubject를 채택해야 한다
    private var list = [
        Memo(content: "이거슨 윤영의 첫 번째 메모입니다", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "이거슨 윤영의 두 번째 메모입니다", insertDate: Date().addingTimeInterval(-20)),
    ]
    
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    /*
     (공통 작업)
     배열을 변경한 후, subject에서 새로운 이벤트를 방출
     새로운 배열을 계속해서 방출해야 테이블에 정상적으로 업데이트
    */
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        
        store.onNext(list) //새로운 next 이벤트 방출
        return Observable.just(memo)
    }
    
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updatedMemo = Memo(original: memo, updatedContent: content)
        
        if let index = list.firstIndex(where: {$0 == memo}) {
            list.remove(at: index)
            list.insert(updatedMemo, at: index)
        }
        
        store.onNext(list)
        return Observable.just(updatedMemo)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: {$0 == memo}) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        return Observable.just(memo)
    }
}

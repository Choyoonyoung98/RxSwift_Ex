//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult //작업결과가 필요 없는 경우가 있기 때문에 추가
    func createMemo(content: String) -> Observable<Memo> //구독자가 작업결과를 원하는 방향으로 활용할 수 있다
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}

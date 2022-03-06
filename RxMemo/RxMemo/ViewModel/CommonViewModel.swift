//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/06.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    let title: Driver<String> //navigation item에 쉽게 바인딩 가능
    
    //프로토콜로 선언하면, 이후에 의존성을 쉽게 수정 가능
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}

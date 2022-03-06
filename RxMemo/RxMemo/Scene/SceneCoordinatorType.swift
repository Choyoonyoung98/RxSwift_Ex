//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    //1) 새로운 Scene 표시
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    //2) 현재 Scene을 닫고, 이전 Scene으로 돌아간다
    @discardableResult
    func close(animated: Bool) -> Completable
}

//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitopmError: Error {
     case navigationControllerMissing
    case cannotPop
    case unknown
}

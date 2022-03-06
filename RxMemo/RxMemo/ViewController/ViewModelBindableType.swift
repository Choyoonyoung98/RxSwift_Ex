//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit

protocol ViewModelBindableType {
    //ViewModel의 타입은 Viewcontroller마다 달라지기 때문에 제너릭 프로토콜로 선언
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
    
        bindViewModel()
    }
}

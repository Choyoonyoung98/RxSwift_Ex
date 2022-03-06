//
//  Scene.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    //스토리보드에 있는 ViewController을 가져와 바인딩 후 리턴
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            guard let listNavigationViewcontroller = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            
            guard var listViewController = listNavigationViewcontroller.viewControllers.first as? MemoListViewController else { fatalError() }
            
            listViewController.bind(viewModel: memoListViewModel)
            return listNavigationViewcontroller
        case .detail(let memoDetailViewModel):
            guard var detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            
            detailViewController.bind(viewModel: memoDetailViewModel)

            return detailViewController
        case .compose(let memoCompseViewModel):
            guard let composeNavigationViewcontroller = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeViewController = composeNavigationViewcontroller.viewControllers.first as? MemoComposeViewController else { fatalError() }
            
            composeViewController.bind(viewModel: memoCompseViewModel)
    
            return composeViewController
        }
    }
}


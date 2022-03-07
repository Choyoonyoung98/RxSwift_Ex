//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.last ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        //처음부터 Completable을 사용하지 않는 이유?
        let subject = PublishSubject<Never>()
        let target = scene.instantiate() //전달된 scene 생성
        
        switch style {
        case .root:
            currentViewController = target.sceneViewController
            window.rootViewController = target
            
            subject.onCompleted()
        case .push:
            //navigationViewController에 embeded되어 있는지부터 확인
            guard let navigationController = currentViewController.navigationController else {
                subject.onError(TransitopmError.navigationControllerMissing)
                break
            }
            
            navigationController.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, event) in
                    coordinator.currentViewController = event.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            
            navigationController.pushViewController(target, animated: animated)
            currentViewController = target.sceneViewController
            
            subject.onCompleted()
        case .modal:
            currentViewController.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentViewController = target.sceneViewController
        }
        
        return subject.asCompletable() //반환타입이 Completable이므로
    }
    
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingViewController = self.currentViewController.presentingViewController {
                self.currentViewController.dismiss(animated: animated) {
                    self.currentViewController = presentingViewController.sceneViewController
                    completable(.completed)
                }
            } else if let navigationController = self.currentViewController.navigationController {
                guard navigationController.popViewController(animated: animated) != nil else {
                    return Disposables.create()
                }
                
                self.currentViewController = navigationController.viewControllers.last!.sceneViewController
                completable(.completed)
            } else {
                completable(.error(TransitopmError.unknown))
            }
            
            return Disposables.create()
        }
    }
}

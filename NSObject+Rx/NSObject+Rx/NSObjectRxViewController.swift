//
//  NSObjectRxViewController.swift
//  NSObject+Rx
//
//  Created by 조윤영 on 2022/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
//NSObject+Rx 이름으로 라이브러리를 설치하나, import 시에는 언더 바 사용해서 작성

class NSObjectRxViewController: UIViewController {
    //매번 선언해줬던 disposeBag 사용 불필요
    //let disposeBag = DisposeBag()
    
    let button = UIButton(type: .system)
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //just: 파라미더로 받은 하나의 element를 그대로 방출
//        Observable.just("Hello")
//            .subscribe{ print($0) }
//            .disposed(by: disposeBag)
//
//        button.rx.tap
//            .map { "Hello" }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        Observable.just("Hello")
            .subscribe{ print($0) }
            .disposed(by: rx.disposeBag)
        
        button.rx.tap
            .map { "Hello" }
            .bind(to: label.rx.text)
            .disposed(by: rx.disposeBag)
            }
    }
}

//NSObject를 상속하지 않기 때문에 rx.disposeBag 사용할 수 없음
//대신 HasDisposeBag 프로토콜을 통해 채택 가능 -> 해당 프로토콜은 class 형태이기에 구조체 형태에서는 채택이 불가능
class MyClass: HasDisposeBag {
    //let bag = DisposeBag()
    
    func doSomething() {
        Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    
}

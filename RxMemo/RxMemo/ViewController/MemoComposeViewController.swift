//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        //1: 더블클릭과 같은 중복 탭이 발생할 수 있으므로 0.5초마다 처리
        //2. withLatestFrom: textView에 입력되어 있는 텍스트 방출
        //3. saveAction에 있는 입력값으로 바인딩
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        let willShowObservable =
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap{ $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        //Notification이 전달될 때마다 키보드 높이 방출
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable)
            .share()
        
        //textView inset을 조절해서 하단 여백 설정
        keyboardObservable
            //.withUnretained(contentTextView) //textView를 파라미터로 아래에서 받고 있기 때문에 필요없다
            .toContentInset(of: contentTextView)
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx.disposeBag)
    }
}

extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}

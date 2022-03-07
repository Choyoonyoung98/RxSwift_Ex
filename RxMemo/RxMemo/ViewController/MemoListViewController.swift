//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var viewModel: MemoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier:  "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        //선택 이벤트 처리
        //=> listTableView.rx.itemSelected
        //메모가 필요하다?
        //=> listTableView.rx.modelSelected()
        
//        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
//            .do(onNext: { [unowned self] ( _ , indexPath) in
//                self.listTableView.deselectRow(at: indexPath, animated: true)
//            })
        
        //Rxswift 6.0
        //withUnretained 연산자를 통해 self에 대한 비소유 참조와, zip 연산자가 방출하는 요소가 하나의 튜플로 합쳐진다
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .withUnretained(self)
            .do(onNext: { (viewController, data) in
                viewController.listTableView.deselectRow(at: data.1, animated: true)
            })
                .map { $1.0 }
                .bind(to: viewModel.detailAction.inputs)
                .disposed(by: rx.disposeBag)
    }
    
    func bindViewModel() {
        
    }
}

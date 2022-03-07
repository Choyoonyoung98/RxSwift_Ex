//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit
import RxSwift

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: contentTableView.rx.items) { tableView, row, value in
                switch  row {
                case 0:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") {
                        cell.textLabel?.text = value
                        return cell
                    }
                    return UITableViewCell()
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") {
                        cell.textLabel?.text  = value
                        return cell
                    }
                    return UITableViewCell()
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        //action? tap?
        editButton.rx.action = viewModel.makeEditAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (viewController, _) in
                let memo = viewController.viewModel.memo.content
                let activityViewController = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                viewController.present(activityViewController, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
        /*
        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        viewModel.title
            .drive(backButton.rx.title)
            .disposed(by: rx.disposeBag)
        
        backButton.rx.action = viewModel.popAction
        //아래와 같이 할 경우, 동작되지 않는 이유?
        //backButton의 title이나 이미지를 설정하는 것은 가능하지만 ACtion은 기본 Action으로 고정되기 때문에 아래 구현으로는 해결 X
        //navigationItem.backBarButtonItem = backButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
         */
    }
}

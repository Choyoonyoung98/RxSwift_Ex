//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import UIKit

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
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "conentCell") {
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
    }
}

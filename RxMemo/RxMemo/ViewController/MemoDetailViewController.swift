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
        
    }
}

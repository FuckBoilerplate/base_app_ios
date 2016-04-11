//
//  UsersViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift
import OkDataSources

class UsersViewController: BaseViewController<UsersPresenter> {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<User, UsersTableViewCell>!
    var delegate: OkTableViewDelegate<OkTableViewDataSource<User, UsersTableViewCell>, UsersPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkTableViewDelegate(dataSource: dataSource, presenter: presenter)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    override func showLoading() {
        loadingView.hidden = false
        tableView.hidden = true
    }
    
    override func hideLoading() {
        loadingView.hidden = true
        tableView.hidden = false
    }
    
    // MARK: - Actions
    @IBAction func menuButtonPressed(sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    // MARK: - Public methods
    func showUsers(oUsers: Observable<[User]>) -> Disposable {
        showLoading()
        return oUsers.subscribe(onNext: { (users) -> Void in
            self.dataSource.items = users
            self.tableView.reloadData()
            }, onCompleted: { () -> Void in
                self.hideLoading()
        })
    }
    
}

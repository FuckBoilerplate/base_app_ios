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
    var delegate: OkRxTableViewDelegate<OkTableViewDataSource<User, UsersTableViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkRxTableViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.presenter.goToDetail(item)
                    .safely()
                    .subscribe()
        })
        delegate.setOnPullToRefresh(tableView) { self.presenter.refreshList() }
        delegate.setOnPagination { user in self.presenter.nextPage(user) }
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        presenter.nextPage(nil)
            .safelyReportLoading(self)
            .subscribeNext { users in
                self.dataSource.items = users
                self.tableView.reloadData()
        }
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
}

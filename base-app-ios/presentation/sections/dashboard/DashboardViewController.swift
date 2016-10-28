//
//  DashboardViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import OkDataSources

class DashboardViewController: BaseViewController<DashboardPresenter> {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<ItemMenu, DashboardTableViewCell>!
    var delegate: OkRxTableViewDelegate<OkTableViewDataSource<ItemMenu, DashboardTableViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getItemsMenu()
            .safely()
            .subscribe(onNext: { items in
                self.dataSource.items = items
                self.tableView.reloadData()
        })
        
        dataSource = OkTableViewDataSource()
        delegate = OkRxTableViewDelegate(dataSource: dataSource, onItemClicked: { (item, position) in
            switch(item.type) {
            case .user:
                self.showUser()
            case .users:
                self.showUsers()
            case .search:
                self.showUserSearch()
            }
        })
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        showUsers()
    }
    
    // MARK: - Private methods
    fileprivate func changeMainViewController(_ viewController: UIViewController) {
        let nvc: UINavigationController = UINavigationController(rootViewController: viewController)
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
    }
    
    fileprivate func showUsers() {
        changeMainViewController(R.storyboard.user.usersViewController()!)
    }
    
    fileprivate func showUser() {
        changeMainViewController(R.storyboard.user.userViewController()!)
    }
    
    fileprivate func showUserSearch() {
        changeMainViewController(R.storyboard.user.searchUserViewController()!)
    }
}

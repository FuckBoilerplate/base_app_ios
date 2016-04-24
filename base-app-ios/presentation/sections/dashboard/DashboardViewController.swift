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
            .subscribeNext { items in
                self.dataSource.items = items
                self.tableView.reloadData()
        }
        
        dataSource = OkTableViewDataSource()
        delegate = OkRxTableViewDelegate(dataSource: dataSource, onItemClicked: { (item, position) in
            switch(item.type) {
            case .User:
                self.showUser()
            case .Users:
                self.showUsers()
            case .Search:
                self.showUserSearch()
            }
        })
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        showUsers()
    }
    
    // MARK: - Private methods
    private func changeMainViewController(viewController: UIViewController) {
        let nvc: UINavigationController = UINavigationController(rootViewController: viewController)
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
    }
    
    private func showUsers() {
        changeMainViewController(R.storyboard.user.usersViewController()!)
    }
    
    private func showUser() {
        changeMainViewController(R.storyboard.user.userViewController()!)
    }
    
    private func showUserSearch() {
        changeMainViewController(R.storyboard.user.searchUserViewController()!)
    }
}

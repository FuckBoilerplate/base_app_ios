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
    var delegate: OkTableViewDelegate<OkTableViewDataSource<ItemMenu, DashboardTableViewCell>, DashboardPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkTableViewDelegate(dataSource: dataSource, presenter: presenter)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    // MARK: - Private methods
    private func changeMainViewController(viewController: UIViewController) {
        let nvc: UINavigationController = UINavigationController(rootViewController: viewController)
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
    }
    
    // MARK: - Public methods
    func showItemsMenu(oItems: Observable<[ItemMenu]>) -> Disposable {
        showLoading()
        return oItems.subscribe(onNext: { (items) -> Void in
            self.dataSource.items = items
            self.tableView.reloadData()
            self.showUsers()
            },onCompleted: { self.hideLoading() })
    }
    
    func showUsers() {
        changeMainViewController(R.storyboard.user.usersViewController()!)
    }
    
    func showUser() {
        changeMainViewController(R.storyboard.user.userViewController()!)
    }
    
    func showUserSearch() {
        changeMainViewController(R.storyboard.user.searchUserViewController()!)
    }
}

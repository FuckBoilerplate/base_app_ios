//
//  SearchUserViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class SearchUserViewController: BaseViewController<SearchUserPresenter> {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If it is the first viewController of the navigationController, then add the MenuButton to the navigationBar
        if self.navigationController?.viewControllers.first == self {
            let menuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchUserViewController.menuButtonPressed(_:)))
            navigationItem.leftBarButtonItem = menuButton
        }
    }
    
    // MARK: - Private method
    func menuButtonPressed(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }

    fileprivate func showUser(_ user: User) {
        userNameLabel.text = user.login
        if let imageURL = URL(string: user.getAvatarUrl()) {
            userImageView.sd_setImage(with: imageURL)
        }
    }
    
    // MARK: - Actions
    @IBAction func findUserButtonPressed(_ sender: UIButton) {
        presenter.getUserByName(userNameTextField.text!)
            .safelyReport(self)
            .subscribe(onNext: { user in self.showUser(user) })
    }
}

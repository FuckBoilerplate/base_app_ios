//
//  UserViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class UserViewController: BaseViewController<UserPresenter> {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If it is the first viewController of the navigationController, then add the MenuButton to the navigationBar
        if self.navigationController?.viewControllers.first == self {
            let menuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UserViewController.menuButtonPressed(_:)))
            navigationItem.leftBarButtonItem = menuButton
        }
        
        presenter.getCurrentUser()
            .safelyReport(self)
            .subscribe(onNext: { user in self.showUser(user) })
    }
    
    // MARK: - Private methods
    fileprivate func showUser(_ user: User) {
        userNameLabel.text = user.login
        if let imageURL = URL(string: user.getAvatarUrl()) {
            userImageView.sd_setImage(with: imageURL)
        }
    }
    
    func menuButtonPressed(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }

    // MARK: - Actions
    @IBAction func findUserButtonPressed(_ sender: UIButton) {
        wireframe.searchUserScreen()
    }
}

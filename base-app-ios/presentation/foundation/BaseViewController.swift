//
//  BaseViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController<P: Presenter>: UIViewController, BaseView {
    
    var presenter: P!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.resumeView()
    }
    
    // MARK: - BaseView
    func showAlert(oTitle: Observable<String>) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
}

extension UIViewController {
    
    func showAlertMessage(message: String) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

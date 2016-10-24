//
//  OkPagerView.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 20/2/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public protocol OkPagerViewDataSource {
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController?
    func numberOfPages() -> Int?
}

public protocol OkPagerViewDelegate {
    
    func onPageSelected(_ viewController: UIViewController, index: Int)
}

open class OkPagerView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var pageViewController: UIPageViewController!
    open fileprivate(set) var currentIndex = 0
    
    open var callFirstItemOnCreated = true
    open var dataSource: OkPagerViewDataSource! {
        didSet {
            reloadData()
        }
    }
    open var delegate: OkPagerViewDelegate!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPagerViewController()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addPagerViewController()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        addPagerViewController()
    }
    
    // MARK: - Private methods
    fileprivate func addPagerViewController() {
        
        if pageViewController != nil {
            return
        }
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = self.bounds
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addSubview(pageViewController.view)
        
        let constTop = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        let constBottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        let constLeft = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        let constRight = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        self.addConstraints([constTop, constBottom, constLeft, constRight])
        
        pageControl?.currentPage = 0
    }
    
    fileprivate func getViewControllerAtIndex(_ index: Int) -> PageViewWrapper? {
        if (getNumberOfPages() == 0
            || index >= getNumberOfPages())
        {
            return nil
        }
        
        // Create a new View Controller and pass suitable data.
        guard let wrappedViewController = dataSource.viewControllerAtIndex(index) else {
            return nil
        }
        
        let viewController = PageViewWrapper()
        viewController.wrappedViewController = wrappedViewController
        viewController.pageIndex = index
        return viewController
    }
    
    fileprivate func getNumberOfPages() -> Int {
        if let dataSource = dataSource,
            let numberOfPages = dataSource.numberOfPages()
            , pageViewController != nil {
                return numberOfPages
        }
        return 0
    }
    
    // MARK: - Public methods
    open func reloadData() {
        
        if getNumberOfPages() > 0
            && currentIndex >= 0
            && currentIndex < getNumberOfPages() {
                self.pageViewController.setViewControllers(
                    [getViewControllerAtIndex(currentIndex)!],
                    direction: UIPageViewControllerNavigationDirection.forward,
                    animated: false,
                    completion: nil)
                
                pageControl?.currentPage = currentIndex
                
                if callFirstItemOnCreated {
                    delegate?.onPageSelected(getViewControllerAtIndex(currentIndex)!, index: currentIndex)
                }
        }
    }
    
    open func setCurrentIndex(_ index: Int, animated: Bool) {
        if index == currentIndex {
            print("Same page")
            return
        }
        if index >= getNumberOfPages() {
            print("Trying to reach an unknown page")
            return
        }
        
        let direction: UIPageViewControllerNavigationDirection = currentIndex < index ? .forward : .reverse
        
        guard let viewController = getViewControllerAtIndex(index) else {
            print("Method getViewControllerAtIndex(\(index)) is returning nil")
            return
        }
        self.pageViewController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
        
        currentIndex = index
        delegate?.onPageSelected(viewController, index: index)
    }
    
    open func setScrollEnabled(_ enabled: Bool) {
        
        if let pageViewController = pageViewController {
            
            for view in pageViewController.view.subviews {
                if let scrollView = view as? UIScrollView {
                    scrollView.isScrollEnabled = enabled
                }
            }
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let itemViewController = viewController as? PageViewWrapper {
            var index = itemViewController.pageIndex
            if (index == 0) || (index == NSNotFound) { return nil }
            index -= 1
            return getViewControllerAtIndex(index)
        }
        return nil
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let itemViewController = viewController as? PageViewWrapper {
            var index = itemViewController.pageIndex
            if index == NSNotFound { return nil }
            index += 1
            if (index == getNumberOfPages()) { return nil }
            return getViewControllerAtIndex(index)
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDelegate
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let pageVC = pageViewController.viewControllers!.last as? PageViewWrapper {
                if let delegate = delegate {
                    delegate.onPageSelected(pageVC.wrappedViewController, index: pageVC.pageIndex)
                }
                // Save currentIndex
                currentIndex = pageVC.pageIndex
                pageControl?.currentPage = currentIndex
            }
        }
    }
}

// MARK: - PageViewWrapper
private class PageViewWrapper: UIViewController {
    
    var pageIndex: Int = 0
    var wrappedViewController: UIViewController!
    
    fileprivate override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentBounds = self.parent?.view.bounds {
            self.view.frame = parentBounds
        }
        
        wrappedViewController.view.frame = self.view.frame
        let topConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addSubview(wrappedViewController.view)
        self.view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    // MARK: Life cycle
    fileprivate override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wrappedViewController.viewDidAppear(animated)
    }
    
    fileprivate override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wrappedViewController.viewWillAppear(animated)
    }
    
    fileprivate override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        wrappedViewController.viewWillDisappear(animated)
    }
    
    fileprivate override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        wrappedViewController.viewDidDisappear(animated)
    }
}

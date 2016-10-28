//
//  OkSlidingTabs.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 3/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

@objc public protocol OkSlidingTabsDataSource {
    @objc func numberOfTabs() -> Int
    @objc func titleAtIndex(_ index: Int) -> String
}

@objc public protocol OkSlidingTabsDelegate {
    @objc func onTabSelected(_ index: Int)
}

@IBDesignable
@objc open class OkSlidingTabs: UIView {

    fileprivate var scrollView: UIScrollView!
    fileprivate var indicatorView: UIView!
    fileprivate var tabs: UILabel!
    fileprivate var xOffset: CGFloat = 0
    fileprivate var currentTabSelected = 0
    fileprivate var labels: [UILabel]!
    
    @IBInspectable
    open var xPadding: CGFloat = 20
    @IBInspectable
    open var xMargin: CGFloat = 0
    @IBInspectable
    open var labelTextColor: UIColor = UIColor.black
    @IBInspectable
    open var labelBgColor: UIColor = UIColor.white
    @IBInspectable
    open var indicatorColor: UIColor = UIColor.black
    @IBInspectable
    open var indicatorHeight: CGFloat = 5
    @IBInspectable
    open var distributeEvenly: Bool = false {
        didSet {
            reloadData()
        }
    }
    open var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    open var dataSource: OkSlidingTabsDataSource!
    open var delegate: OkSlidingTabsDelegate!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    // MARK: - Private methods
    fileprivate func initView() {
        addScrollView()
        addIndicatorView()
    }
    
    fileprivate func addScrollView() {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.clear
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    fileprivate func addIndicatorView() {
        if let firstLabelFrame = labels?.first?.frame {
            indicatorView?.removeFromSuperview()
            indicatorView = UIView(frame: CGRect(x: 0, y: firstLabelFrame.height - indicatorHeight, width: firstLabelFrame.width, height: indicatorHeight))
            indicatorView.backgroundColor = indicatorColor
            scrollView.addSubview(indicatorView)
        }
    }
    
    fileprivate func addTabsView() {
        if let dataSource = dataSource {
            if dataSource.numberOfTabs() > 0 {
                labels?.forEach { $0.removeFromSuperview() }
                labels = []
                for i in 0..<dataSource.numberOfTabs() {
                    // Label
                    let label = UILabel()
                    label.text = dataSource.titleAtIndex(i)
                    label.backgroundColor = labelBgColor
                    label.font = font
                    label.textAlignment = .center
                    label.textColor = labelTextColor
                    label.sizeToFit()
                    if distributeEvenly {
                        let screenSize = UIScreen.main.bounds
                        let width = screenSize.width / CGFloat(dataSource.numberOfTabs())
                        label.frame = CGRect(x: xOffset, y: 0, width: width, height: self.frame.height)
                    } else {
                        label.frame = CGRect(x: xOffset, y: 0, width: label.frame.width + xPadding, height: self.frame.height)
                    }
                    scrollView.contentSize = CGSize(width: xOffset + label.frame.width, height: self.frame.height)
                    scrollView.addSubview(label)
                    labels.append(label)
                    // Button
                    let button = UIButton(frame: label.frame)
                    button.tag = i
                    button.addTarget(self, action: #selector(OkSlidingTabs.buttonPressed(_:)), for: .touchUpInside)
                    scrollView.addSubview(button)
                    xOffset += label.frame.width + xMargin
                }
            }
        }
        layoutIfNeeded()
        scrollView.frame = self.bounds
    }
    
    internal func buttonPressed(_ sender: UIButton) {
        currentTabSelected = sender.tag
        delegate?.onTabSelected(currentTabSelected)
        animateIndicator(currentTabSelected)
    }
    
    // MARK: - Indicator view animations
    fileprivate func animateIndicator(_ index: Int) {
        
        if !(labels != nil && labels.count > 0 && labels.count > index) {
            return
        }
        let labelFrame = labels[index].frame
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            // Indicator animation
            let indicatorFrame = self.indicatorView.frame
            self.indicatorView.frame = CGRect(x: labelFrame.minX, y: indicatorFrame.minY, width: labelFrame.width, height: indicatorFrame.height)
            // Scroll animation if distributeEvenly is false
            if !self.distributeEvenly {
                if labelFrame.minX < self.frame.width/2 { // The first places
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                } else { // The rest
                    // If the remaining space is smaller than a CGRectGetWidth(self.frame)
                    let lastWidth = self.scrollView.contentSize.width - labelFrame.minX - (self.frame.width - labelFrame.width)/2
                    if lastWidth < self.frame.width/2 - labelFrame.width/2 {
                        let xLastOffset = self.scrollView.contentSize.width - self.frame.width
                        self.scrollView.contentOffset = CGPoint(x: xLastOffset, y: 0)
                    } else {
                        // If not
                        let xOffset = (self.frame.width - labelFrame.width)/2
                        self.scrollView.contentOffset = CGPoint(x: labelFrame.minX - xOffset, y: 0)
                    }
                }
            }
        }) 
    }
    
    // MARK: - Public methods
    open func reloadData() {
        xOffset = 0
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        addTabsView()
        addIndicatorView()
    }
    
    open func setCurrentTab(_ index: Int) {
        currentTabSelected = index
        animateIndicator(index)
    }
}

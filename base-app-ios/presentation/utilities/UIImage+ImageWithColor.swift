//
//  UIImage+ImageWithColor.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let img = imageWithColor(color, size: CGSizeMake(1, 1))
        return img
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func resizableImageWithColor(color: UIColor, cornerRadius: CGFloat) -> UIImage{
        
        let minEdgeSize = cornerRadius * 2 + 1
        let rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.lineWidth = 0
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        roundedRect.addClip()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }
    
}
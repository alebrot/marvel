//
//  UIImage.swift
//  marvel
//
//  Created by khlebtsov alexey on 13/05/16.
//
//

import UIKit

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
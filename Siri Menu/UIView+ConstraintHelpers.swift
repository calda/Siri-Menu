//
//  UIView+ConstraintHelpers.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit

// MARK: - Core Constraint Helpers

extension UIView {
    
    ///The layout margins applied by taking `presercesSuperviewLayoutMargins` into account
    var applicableLayoutMargins: UIEdgeInsets {
        guard let superview = superview else {
            return layoutMargins
        }
        
        if preservesSuperviewLayoutMargins {
            return superview.applicableLayoutMargins
        } else {
            return layoutMargins
        }
    }
    
    func addSubviewAndConstrainToEqualSize(
        _ subview: UIView,
        with insets: UIEdgeInsets = .zero,
        includeLayoutMargins: Bool = false)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutInsets = insets
        if includeLayoutMargins {
            let applicableMargins = applicableLayoutMargins
            layoutInsets = UIEdgeInsets(
                top: insets.top + applicableMargins.top,
                left: insets.left + applicableMargins.left,
                bottom: insets.bottom + applicableMargins.bottom,
                right: insets.right + applicableMargins.right)
        }
        
        self.addSubview(subview)
        subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: layoutInsets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -layoutInsets.right).isActive = true
        subview.topAnchor.constraint(equalTo: self.topAnchor, constant: layoutInsets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -layoutInsets.bottom).isActive = true
    }
    
    func addSubviewAndConstrainInCenter(
        _ subview: UIView,
        verticalOffset: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(subview)
        subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: verticalOffset).isActive = true
        
        if let width = width {
            subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

extension UIEdgeInsets {
    
    static func with(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
}

extension NSLayoutConstraint {
    @IBInspectable var usePixels: Bool {
        get {
            return false // default Value
        }
        set {
            if newValue {
                constant = constant / UIScreen.main.scale
            }
        }
    }
}

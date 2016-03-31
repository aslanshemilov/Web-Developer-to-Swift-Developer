//
//  LayoutFunctions.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/30/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import UIKit

class LayoutFunctions {
    static func activateConstraintsForView(view: UIView, parentView: UIView) {
        let bottom = NSLayoutConstraint(item: view,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)
        
        let top = NSLayoutConstraint(item: view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0.0)
        
        
        let left = NSLayoutConstraint(item: view,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0.0)
        
        
        let right = NSLayoutConstraint(item: view,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0.0)
        
        NSLayoutConstraint.activateConstraints([bottom, top, left, right])
        
    }
    
    static func verticallyCenterView(view: UIView, parentView: UIView) {
        let centerY = NSLayoutConstraint(item: view,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0.0)
        
        NSLayoutConstraint.activateConstraints([centerY])
    }
    
    static func horizontallyCenterView(view: UIView, parentView: UIView) {
        let centerY = NSLayoutConstraint(item: view,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: parentView,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0)
        
        NSLayoutConstraint.activateConstraints([centerY])
    }
}

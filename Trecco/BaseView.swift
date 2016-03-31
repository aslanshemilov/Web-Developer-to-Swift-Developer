//
//  BaseView.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/28/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

class BaseView: UIView {
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //load the Interface Builder file
        NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil)
        //set bounds correctly
        self.bounds = self.view.bounds
        //add as subview
        self.addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //load the Interface Builder file
        NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil)
        //add as subview
        self.addSubview(self.view)
    }
    
    
}


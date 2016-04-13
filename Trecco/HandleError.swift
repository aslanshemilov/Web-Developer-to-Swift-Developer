//
//  HandleError.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/7/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import UIKit

class HandleError {
    static func ShowError(errorMessage: String, error: ErrorType, viewController: UIViewController) {
        HandleError.ShowAlert(errorMessage, viewController: viewController)
    }
    
    static func ShowAlert(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .Alert)
        
        let noAction = UIAlertAction(title: "OK", style: .Default, handler: {action in
            alert.dismissViewControllerAnimated(true, completion: nil)
            viewController.navigationController?.popToRootViewControllerAnimated(true)
        })
        
        alert.addAction(noAction)
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}

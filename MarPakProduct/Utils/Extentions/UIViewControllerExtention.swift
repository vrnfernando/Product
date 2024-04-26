//
//  UIViewControllerExtention.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Move into the root begining
    func popToRootViewController() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

//
//  Extention+ViewController.swift
//  MyProgetUIKit
//
//  Created by Yurii Honcharov on 17.11.2023.
//

import UIKit

extension UIViewController {
    static var fromStoryboard: Self {
        let selfName = NSStringFromClass(self).components(separatedBy: ".").last!
        let storyboard = UIStoryboard(name: selfName, bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: selfName) as! Self

        return customViewController
    }
}

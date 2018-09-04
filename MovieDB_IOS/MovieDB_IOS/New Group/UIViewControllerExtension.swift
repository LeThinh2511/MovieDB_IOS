//
//  UIViewControllerExtension.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

extension UIViewController {
    func dismissWithCustomAnimation() {
        let transition = CATransition()
        transition.subtype = kCATransitionFromLeft
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  NSViewController+Children.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/25/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSViewController {
    func addChildVC(_ childVC: NSViewController, to container: NSView) {
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.viewDidLoad()
    }
}

//
//  NSWindowController+Storyboard.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/14/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSWindowController {
    func instantiateVC<VC: NSViewController>(withID id: String) -> VC? {
        let id = NSStoryboard.SceneIdentifier(id)
        let vc = storyboard?.instantiateController(withIdentifier: id) as? VC
        return vc
    }
}

extension NSViewController {
    func instantiateVC<VC: NSViewController>(withID id: String) -> VC? {
        let id = NSStoryboard.SceneIdentifier(id)
        let vc = storyboard?.instantiateController(withIdentifier: id) as? VC
        return vc
    }
}

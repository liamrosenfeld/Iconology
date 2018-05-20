//
//  SelectPresetViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class SelectPresetViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func next(_ sender: Any) {
        let EditPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditPresetViewController")) as? EditPresetViewController
        view.window?.contentViewController = EditPresetViewController
    }
    
    @IBAction func done(_ sender: Any) {
        self.view.window!.close()
    }
}

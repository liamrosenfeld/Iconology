//
//  DragViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class DragViewController: NSViewController {
    
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var subText: NSTextField!
    
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func toOptionsVC() {
        let optionsViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("OptionsViewController")) as? OptionsViewController
        optionsViewController?.imageURL = imageURL!
        view.window?.contentViewController = optionsViewController
    }

}

extension DragViewController: DragViewDelegate {
    
    func dragViewDidHover() {
        self.descriptionLabel.stringValue = "That would work!"
        self.subText.stringValue = ""
    }
    
    func dragViewMouseExited(){
        self.descriptionLabel.stringValue = "Drag and Drop an image file here"
        self.subText.stringValue = "(Input a high-res photo of the same aspect ratio)"
    }
    
    func dragView(didDragFileWith url: NSURL) {
        imageURL = url as URL
        print(url)
        toOptionsVC()
    }
    
}

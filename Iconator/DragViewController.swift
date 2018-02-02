//
//  ViewController.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class DragViewController: NSViewController {
    
    // Setup
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var staticLabel: NSTextField!
    @IBOutlet weak var dragView: DragView!
    
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension DragViewController: DragViewDelegate {
    // Save image URL one drag is complete
    func dragView(didDragFileWith url: NSURL) {
        imageURL = url
        print(url)
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "toOptions"), sender: Any?.self)
    }
    
    
    // TODO: - Prepare for segue and send imageURL to imageURL in OptionsViewController()
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier!.rawValue == "toOptions") {
            let destination = segue.destinationController as! OptionsViewController;
            destination.imageURL = imageURL!
        }
    }
    
}

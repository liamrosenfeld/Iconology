//
//  DragViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

class DragViewController: NSViewController {
    
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var subText: NSTextField!
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        dragView.setBackground(to: .gray)
    }
    
    override func viewWillAppear() {
        dragView.alphaValue = 0
    }
    
    func toOptionsVC(for imageURL: URL) {
        let windowController = view.window?.windowController as! MainWindowController
        guard let image = getImage(from: imageURL) else { return }
        windowController.presentOptions(for: image)
    }
    
    @IBAction func chooseFileClicked(_ sender: Any) {
        guard let url = FileHandler.selectImage() else {
            return
        }
        toOptionsVC(for: url)
    }
    
    func getImage(from url: URL) -> NSImage? {
        do {
            return try url.toImage()
        } catch URL.ImageError.imageNotFound {
            Alerts.warningPopup(title: "Image Not Found", text: "'\(url.path)' No Longer Exists'")
            print("ERR: File Could No Longer Be Found")
        } catch {
            print("Unexpected error: \(error).")
        }
        
        return nil
    }
}

extension DragViewController: DragViewDelegate {
    
    func dragViewDidHover() {
        self.descriptionLabel.stringValue = "That would work!"
        self.subText.stringValue = ""
        dragView.alphaValue = 0.25
    }
    
    func dragViewMouseExited() {
        self.descriptionLabel.stringValue = "Drag and Drop an Image File Here"
        self.subText.stringValue = "(Input a High-Resolution Image)"
        dragView.alphaValue = 0
    }
    
    func dragView(didDragFileWith url: URL) {
        toOptionsVC(for: url)
    }
    
}

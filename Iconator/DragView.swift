//
//  DragView.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa


protocol DragViewDelegate {
    func dragViewDidHover()
    func dragViewMouseExited()
    func dragView(didDragFileWith URL: NSURL)
}

class DragView: NSView {
    
    var delegate: DragViewDelegate?
    
    // Help push forward only the right file format of our images
    private var fileTypeIsOk = false
    // TODO: - Add PSD Support
    private var acceptedFileExtensions = ["png"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")])
    }
    
    // Check if Image is Allowed
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        fileTypeIsOk = checkExtension(drag: sender)
        
        // Trigger funtion in DragViewController if file type is ok
        if fileTypeIsOk {
            delegate?.dragViewDidHover()
        }
        
        return []
    }
    
    // Get the details of the image
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .copy : []
    }
    
    // Pass URL on mouse release
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedFileURL = sender.draggedFileURL else {
            return false
        }
        
        //call the delegate
        if fileTypeIsOk {
            delegate?.dragView(didDragFileWith: draggedFileURL)
        }
        
        return true
    }
    
    // Check drag object, grab the url of the file coming in, and check if it complies with our acceptedFileExtensions.
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension?.lowercased() else {
            return false
        }
        
        return acceptedFileExtensions.contains(fileExtension)
    }
    
    // Notify DragViewController if drag leaves without drop
    override func draggingExited(_ sender: NSDraggingInfo?) {
        delegate?.dragViewMouseExited()
    }
    
}

// Extend NSDraggingInfo
extension NSDraggingInfo {
    var draggedFileURL: NSURL? {
        let filenames = draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String]
        let path = filenames?.first
        
        return path.map(NSURL.init)
    }
}



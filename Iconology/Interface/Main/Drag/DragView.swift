//
//  DragView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

protocol DragViewDelegate {
    func dragViewDidHover()
    func dragViewMouseExited()
    func dragView(didDragFileWith URL: URL)
}

class DragView: NSView {
    
    var delegate: DragViewDelegate?
    
    // Help push forward only the right file format of our images
    private var fileTypeIsOk = false
    
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
    
    // Check drag object, grab the url of the file coming in, and check if it matches a 'allowedViewTypes' UTI String.
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let urlResource = ((try? drag.draggedFileURL?.resourceValues(forKeys: [.typeIdentifierKey])) as URLResourceValues??) else {
            return false
        }
        guard let typeIdentifier = urlResource?.typeIdentifier else {
            return false
        }
        return allowedFileTypes.contains(typeIdentifier)
    }
    
    // Notify DragViewController if drag leaves without drop
    override func draggingExited(_ sender: NSDraggingInfo?) {
        delegate?.dragViewMouseExited()
    }
    
}

// Extend NSDraggingInfo
extension NSDraggingInfo {
    var draggedFileURL: URL? {
        let filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String]
        guard let path = filenames?.first else {
            return nil
        }
        return URL(fileURLWithPath: path)
    }
}



//
//  EditPresetsWindowController.swift
//  Iconology
//
//  Created by Liam on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PresetsWindowController: NSWindowController, NSWindowDelegate {
    
    var edited = false {
        didSet {
            self.setDocumentEdited(edited)
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if self.edited {
            askClose()
            return false
        }
        
        return true
    }
    
    func askClose(){
        // Create Alert
        let alert = NSAlert()
        alert.messageText = "Do you want to save your changes?"
        
        // Add Buttons
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Don't Save")
        
        // Present
        alert.beginSheetModal(for: self.window!) { selected in
            if selected == .alertFirstButtonReturn {
                // save
                let controller = self.window?.contentViewController
                controller?.commitEditing() // sets edited to false
                self.close()
            } else if selected == .alertSecondButtonReturn {
                // cancel
                return
            } else if selected == .alertThirdButtonReturn {
                // don't save
                let controller = self.window?.contentViewController
                controller?.discardEditing() // sets edited to false
                self.close()
            }
        }
    }
    
}

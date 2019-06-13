//
//  PositionView.swift
//  Iconology
//
//  Created by Liam on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PositionSelector: NSControl {
    
    private var dragView = NSView()
    private var count = 0
    
    var position: CGPoint {
        get {
            var point = dragView.frame.origin
            
            // make point center of dragView
            point.x += dragView.frame.size.width / 2
            point.y += dragView.frame.size.height / 2
            
            // make (0, 0) center of parent
            point.x -= self.frame.size.width / 2
            point.y -= self.frame.size.height / 2
            
            // scale to -120...120
            point.x = (point.x / (self.frame.size.width  / 2)) * 120
            point.y = (point.y / (self.frame.size.height / 2)) * 120
            
            return point
        }
    }
    
    func setPosition(to position: CGPoint) {
        let x = position.x + (frame.size.width / 2) - (dragView.frame.size.width / 2)
        let y = position.y + (frame.size.height / 2) - (dragView.frame.size.height / 2)
        dragView.frame.origin = CGPoint(x: x, y: y)
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDragView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupDragView()
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
        
        // format
        setBackground(to: .labelColor)
        self.layer?.cornerRadius = dragView.frame.width / 2
    }
    
    // MARK: - Drag View
    func setupDragView() {
        // size and position
        dragView = NSView(frame: NSRect(x: 0, y: 0, width: self.frame.width / 10, height: self.frame.height / 10))
        dragView.setBackground(to: .systemBlue)
        dragView.layer?.cornerRadius = dragView.frame.width / 2
        setPosition(to: CGPoint(x: 0, y: 0))
        
        // drag support
        let gesture = NSPanGestureRecognizer(target: self, action: #selector(Self.draggedView(_:)))
        dragView.addGestureRecognizer(gesture)
        self.addSubview(dragView)
    }
    
    @objc func draggedView(_ sender: NSPanGestureRecognizer) {
        // limit triggers
        count += 1
        if count % 2 == 0 {
            return
        }
        
        // get point and vector
        let currentLoc = dragView.frame.origin
        let translation = sender.translation(in: self)
        
        // check bounds
        let upper = currentLoc.y + dragView.frame.height + translation.y
        let lower = currentLoc.y + translation.y
        let left  = currentLoc.x + translation.x
        let right = currentLoc.x + dragView.frame.width + translation.x
        
        if  (upper >= frame.height) ||
            (lower <= 0) ||
            (left <= 0) ||
            (right >= frame.width) {
            sender.mouseUp(with: NSEvent())
            sender.setTranslation(CGPoint.zero, in: self)
            return
        }
        
        // apply transformation
        dragView.frame.origin = CGPoint(x: currentLoc.x + translation.x, y: currentLoc.y + translation.y)
        sendAction(action, to: target)
        
        // reset translation
        sender.setTranslation(CGPoint.zero, in: self)
    }
}

fileprivate extension NSView {
    func setBackground(to color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}

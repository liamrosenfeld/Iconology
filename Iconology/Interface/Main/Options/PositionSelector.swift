//
//  PositionView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PositionSelector: NSControl {
    private var dragFrame = NSRect()
    private var dragerView = NSView()

    var position: CGPoint {
        get {
            // get point
            var point = dragerView.frame.center

            // align (0, 0) to center of parent
            point.x -= self.frame.size.width / 2
            point.y -= self.frame.size.height / 2

            // actual size -> -100...100
            point.x = (point.x / (dragFrame.width / 2)) * 100
            point.y = (point.y / (dragFrame.height / 2)) * 100

            return point
        }
        set {
            // get point
            var point = newValue

            // -100...100 -> actual size
            point.x = (point.x / 100) * (dragFrame.width / 2)
            point.y = (point.y / 100) * (dragFrame.height / 2)

            // align (0, 0) to center of parent
            point.x += self.frame.size.width / 2
            point.y += self.frame.size.height / 2

            // set pos
            dragerView.frame.center = point
        }
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
        layer?.cornerRadius = dragerView.frame.width / 2
    }

    // MARK: - Drag View

    func setupDragView() {
        // size and position
        dragerView = NSView(frame: NSRect(x: 0, y: 0, width: frame.width / 10, height: frame.height / 10))
        dragerView.setBackground(to: .systemBlue)
        dragerView.layer?.cornerRadius = dragerView.frame.width / 2
        position = .zero

        // drag support
        let gesture = DragDetector(target: self, onDrag: #selector(Self.draggedView(_:)), onMouseUp: draggerReleased)
        dragerView.addGestureRecognizer(gesture)
        addSubview(dragerView)

        // set bounds
        dragFrame.size.width = frame.size.width * 0.9
        dragFrame.size.height = frame.size.height * 0.9
        dragFrame.center = frame.center
    }

    private var count = 0
    @objc func draggedView(_ sender: NSPanGestureRecognizer) {
        // get point and vector
        let currentLoc = dragerView.frame.center
        let translation = sender.translation(in: self)

        // get new pos
        let newPos = CGPoint(x: currentLoc.x + translation.x, y: currentLoc.y + translation.y)

        // check bounds
        if !dragFrame.contains(newPos) {
            sender.mouseUp(with: NSEvent())
            sender.setTranslation(CGPoint.zero, in: self)
            return
        }

        // update box
        dragerView.frame.center = newPos

        // send action
        count += 1
        if isContinuous, count % 2 == 0 {
            sendAction(action, to: target)
        }

        // reset translation
        sender.setTranslation(CGPoint.zero, in: self)
    }

    func draggerReleased() {
        sendAction(action, to: target)
    }
}

class DragDetector: NSPanGestureRecognizer {
    var onMouseUp: () -> Void

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        onMouseUp()
    }

    init(target: Any, onDrag: Selector, onMouseUp: @escaping (() -> Void)) {
        self.onMouseUp = onMouseUp
        super.init(target: target, action: onDrag)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

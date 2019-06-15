//
//  SelectPresetViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

protocol SelectPresetDelegate {
    func presetSelected(withIndex index: Int)
    func presetRenamed(to name: String, forIndex index: Int)
    func addPreset(named name: String)
    func removePreset(at index: Int)
    var  presets: [CustomPreset] { get }
}

class SelectPresetViewController: NSViewController {
    
    // MARK: - Setup
    var delegate: SelectPresetDelegate?
    
    @IBOutlet weak var presetTable: NSTableView!
    @IBOutlet weak var manageRowsButton: NSSegmentedControl!
    
    var presetSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetTable.delegate = self
        presetTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedRow), name: NSTableView.selectionDidChangeNotification, object: nil)
    }
    
    // MARK: - Table Updates
    @objc func selectedRow() {
        let selected = presetTable.selectedRow
        if selected != presetSelected {
            presetSelected = selected
            delegate?.presetSelected(withIndex: presetSelected)
            print("Selected: \(presetSelected)")
        }
        
    }
    
    @IBAction func manageRows(_ sender: Any) {
        if manageRowsButton.selectedSegment == 0 {
            newRow()
        } else if manageRowsButton.selectedSegment == 1 {
            removeRow()
        }
    }
    
    func newRow() {
        // Generate Name
        var name = "New Preset"
        var n = 1
        while true {
            let contains = delegate!.presets.contains { $0.name == name }
            if !contains {
                break
            }
            name = "New Preset \(n)"
            n += 1
        }
        
        // Update Data
        delegate?.addPreset(named: name)
        
        // Update Table
        let newIndex = (delegate?.presets.count ?? 1) - 1
        presetTable.insertRows(at: IndexSet(integer: newIndex), withAnimation: .effectFade)
        presetTable.selectRowIndexes(IndexSet(integer: newIndex), byExtendingSelection: false)
    }
    
    func removeRow() {
        let selectedRow = presetTable!.selectedRow
        if selectedRow != -1 {
            // Update Data
            delegate?.removePreset(at: selectedRow)
        
            // Update Table
            presetTable.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
            if selectedRow > Storage.userPresets.presets.count - 1{
                presetTable.selectRowIndexes(IndexSet(integer: selectedRow-1), byExtendingSelection: false)
            } else {
                presetTable.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
            }
        }
        
        // if no row is left
        if presetTable.selectedRow == -1 {
            delegate?.presetSelected(withIndex: -1)
        }
    }
    
    // MARK: - Textbox Management
    func forceSaveText() {
        let selectedColumn = presetTable.selectedColumn
        let selectedRow = presetTable.selectedRow
        if selectedRow != -1 {
            let selected = presetTable.view(atColumn: selectedColumn, row: selectedRow, makeIfNecessary: false) as! NSTableCellView
            textFieldFinishEdit(sender: selected.textField!)
        }
    }
    
    @IBAction func textFieldFinishEdit(sender: NSTextField) {
        let selectedRow = presetTable.selectedRow
        let value = sender.stringValue
        
        // Check Not Duplicate        
        for index in 0..<Storage.userPresets.presets.count {
            if value == Storage.userPresets.presets[index].name && index != selectedRow {
                sender.stringValue = Storage.userPresets.presets[selectedRow].name
                Alerts.warningPopup(title: "Name Already Exists", text: "'\(sender.stringValue)' is Already Taken")
                print("WARN: Name Already Exists")
                return
            }
        }
        
        if selectedRow != -1 {
            delegate?.presetRenamed(to: value, forIndex: selectedRow)
        }
    }
}

// MARK: - Table Setup
extension SelectPresetViewController: NSTableViewDataSource {
    
    func numberOfRows(in presetList: NSTableView) -> Int {
        return delegate?.presets.count ?? 0
    }
    
}

extension SelectPresetViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = delegate!.presets[row]
        let text = item.name

        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "selectTextCell"), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }
    
}

//
//  EditPresetViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class EditPresetViewController: NSViewController {
    
    // MARK: - Setup
    var presetSelected: Int?
    var tempSave: CustomPreset!
    
    @IBOutlet weak var presetTable: NSTableView!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    @IBOutlet weak var prefixCheckBox: NSButton!
    @IBOutlet weak var manageRowsButton: NSSegmentedControl!
    @IBOutlet weak var aspectW: NSTextField!
    @IBOutlet weak var aspectH: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Vars
        tempSave = UserPresets.presets[presetSelected!]
        
        // Add Delegates
        presetTable.delegate = self
        presetTable.dataSource = self
        
        // Prep UI
        titleLabel.stringValue = "Edit \(UserPresets.presets[presetSelected!].name) Preset Via Double Click"
        switch tempSave.usePrefix {
        case true:
            prefixCheckBox.state = .on
        case false:
            prefixCheckBox.state = .off
        }
        aspectW.stringValue = String(tempSave.aspect.w)
        aspectH.stringValue = String(tempSave.aspect.h)
    }
    
    // MARK: - Actions
    @IBAction func apply(_ sender: Any) {
        forceSaveText()
        
        // Set Prefix Bool
        switch prefixCheckBox.state {
        case .on:
            tempSave.usePrefix = true
        case .off:
            tempSave.usePrefix = false
        default:
            print("ERR: Wrong Button State")
        }
        
        // Save Presets
        UserPresets.presets[presetSelected!] = tempSave
        print(UserPresets.presets[presetSelected!])
        UserPresets.savePresets()
        
        // Notify Home
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PresetApply"), object: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let SelectPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SelectPresetViewController")) as? SelectPresetViewController
        view.window?.contentViewController = SelectPresetViewController
    }
    
    @IBAction func manageRows(_ sender: Any) {
        if manageRowsButton.selectedSegment == 0 {
            newRow()
        } else if manageRowsButton.selectedSegment == 1 {
            removeRow()
        }
    }
    
    @IBAction func aspectSelected(_ sender: Any) {
        guard var w = Int(aspectW.stringValue) else {
            Alerts.warningPopup(title: "Non-Integer Inputed", text: "'\(aspectW.stringValue)' is Not an Integer")
            return
        }
        guard var h = Int(aspectH.stringValue) else {
            Alerts.warningPopup(title: "Non-Integer Inputed", text: "'\(aspectH.stringValue)' is Not an Integer")
            return
        }
        
        if w == 0 {
            w = 1
            aspectW.stringValue = "1"
        }
        if h == 0 {
            h = 1
            aspectH.stringValue = "1"
        }
        
        let aspect = Aspect(w: w, h: h)
        tempSave.aspect = aspect
    }
    
    
    // MARK: - Table Updates
    func newRow() {
        // Generate Name
        var name = "New Size"
        var n = 1
        while true {
            var state = "good"
            for size in tempSave.sizes {
                if name == size.name {
                    state = "fail"
                }
            }
            if state != "fail" {
                break
            }
            name = "New Size \(n)"
            n += 1
        }
        
        // Update Data
        tempSave.sizes.append(ImgSetPreset.ImgSetSize(name: name, x: tempSave.aspect.w, y: tempSave.aspect.h))
        
        // Update Table
        presetTable.insertRows(at: IndexSet(integer: tempSave.sizes.count-1), withAnimation: .effectFade)
        presetTable.selectRowIndexes(IndexSet(integer: tempSave.sizes.count-1), byExtendingSelection: false)
    }
    
    func removeRow() {
        let selectedRow = presetTable!.selectedRow
        if selectedRow != -1 {
            // Update Data
            tempSave.sizes.remove(at: selectedRow)
            
            // Update Table
            presetTable.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
            if selectedRow > tempSave.sizes.count - 1{
                presetTable.selectRowIndexes(IndexSet(integer: selectedRow-1), byExtendingSelection: false)
            } else {
                presetTable.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
            }
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
        let column = presetTable.column(for: sender)
        let value = sender.stringValue
        
        if selectedRow != -1 {
            switch column {
            case 0:
                let oldName = tempSave.sizes[selectedRow].name
                for index in 0..<tempSave.sizes.count {
                    if value == tempSave.sizes[index].name && index != selectedRow {
                        sender.stringValue = oldName
                        Alerts.warningPopup(title: "Name Already Exists", text: "'\(value)' is Already Taken")
                        print("WARN: Name Already Exists")
                        return
                    }
                }
                tempSave.sizes[selectedRow].name = value
            case 1:
                guard let intValue = Int(value) else {
                    Alerts.warningPopup(title: "Non-Integer Inputed", text: "'\(value)' is Not an Integer")
                    print("WARN: Non-Integer Inputed")
                    sender.stringValue = String(tempSave.sizes[selectedRow].x)
                    return
                }
                tempSave.sizes[selectedRow].x = intValue
            case 2:
                guard let intValue = Int(value) else {
                    Alerts.warningPopup(title: "Non-Integer Inputed", text: "'\(value)' is Not an Integer")
                    print("WARN: Non-Integer Inputed")
                    sender.stringValue = String(tempSave.sizes[selectedRow].y)
                    return
                }
                tempSave.sizes[selectedRow].y = intValue
            default:
                print("ERR: Column not found")
            }
        }
    }
}


// MARK: - Table Setup
extension EditPresetViewController: NSTableViewDataSource {
    
    func numberOfRows(in presetList: NSTableView) -> Int {
        return UserPresets.presets[presetSelected!].sizes.count
    }
    
}

extension EditPresetViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers: String {
        case nameCell = "nameCellID"
        case xCell = "xCellID"
        case yCell = "yCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text = ""
        var cellIdentifier = ""
        let sizes = tempSave.sizes[row]
        
        if tableColumn == presetTable.tableColumns[0] {
            text = sizes.name
            cellIdentifier = CellIdentifiers.nameCell.rawValue
        } else if tableColumn == presetTable.tableColumns[1] {
            text = String(sizes.x)
            cellIdentifier = CellIdentifiers.xCell.rawValue
        } else if tableColumn == presetTable.tableColumns[2] {
            text = String(sizes.y)
            cellIdentifier = CellIdentifiers.yCell.rawValue
        } else {
            print("Somthing went wrong... \(String(describing: tableColumn))")
        }
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }

}

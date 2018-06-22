//
//  EditPresetViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class EditPresetViewController: NSViewController {
    
    // MARK: - Setup
    var presetSelected: Int?
    var tempSave: Preset?
    var names = [String]()
    
    @IBOutlet weak var presetTable: NSTableView!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    @IBOutlet weak var prefixCheckBox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.stringValue = "Edit \(UserPresets.presets[presetSelected!].name) Preset Via Double Click"
        
        tempSave = UserPresets.presets[presetSelected!]
        names = Array(UserPresets.presets[presetSelected!].sizes.keys).sorted()
        
        presetTable.delegate = self
        presetTable.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        save()
        self.view.window!.close()
    }
    
    @IBAction func backButton(_ sender: Any) {
        back()
    }
    
    @IBAction func textFieldFinishEdit(sender: NSTextField) {
        let selectedRow = presetTable.selectedRow
        let column = presetTable.column(for: sender)
        let value = sender.stringValue
        
        if selectedRow != -1 {
            switch column {
            case 0:
                let oldName = names[selectedRow]
                tempSave?.sizes.changeKey(from: oldName, to: value)
                names[selectedRow] = value
            case 1:
                let name = names[selectedRow]
                tempSave?.sizes[name]?.x = Int(value)!
            case 2:
                let name = names[selectedRow]
                tempSave?.sizes[name]?.y = Int(value)!
            default:
                print("ERR: Column not found")
            }
        }
    }
    
    // MARK: - Functions
    func save() {
        switch prefixCheckBox.state {
        case .on:
            tempSave?.usePrefix = true
        case .off:
            tempSave?.usePrefix = false
        default:
            print("ERR: Wrong Button State")
        }
        
        UserPresets.presets[presetSelected!] = tempSave!
        print(UserPresets.presets[presetSelected!])
        UserPresets.savePresets()
    }
    
    func back() {
        let SelectPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SelectPresetViewController")) as? SelectPresetViewController
        view.window?.contentViewController = SelectPresetViewController
    }
}


// MARK: - Table Setup
extension EditPresetViewController: NSTableViewDataSource {
    
    func numberOfRows(in presetList: NSTableView) -> Int {
        return UserPresets.presets[presetSelected!].sizes.count
    }
    
}

extension EditPresetViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let nameCell = "nameCellID"
        static let xCell = "xCellID"
        static let yCell = "yCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = UserPresets.presets[presetSelected!].sizes
        var text = ""
        var cellIdentifier = ""
        let name = names[row]
        let sizes = item[name]
        
        if tableColumn == presetTable.tableColumns[0] {
            text = name
            cellIdentifier = CellIdentifiers.nameCell
        } else if tableColumn == presetTable.tableColumns[1] {
            text = String(sizes!.x)
            cellIdentifier = CellIdentifiers.xCell
        } else if tableColumn == presetTable.tableColumns[2] {
            text = String(sizes!.y)
            cellIdentifier = CellIdentifiers.yCell
        } else {
            print("Somthing went wrong... \(String(describing: tableColumn))")
        }
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }

}

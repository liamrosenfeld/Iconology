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
    
    @IBOutlet weak var presetTable: NSTableView!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.stringValue = "Edit \(UserPresets.presets[presetSelected!].name) Preset Via Double Click"
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
    
    // MARK: - Functions
    func save() {
        let tableColumns = presetTable.tableColumns
        let rowCount = UserPresets.presets[presetSelected!].sizes.count - 1
        var sizesTemp = [String : size]()
        
        for n in (0...rowCount) {
            let nameCell = tableView(presetTable, viewFor: tableColumns[0], row: n) as! NSTableCellView
            let xCell = tableView(presetTable, viewFor: tableColumns[1], row: n) as! NSTableCellView
            let yCell = tableView(presetTable, viewFor: tableColumns[2], row: n) as! NSTableCellView
            
            let name = nameCell.textField?.stringValue
            let xValue = Int((xCell.textField?.stringValue)!)
            let yValue = Int((yCell.textField?.stringValue)!)
            
            sizesTemp[name!] = size(x: xValue!, y: yValue!)
        }
    }
    
    func back() {
        let SelectPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SelectPresetViewController")) as? SelectPresetViewController
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
        let sortedKeys = Array(item.keys).sorted()
        let name = sortedKeys[row]
        let sizes = item[sortedKeys[row]]
        
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

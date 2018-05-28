//
//  EditPresetViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class EditPresetViewController: NSViewController {
    
    var presetSelected: Int?
    
    @IBOutlet weak var presetTable: NSTableView!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.stringValue = "Edit \(UserPresets.presets[presetSelected!].name) Preset Via Double Click"
        presetTable.delegate = self
        presetTable.dataSource = self
    }
    
    
    @IBAction func save(_ sender: Any) {
        self.view.window!.close()
    }
    
    @IBAction func cancel(_ sender: Any) {
        back()
    }
    
    func back() {
        let SelectPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SelectPresetViewController")) as? SelectPresetViewController
        view.window?.contentViewController = SelectPresetViewController
    }
    
}

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
            text = String(sizes![0])
            cellIdentifier = CellIdentifiers.xCell
        } else if tableColumn == presetTable.tableColumns[2] {
            text = String(sizes![1])
            cellIdentifier = CellIdentifiers.yCell
        } else {
            print("Somthing went wrong... \(String(describing: tableColumn))")
        }
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }
    
}

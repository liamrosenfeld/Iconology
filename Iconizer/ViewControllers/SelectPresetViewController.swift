//
//  SelectPresetViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/19/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class SelectPresetViewController: NSViewController {
    
    @IBOutlet weak var presetTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetTable.delegate = self
        presetTable.dataSource = self
    }
    
    @IBAction func next(_ sender: Any) {
        let presetSelected = presetTable.selectedRow
        if presetSelected >= 0 {
            print(UserPresets.presets[presetSelected].name)
            
            let editPresetViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("EditPresetViewController")) as? EditPresetViewController
            editPresetViewController?.presetSelected = presetSelected
            view.window?.contentViewController = editPresetViewController
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.view.window!.close()
    }
    
    @IBAction func textFieldFinishEdit(sender: NSTextField) {
        let selectedRow = presetTable.selectedRow
        let value = sender.stringValue
        
        if selectedRow != -1 {
            UserPresets.presets[selectedRow].name = value
        }
        
        UserPresets.savePresets()
    }
    
}

extension SelectPresetViewController: NSTableViewDataSource {
    
    func numberOfRows(in presetList: NSTableView) -> Int {
        return UserPresets.presets.count
    }
    
}

extension SelectPresetViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = UserPresets.presets[row]
        let text = item.name

        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "selectTextCell"), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }
    
}

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
    
    // MARK: - Actions
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
        UserPresets.savePresets()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissSheet"), object: nil)
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
    
    @IBAction func addElement(_ sender: Any) {
        // Generate Name
        var name = "New Preset"
        var n = 1
        while true {
            var state = "good"
            for preset in UserPresets.presets {
                if name == preset.name {
                    state = "fail"
                }
            }
            if state != "fail" {
                break
            }
            name = "New Preset \(n)"
            n += 1
        }
        
        // Update Data
        UserPresets.presets.append(Preset(name: name, sizes: [String : size](), usePrefix: false))
        
        // Update Table
        presetTable.beginUpdates()
        presetTable.insertRows(at: IndexSet(integer: UserPresets.presets.count-1), withAnimation: .effectFade)
        presetTable.endUpdates()
    }
    
    @IBAction func removeElement(_ sender: Any) {
        let selectedRow = presetTable!.selectedRow
        if selectedRow != -1 {
            // Update Data
            UserPresets.presets.remove(at: selectedRow)
        
            // Update Table
            presetTable.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
            presetTable.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
        }
    }
}

// MARK: - Table Setup
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

//
//  PresetVC+Delegates.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 11/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension PresetViewController: SelectPresetDelegate {
    func presetSelected(at index: Int) {
        selectedPreset = index
    }

    func addPreset(_ preset: CustomPreset, at index: Int?) {
        let index = index ?? tempPresets.endIndex
        tempPresets.insert(preset, at: index)

        registerUndo {
            $0.removePreset(at: index)
            $0.selectVC.removeTableRow(at: index)
        }

        winController.edited = true
    }

    func removePreset(at index: Int) {
        let removed = tempPresets.remove(at: index)

        registerUndo {
            $0.addPreset(removed, at: index)
            $0.selectVC.addTableRow(at: index)
        }

        winController.edited = true
    }

    func presetRenamed(to name: String, forIndex index: Int) {
        let oldName = tempPresets[index].name
        tempPresets[index].name = name

        registerUndo {
            $0.presetRenamed(to: oldName, forIndex: index)
            $0.selectVC.reload(row: index)
        }

        winController.edited = true
    }

    var presets: [CustomPreset] { tempPresets }
}

extension PresetViewController: EditPresetDelegate {
    func removeSize(at index: Int) {
        let removed = tempPresets[selectedPreset].sizes.remove(at: index)

        registerUndo {
            $0.addSize(removed, at: index)
            $0.editVC.addTableRow(at: index)
        }

        winController.edited = true
    }

    func addSize(_ size: ImgSetPreset.ImgSetSize, at index: Int?) {
        let index = index ?? tempPresets[selectedPreset].sizes.endIndex
        tempPresets[selectedPreset].sizes.insert(size, at: index)

        registerUndo {
            $0.removeSize(at: index)
            $0.editVC.removeTableRow(at: index)
        }

        winController.edited = true
    }

    func changeName(at index: Int, to name: String) {
        let oldName = tempPresets[selectedPreset].sizes[index].name
        tempPresets[selectedPreset].sizes[index].name = name

        registerUndo {
            $0.changeName(at: index, to: oldName)
            $0.editVC.reload(row: index, col: 0)
        }

        winController.edited = true
    }

    func changeWidth(at index: Int, to size: Int) {
        let oldSize = Int(tempPresets[selectedPreset].sizes[index].size.width)
        tempPresets[selectedPreset].sizes[index].size.width = CGFloat(size)

        registerUndo {
            $0.changeWidth(at: index, to: oldSize)
            $0.editVC.reload(row: index, col: 1)
        }

        winController.edited = true
    }

    func changeHeight(at index: Int, to size: Int) {
        let oldSize = Int(tempPresets[selectedPreset].sizes[index].size.height)
        tempPresets[selectedPreset].sizes[index].size.height = CGFloat(size)

        registerUndo {
            $0.changeHeight(at: index, to: oldSize)
            $0.editVC.reload(row: index, col: 2)
        }

        winController.edited = true
    }

    func changeAspect(to aspect: NSSize) {
        let oldAspect = tempPresets[selectedPreset].aspect
        tempPresets[selectedPreset].aspect = aspect

        registerUndo {
            $0.changeAspect(to: oldAspect)
            $0.editVC.reloadAspect()
        }

        winController.edited = true
    }

    var preset: CustomPreset? {
        if selectedPreset >= 0, selectedPreset < tempPresets.count {
            return tempPresets[selectedPreset]
        } else {
            return nil
        }
    }
}

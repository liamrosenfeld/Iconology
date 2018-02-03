//
//  OptionsViewController.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    // Setup
    @IBOutlet weak var iosVersion: NSPopUpButton!
    @IBOutlet weak var iPhoneToggle: NSButton!
    @IBOutlet weak var iPadToggle: NSButton!
    
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageURL!)
    }
    
    // Actions
    @IBAction func convert(_ sender: Any) {
        let iosVersionString = iosVersion.titleOfSelectedItem!
        let iPhoneEnabled = iPhoneToggle.state.rawValue
        let iPadEnabled = iPadToggle.state.rawValue
        
        if iosVersionString == "11" {
            if iPhoneEnabled == 1 {
                
            }
            if iPadEnabled == 1 {
                
            }
        } else if iosVersionString == "10" {
            if iPhoneEnabled == 1 {
                
            }
            if iPadEnabled == 1 {
                
            }
        } else if iosVersionString == "11" {
            if iPhoneEnabled == 1 {
                
            }
            if iPadEnabled == 1 {
                
            }
        }
        
    }
    
}

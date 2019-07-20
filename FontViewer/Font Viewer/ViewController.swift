//
//  ViewController.swift
//  Font Viewer
//
//  Created by Mark Sharvin on 17/07/2019.
//  Copyright © 2019 Mark Sharvin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var fontFamiliesPopup: NSPopUpButton!
    @IBOutlet weak var fontTypePopup: NSPopUpButton!
    @IBOutlet weak var sampleLabel: NSTextField!
    @IBOutlet weak var displayAllButton: NSButton!
    
    var selectedFontFamily: String?
    var fontFamilyMembers = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fontFamiliesPopup.addItems(withTitles: NSFontManager.shared.availableFontFamilies)
        if let firstFont = fontFamiliesPopup.titleOfSelectedItem {
            select(fontFamily: firstFont)
        }
    }
    
    @IBAction func fontFamilyClicked(_ sender: NSPopUpButton) {
        if let fontFamily = sender.titleOfSelectedItem {
            select(fontFamily: fontFamily)
        }
    }
    
    func select(fontFamily:String) {
        selectedFontFamily = fontFamily
        view.window?.title = fontFamily
        fontFamilyMembers.removeAll()
        if let members = NSFontManager.shared.availableMembers(ofFontFamily: fontFamily) {
            makeFontTypeSelection(enabled: true)
            fontFamilyMembers = members
        } else {
            makeFontTypeSelection(enabled: false)
        }
        updateFontTypesPopup()
    }
    
    func makeFontTypeSelection(enabled:Bool) {
        fontTypePopup.isEnabled = enabled
        displayAllButton.isEnabled = enabled
    }
    
    @IBAction func fontTypeClicked(_ sender: NSPopUpButton) {
        selectFontTypeAt(index: sender.indexOfSelectedItem)
    }
    
    func selectFontTypeAt(index:Int) {
        if fontFamilyMembers.count == 0 {
            print("No Family members for the selected font")
            sampleLabel.stringValue = ""
            return
        }
        
        let selectedMember = fontFamilyMembers[index]
        if let postscriptName = selectedMember[0] as? String, let weight = selectedMember[2] as? Int, let traits = selectedMember[3] as? UInt, let fontFamily = selectedFontFamily {
            display(text: postscriptName, fontFamily: fontFamily, fontWeight: weight, traits: traits)
        }
    }
    
    func display(text:String, fontFamily:String, fontWeight: Int, traits: UInt) {
        let font = NSFontManager.shared.font(withFamily: fontFamily,
                                             traits: NSFontTraitMask(rawValue: traits),
                                             weight: fontWeight,
                                             size: 19.0)
        sampleLabel.font = font
        sampleLabel.stringValue = text
    }
    
    @IBAction func displayAllFonts(_ sender: Any) {
        let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        if let fontsDisplayWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(stringLiteral: "fontsDisplay")) as? NSWindowController {
            if let fontsDisplayViewController = fontsDisplayWindowController.contentViewController as? FontsDisplayViewController {
                fontsDisplayViewController.selectedFontFamily = selectedFontFamily
                fontsDisplayViewController.fontFamilyMembers = fontFamilyMembers
            }
            fontsDisplayWindowController.showWindow(nil)
        }
        
    }

    func setupUI() {
        fontFamiliesPopup.removeAllItems()
        fontTypePopup.removeAllItems()
        sampleLabel.stringValue = ""
        sampleLabel.alignment = .center
    }
    
    func updateFontTypesPopup() {
        fontTypePopup.removeAllItems()
        for member in fontFamilyMembers {
            if let fontType = member[1] as? String {
                fontTypePopup.addItem(withTitle: fontType)
            }
        }
        selectFontTypeAt(index: 0)
    }

}


//
//  FontsDisplayViewController.swift
//  Font Viewer
//
//  Created by Mark Sharvin on 20/07/2019.
//  Copyright © 2019 Mark Sharvin. All rights reserved.
//

import Cocoa

class FontsDisplayViewController: NSViewController {
    @IBOutlet weak var fontsTextView: NSTextView!
    
    var selectedFontFamily: String?
    var fontFamilyMembers = [[Any]]()
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setupTextView()
        showFonts()
    }
    
    func setupTextView() {
        fontsTextView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.enclosingScrollView?.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.isEditable = false
        fontsTextView.enclosingScrollView?.autohidesScrollers = true
    }
    
    func showFonts() {
        guard let fontFamily = selectedFontFamily else {
            return
        }
        var fontPostScriptNames = ""
        var lengths = [Int]()
        for member in fontFamilyMembers {
            if let postscript = member[0] as? String {
                fontPostScriptNames += "\(postscript)\n"
                lengths.append(postscript.count)
            }
        }
        
        let fontsDisplayString = NSMutableAttributedString(string: fontPostScriptNames)
        for (index, member) in fontFamilyMembers.enumerated() {
            if let weight = member[2] as? Int, let traits = member[3] as? UInt {
                if let font = NSFontManager.shared.font(withFamily: fontFamily, traits: NSFontTraitMask(rawValue: traits), weight: weight, size: 19) {
                    let range = rangeOf(lengths: lengths, at: index)
                    fontsDisplayString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
                }
            }
        }
        fontsDisplayString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.white, range: NSMakeRange(0, fontsDisplayString.string.count))

        fontsTextView.textStorage?.setAttributedString(fontsDisplayString)
        
    }
    
    func rangeOf(lengths:[Int], at index:Int) -> NSRange {
        var location = 0
        if index > 0 {
            for i in 0..<index {
                location += lengths[i] + 1
            }
        }
        
        let range = NSMakeRange(location, lengths[index])
        return range
    }
    
    @IBAction func close(_ sender: Any) {
        view.window?.close()
    }
    
}

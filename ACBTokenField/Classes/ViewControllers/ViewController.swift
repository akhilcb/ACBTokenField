//
//  ViewController.swift
//  ACBTokenField
//
//  Created by Akhil on 7/30/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var tokenFieldRandom: NSTokenField!
    @IBOutlet var tokenFieldMovie: NSTokenField!
    @IBOutlet weak var enableClearButton: NSButton!
    @IBOutlet weak var enableSearchIcon: NSButton!
    @IBOutlet weak var setCustomLeftView: NSButton!
    @IBOutlet weak var enableTokenMenu: NSButton!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textViewMovie: NSTextView!
    
    let actors = ["Ryan Gosling", "Ryan Reynolds", "Jeremy Renner", "Chris Pratt", "Bradley Cooper"]
    let actresses = ["Emma Stone", "Blake Lively", "Amy Adams", "Jennifer Lawrence"]
    let movies = ["La La Land", "Green Lantern", "Arrival", "Passengers", "Silver Linings Playbook"]
    let years = ["2011", "2012", "2013", "2014", "2016", "2017"]
    
    var actorsMenu = NSMenu()
    var actressMenu = NSMenu()
    var moviesMenu = NSMenu()
    var yearsMenu = NSMenu()
    
    lazy var imageView: NSImageView = {
        if #available(OSX 10.12, *) {
            return NSImageView(image: NSImage(named: "Lock")!)
        } else {
            // Fallback on earlier versions
            let imageView = NSImageView()
            imageView.image = NSImage(named: "Lock")!
            return imageView
        }
    }()
    
    
    // #MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        var button: NSButton!
        if #available(OSX 10.12, *) {
            button = NSButton(image: NSImage(named: "Lock")!,
                              target: self,
                              action: #selector(self.lockButtonTapped(_:)))
        } else {
            // Fallback on earlier versions
            button = NSButton()
            button.image = NSImage(named: "Lock")!
            button.target = self
            button.action = #selector(self.lockButtonTapped(_:))
        }
        button.setButtonType(NSButtonType.momentaryChange)
        button.isBordered = false
        
        tokenFieldRandom.placeholderString = "Enter tokens in following order: Country Food Animal Vehicle Color(this can repeat)"
        
        //convert tokenField to ACBTokenField
        tokenFieldRandom.convertToACBTokenField()
        
        //set any required properties
        tokenFieldRandom.shouldEnableTokenMenu = true
        tokenFieldRandom.tokenKeywordsList = [["France", "Germany", "Italy", "USA", "Spain", "India", "Brazil"],
                                        ["Pizza", "Pasta", "Butter Chicken", "Jamon", "Cheesecake"],
                                        ["Deer", "Dog", "Bear", "Panda", "Jaguar", "Bull"],
                                        ["Car", "Truck", "Bus", "Motorcycle", "Minivan"]]
        
        tokenFieldRandom.defaultTokenKeywords = ["Red", "Blue", "Green", "White", "Purple", "Black"]
        tokenFieldRandom.tokenDelegate = self
        tokenFieldRandom.shouldDisplaySearchIcon = true
        
        //convert tokenField to ACBTokenField
        tokenFieldMovie.convertToACBTokenField()
        
        //set any required properties
        tokenFieldMovie.shouldEnableTokenMenu = true
        tokenFieldMovie.tokenDelegate = self
        tokenFieldMovie.leftView = button
        
        tokenFieldRandom.didDeleteTokenBlock = { (tokenIndex, _) in
            print("Random: Token at index = ", tokenIndex, "is removed")
        }
        
        tokenFieldMovie.didDeleteTokenBlock = { (tokenIndex, _) in
            print("Movie: Token at index = ", tokenIndex, "is removed")
        }
    }
    
    
    // #MARK: Private
    
    private func setupViews() {
        setupMenu(actorsMenu, nameList: actors)
        setupMenu(actressMenu, nameList: actresses)
        setupMenu(moviesMenu, nameList: movies)
        setupMenu(yearsMenu, nameList: years)
        
        enableTokenMenu.state = NSOnState
        enableSearchIcon.state = NSOnState
        setCustomLeftView.state = NSOffState
        enableTokenMenu.state = NSOnState
    }
    
    private func setupMenu(_ menu: NSMenu, nameList: [String]) {
        nameList.forEach {
            menu.addItem(withTitle: $0,
                         action: #selector(menuItemTapped(_:)),
                         keyEquivalent: "").target = self
        }
    }
    
    @objc private func lockButtonTapped(_ sender: Any?) {
        tokenFieldMovie.isEnabled = !tokenFieldMovie.isEnabled
        
        if !tokenFieldMovie.isEnabled {
            textViewMovie.string = "TokenField disabled! Tap again on Lock icon to enable"
        } else {
            textViewMovie.string = "TokenField enabled!"
        }
    }
    
    @objc private func menuItemTapped(_ menuItem: NSMenuItem) {
        if let fieldEditor = tokenFieldMovie?.currentEditor() {
            let textRange = fieldEditor.selectedRange
            let replaceString = menuItem.title
            fieldEditor.replaceCharacters(in: textRange, with: replaceString)
            fieldEditor.selectedRange = NSMakeRange(textRange.location, replaceString.count)
        }
    }
    
    
    // #MARK: IBAction
    
    @IBAction func enableClearButton(_ sender: NSButton) {
        tokenFieldRandom.shouldDisplayClearButton = sender.state == NSOnState
    }

    @IBAction func enableSearchIcon(_ sender: NSButton) {
        if sender.state == NSOnState {
            setCustomLeftView.state = NSOffState
            tokenFieldRandom.leftView = nil
        }
        tokenFieldRandom.shouldDisplaySearchIcon = sender.state == NSOnState
    }
    
    @IBAction func setLeftView(_ sender: NSButton) {
        if sender.state == NSOnState {
            tokenFieldRandom.leftView = imageView
            enableSearchIcon.state = NSOffState
        } else {
            tokenFieldRandom.leftView = nil
        }
    }
    
    @IBAction func enableTokenMenu(_ sender: NSButton) {
        tokenFieldRandom.shouldEnableTokenMenu = sender.state == NSOnState
        tokenFieldRandom.resetTokens()
    }
    
    @IBAction func resultTapped(_ sender: Any) {
        textView.string = tokenFieldRandom.tokenStringValue
    }
    
    @IBAction func resultMovieTapped(_ sender: Any) {
        textViewMovie.string = tokenFieldMovie.tokenStringValue
    }
    
}


extension ViewController: NSTokenFieldDelegate {
    
     public func tokenField(_ tokenField: NSTokenField, styleForRepresentedObject representedObject: Any) -> NSTokenStyle {
        
        return .rounded
    }

    public func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        
        switch tokenIndex {
            case 0:
                return actors
            case 1:
                return actresses
            case 2:
                return movies
            case 3:
                return years
            default:
                return nil
        }
    }

    public func tokenField(_ tokenField: NSTokenField, hasMenuForRepresentedObject representedObject: Any) -> Bool {
        if let tokenIndex = tokenField.tokenIndex(forRepresentedObject: representedObject),
            (0..<5).contains(tokenIndex) {
            
            return true
        }
        
        return false
    }
    
    public func tokenField(_ tokenField: NSTokenField, menuForRepresentedObject representedObject: Any) -> NSMenu? {
        if let tokenIndex = tokenField.tokenIndex(forRepresentedObject: representedObject),
            (0..<5).contains(tokenIndex) {
            
            switch tokenIndex {
                case 0:
                    return actorsMenu
                case 1:
                    return actressMenu
                case 2:
                    return moviesMenu
                case 3:
                    return yearsMenu
                default:
                    return nil
            }
        }
        
        return nil
    }
}


//
//  NSTokenField+ACBExtension.swift
//  ACBTokenField
//
//  Created by Akhil on 7/30/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import Cocoa

extension NSTokenField {
    
    fileprivate struct Keys {
        static fileprivate var tokenKeywordsList: UInt8 = 0
        static fileprivate var tokenFieldController: UInt8 = 0
        static fileprivate var tokenDelegate: UInt8 = 0
        static fileprivate var shouldEnableTokenMenu: UInt8 = 0
        static fileprivate var tokens: UInt8 = 0
        static fileprivate var defaultTokenKeywords: UInt8 = 0
        static fileprivate var leftView: UInt8 = 0
        static fileprivate var clearButton: UInt8 = 0
        static fileprivate var shouldDisplayClearButton: UInt8 = 0
        static fileprivate var viewPadding: UInt8 = 0
        static fileprivate var shouldDisplaySearchIcon: UInt8 = 0
        static fileprivate var clearIconName: UInt8 = 0
        static fileprivate var searchIconName: UInt8 = 0
    }
    
    
    // # MARK: Public stored property
    
    public var defaultTokenKeywords: [String]? {
        get { return associated(key: &Keys.defaultTokenKeywords) ?? nil }
        set {
            associate(key: &Keys.defaultTokenKeywords, value: newValue)
            self.tokenFieldController.updateDefaultTokenMenuWithNewKeywords(newValue)
        }
    }
    
    public var tokenKeywordsList: [[String]]? {
        get { return associated(key: &Keys.tokenKeywordsList) ?? nil }
        set {
            associate(key: &Keys.tokenKeywordsList, value: newValue)
            self.tokenFieldController.updateTokenMenuWithNewKeywords(newValue)
        }
    }
    
    public var shouldEnableTokenMenu: Bool {
        get { return associated(key: &Keys.shouldEnableTokenMenu) { false }! }
        set { associate(key: &Keys.shouldEnableTokenMenu, value: newValue)
            if let _ = self.cell as? ACBTokenFieldCell {
                self.setNeedsDisplay()
            }
        }
    }
    
    public var tokenDelegate: NSTokenFieldDelegate? {
        get { return associated(key: &Keys.tokenDelegate) ?? nil }
        set { associate(key: &Keys.tokenDelegate, value: newValue) }
    }
    
    public var leftView: NSView? {
        get { return associated(key: &Keys.leftView) ?? nil }
        set {
            if let oldView: NSView = associated(key: &Keys.leftView) {
                oldView.removeFromSuperview()
            }
            
            associate(key: &Keys.leftView, value: newValue)
            if let cell = self.cell as? ACBTokenFieldCell {
                cell.shouldDisplayLeftView = (newValue != nil)
                if let newView = newValue {
                    newView.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
                    self.addSubview(newView)
                }
                self.setNeedsDisplay()
            }
        }
    }
    
    public var shouldDisplayClearButton: Bool {
        get { return associated(key: &Keys.shouldDisplayClearButton) { true }! }
        set { associate(key: &Keys.shouldDisplayClearButton, value: newValue)
            if let cell = self.cell as? ACBTokenFieldCell {
                cell.shouldDisplayClearButton = newValue
                self.setNeedsDisplay()
            }
            self.handleClearButton()
        }
    }
    
    public var shouldDisplaySearchIcon: Bool {
        get { return associated(key: &Keys.shouldDisplaySearchIcon) { false }! }
        set { associate(key: &Keys.shouldDisplaySearchIcon, value: newValue)
            if !newValue {
                self.leftView = nil
                if let cell = self.cell as? ACBTokenFieldCell {
                    cell.shouldDisplayLeftView = false
                }
            } else if self.leftView == nil {
                if let cell = self.cell as? ACBTokenFieldCell {
                    cell.shouldDisplayLeftView = true
                }
                
                //if left view is present, dont change it
                self.setupSearchIconView()
            }
        }
    }
    
    public var clearIconName: String {
        get { return associated(key: &Keys.clearIconName) { "ClearDarkGray" }! }
        set { associate(key: &Keys.clearIconName, value: newValue) }
    }
    
    public var searchIconName: String {
        get { return associated(key: &Keys.searchIconName) { "Glass" }! }
        set { associate(key: &Keys.searchIconName, value: newValue) }
    }
    
    
    // # MARK: Public computed property
    
    public var tokenStringValue: String {
        var string = ""
        if let tokens = self.objectValue as? [ACBToken] {
            let stringList = tokens.map { $0.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            string = stringList.joined(separator: " ")
        } else if let tokens = self.objectValue as? [String] {
            string = tokens.joined(separator: " ")
        }
        
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    // # MARK: Private property
    
    fileprivate var tokenFieldController: ACBTokenFieldController {
        get { return associated(key: &Keys.tokenFieldController) { ACBTokenFieldController() }! }
        set { associate(key: &Keys.tokenFieldController, value: newValue) }
    }
    
    fileprivate var tokens: [ACBToken] {
        get { return associated(key: &Keys.tokens) { [] }! }
        set { associate(key: &Keys.tokens, value: newValue) }
    }
    
    fileprivate var clearButton: NSButton {
        get {
            return associated(key: &Keys.clearButton) {
                let button = NSButton(image: NSImage(named: self.clearIconName)!,
                                      target: self,
                                      action: #selector(self.clearButtonTapped(_:)))
                button.setButtonType(NSButtonType.momentaryChange)
                button.isBordered = false
                return button
                }!
        }
        set { associate(key: &Keys.clearButton, value: newValue) }
    }

    fileprivate var viewPadding: CGFloat {
        get { return associated(key: &Keys.viewPadding) { 21 }! }
        set { associate(key: &Keys.viewPadding, value: newValue) }
    }

    fileprivate func handleClearButton() {
        if shouldDisplayClearButton == false {
            self.clearButton.isHidden = true
        } else {
            let string = self.currentEditor()?.string ?? ""
            self.clearButton.isHidden = (string.count == 0)
        }
    }
    
    
    // # MARK: Private method
    
    @objc private func clearButtonTapped(_ sender: Any?) {
        self.stringValue = ""
        handleClearButton()
    }

    private func setupCellToField() {
        let isBorderedTemp  = self.isBordered
        let backgroundColorTemp = self.backgroundColor
        let isBezeledTemp = self.isBezeled
        let bezelStyleTemp = self.bezelStyle
        let isEnabledTemp = self.isEnabled
        let isEditableTemp = self.isEditable
        let isSelectabletemp = self.isSelectable
        let placeholderAttributedStringTemp = self.placeholderAttributedString
        let placeholderStringTemp = self.placeholderString
        
        let cell = ACBTokenFieldCell(textCell: "")
        cell.padding = viewPadding
        self.cell = nil
        self.cell = cell
        self.isBordered = isBorderedTemp
        self.backgroundColor = backgroundColorTemp
        self.isBezeled = isBezeledTemp
        self.bezelStyle = bezelStyleTemp
        self.isEnabled = isEnabledTemp
        self.isEditable = isEditableTemp
        self.isSelectable = isSelectabletemp
        if placeholderAttributedStringTemp != nil {
            self.placeholderAttributedString = placeholderAttributedStringTemp
        } else if placeholderStringTemp != nil {
            self.placeholderString = placeholderStringTemp
        } else {
            self.placeholderString = placeholderStringTemp
            self.placeholderAttributedString = placeholderAttributedStringTemp
        }
    }
    
    private func setupSearchIconView() {
        let searchImageView = NSImageView(image: NSImage(named: self.searchIconName)!)
        self.leftView = searchImageView
    }
    
    private func setupConstraintOnClearButton() {
        let rightConstraint = NSLayoutConstraint(item: clearButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: clearButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: clearButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: viewPadding)
        let heightConstraint = NSLayoutConstraint(item: clearButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: viewPadding)
        self.addConstraints([rightConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    
    // # MARK: Public method
    
    public func convertToACBTokenField() {
        tokenFieldController.tokenField = self
        setupCellToField()
        
        shouldDisplayClearButton = true
        let x = self.frame.size.width - viewPadding - 3
        let y = (self.frame.size.height - viewPadding) / 2
        clearButton.frame = CGRect(x: x,
                                        y: y,
                                        width: viewPadding,
                                        height: viewPadding)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(clearButton)
        setupConstraintOnClearButton()
        
        handleClearButton()
        self.delegate = tokenFieldController
    }
    
    public func addToken(name: String) {
        var currentTokens: [ACBToken]
        if let array = self.objectValue as? [ACBToken] {
            currentTokens = array
        } else {
            currentTokens = []
        }
        
        let token = ACBToken(name: name)
        currentTokens.append(token)
        
        self.objectValue = currentTokens
        
        if let fieldEditor = self.currentEditor() {
            fieldEditor.selectedRange = NSMakeRange(fieldEditor.string?.count ?? 0, 0)
        }
    }
    
    //calculate token index based on currentEditor's selectedRange and string
    public func selectedTokenIndex() -> Int? {
        var tokenIndex = 0
        let selectedRange = self.currentEditor()?.selectedRange
        let rangeLocation = selectedRange?.location ?? 0
        
        let string = self.currentEditor()?.string as NSString?
        if let subString = string?.substring(to: rangeLocation) as NSString? {
            let maxIndex = subString.length
            
            for i in 0..<maxIndex {
                if subString.character(at: i) == unichar(NSAttachmentCharacter) {
                    tokenIndex += 1
                }
            }
        } else {
            return nil
        }
        
        return tokenIndex
    }
    
    public func tokenIndex(forRepresentedObject representedObject: Any) -> Int? {
        guard let token = representedObject as? ACBToken else {
            
            return nil
        }
        
        let tokens = self.tokens
        let tokenIndex = tokens.index(of: token)
        
        return tokenIndex
    }
    
    public func resetTokens() {
        self.objectValue = nil
        self.objectValue = self.tokens
    }
    
}


fileprivate class ACBTokenFieldController: NSObject, NSTokenFieldDelegate {
    
    fileprivate weak var tokenField: NSTokenField?
    fileprivate var tokenMenuList: [NSMenu]?
    fileprivate var defaultTokenMenu: NSMenu?
    
//TODO: This doesn't work due to a swift compiler issue since tokenField is weak
//    private static var tokenContext = 0
    
//    @objc var tokenField: NSTokenField? {
//        didSet {
//            setupObservers()
//        }
//    }
//    
//    deinit {
//        removeObserver(self, forKeyPath: #keyPath(tokenField.delegate), context: &ACBTokenFieldController.tokenContext)
//    }
//    
//    func setupObservers() {
//        self.addObserver(self, forKeyPath: #keyPath(tokenField.delegate), options: [.old, .new], context: &ACBTokenFieldController.tokenContext)
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if context == &ACBTokenFieldController.tokenContext {
//            if keyPath == #keyPath(tokenField.delegate) {
//                if (tokenField!.delegate is ACBTokenFieldController) == false {
//                    tokenField!.tokenDelegate = tokenField!.delegate
//                    tokenField!.delegate = self
//                }
//            }
//        }
//    }
    
    // # MARK: Forward Invocation methods
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let tokenDelegate = tokenField?.tokenDelegate,
            tokenDelegate.responds(to: aSelector) {
            
            return tokenDelegate
        }
        
        return super.forwardingTarget(for: aSelector)
    }
    
    
    override func responds(to aSelector: Selector!) -> Bool {
        
        if let tokenDelegate = tokenField?.tokenDelegate {
            
            return tokenDelegate.responds(to: aSelector) || super.responds(to: aSelector)
        }
        
        return super.responds(to: aSelector)
    }
    
    
    override func controlTextDidChange(_ obj: Notification) {
        tokenField?.handleClearButton()
    }
    
    
    // # MARK: NSTokenFieldDelegate methods
    
    func tokenField(_ tokenField: NSTokenField,
                    completionsForSubstring substring: String,
                    indexOfToken tokenIndex: Int,
                    indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        //tokenIndex is always returning 0 due to an appkit bug
        let newTokenIndex = tokenField.selectedTokenIndex() ?? 0
        
        if let tokenKeywordsList = tokenField.tokenKeywordsList,
            tokenKeywordsList.count > newTokenIndex {
            let tokenKeywords = tokenKeywordsList[newTokenIndex]
            let filtered = tokenKeywords.filter { $0.lowercased().hasPrefix(substring.lowercased()) }
            
            return filtered
        } else if let tokenKeywords = tokenField.defaultTokenKeywords {
            let filtered = tokenKeywords.filter { $0.lowercased().hasPrefix(substring.lowercased()) }
            
            return filtered
        } else if let tokenDelegate = tokenField.tokenDelegate,
            tokenDelegate.responds(to: #selector(tokenField(_:completionsForSubstring:indexOfToken:indexOfSelectedItem:))) {
            if let tokenKeywords = tokenDelegate.tokenField!(tokenField,
                                                           completionsForSubstring: substring,
                                                           indexOfToken: newTokenIndex,
                                                           indexOfSelectedItem: selectedIndex) as? [String] {
            
                let filtered = tokenKeywords.filter { $0.lowercased().hasPrefix(substring.lowercased()) }
                return filtered
            }
        }

        return nil
    }
    
    
    func tokenField(_ tokenField: NSTokenField,
                    displayStringForRepresentedObject representedObject: Any) -> String? {
        if let token = representedObject as? ACBToken {
            return token.name
        }
        
        if let string = representedObject as? String {
            return string
        } else if let tokenDelegate = tokenField.tokenDelegate,
            tokenDelegate.responds(to: #selector(tokenField(_:displayStringForRepresentedObject:))) {
            if let string = tokenDelegate.tokenField!(tokenField,
                                                      displayStringForRepresentedObject:representedObject) {
                
                return string
            }
        }
        
        return nil
    }
    
    
    func tokenField(_ tokenField: NSTokenField,
                    hasMenuForRepresentedObject representedObject: Any) -> Bool {
        guard let tokenField = self.tokenField,
            (tokenField.shouldEnableTokenMenu == true) else {
                
                return false
        }
        
        let tokenMenu = tokenMenuFor(representedObject: representedObject)
        if (tokenMenu != nil) {
            
            return true
        } else if let tokenDelegate = tokenField.tokenDelegate,
            tokenDelegate.responds(to: #selector(tokenField(_:hasMenuForRepresentedObject:))) {
            
            let hasMenu = tokenDelegate.tokenField!(tokenField,
                                                    hasMenuForRepresentedObject:representedObject)
            return hasMenu
        }
        
        return false
    }
    
    
    func tokenField(_ tokenField: NSTokenField,
                    menuForRepresentedObject representedObject: Any) -> NSMenu? {
        let tokenMenu = tokenMenuFor(representedObject: representedObject)
        updateTokenMenuState(tokenMenu: tokenMenu, representedObject: representedObject)
        
        if (tokenMenu != nil) {
            return tokenMenu
        } else if let tokenDelegate = tokenField.tokenDelegate,
            tokenDelegate.responds(to: #selector(tokenField(_:menuForRepresentedObject:))) {
            
            let menu = tokenDelegate.tokenField!(tokenField,
                                                 menuForRepresentedObject:representedObject)
            return menu
        }
        
        return nil
    }
    
    
    func tokenField(_ tokenField: NSTokenField,
                    representedObjectForEditing editingString: String) -> Any {
        let token = ACBToken(name: editingString)
        
        return token
    }
    
    
    func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
        DispatchQueue.main.async {
            if let objects = tokenField.objectValue as? [ACBToken] {
                tokenField.tokens = objects
            }
        }
        
        if let tokenDelegate = tokenField.tokenDelegate,
            tokenDelegate.responds(to: #selector(tokenField(_:shouldAdd:at:))) {
            
            let newTokens = tokenDelegate.tokenField!(tokenField,
                                                      shouldAdd:tokens,at:index)
            return newTokens
        }
        
        return tokens
    }
    
    
    // # MARK: Private methods
    
    //return token menu associated with a clicked token
    private func tokenMenuFor(representedObject: Any) -> NSMenu? {
        let tokenIndex = tokenField!.tokenIndex(forRepresentedObject: representedObject) ?? 0
        
        if let tokenMenuList = self.tokenMenuList,
            tokenMenuList.count > tokenIndex {
            let tokenMenu = tokenMenuList[tokenIndex]
            
            return tokenMenu
        } else {
            
            return self.defaultTokenMenu
        }
    }
    
    //update token menu state to on if the menu item name matches clicked token
    private func updateTokenMenuState(tokenMenu: NSMenu?, representedObject: Any) {
        guard let tokenMenu = tokenMenu else {
            return
        }
        
        if let token = representedObject as? ACBToken {
            tokenMenu.items.forEach { menuItem in
                menuItem.state = (menuItem.title == token.name) ? NSOnState : NSOffState
            }
        } else if let token = representedObject as? String {
            tokenMenu.items.forEach { menuItem in
                menuItem.state = (menuItem.title == token) ? NSOnState : NSOffState
            }
        }
    }
    
    @objc private func menuItemTapped(_ menuItem: NSMenuItem) {
        if let fieldEditor = tokenField?.currentEditor() {
            let textRange = fieldEditor.selectedRange
            let replaceString = menuItem.title
            fieldEditor.replaceCharacters(in: textRange, with: replaceString)
            fieldEditor.selectedRange = NSMakeRange(textRange.location, replaceString.count)
        }
    }
    
    
    // # MARK: FilePrivate methods
    
    fileprivate func updateTokenMenuWithNewKeywords(_ tokenKeywordsList: [[String]]?) {
        if let tokenKeywordsList = tokenField?.tokenKeywordsList,
            tokenKeywordsList.isEmpty == false {
            
            if let tokenMenuList = tokenMenuList {
                tokenMenuList.forEach { $0.removeAllItems() }
            } else {
                tokenMenuList = []
                let count = tokenKeywordsList.count
                (0..<count).forEach { _ in tokenMenuList!.append(NSMenu()) }
            }
            
            for (index, tokenKeywords) in tokenKeywordsList.enumerated() {
                let tokenMenu: NSMenu = tokenMenuList![index]
                tokenKeywords.forEach {
                    tokenMenu.addItem(withTitle: $0,
                                      action: #selector(menuItemTapped(_:)),
                                      keyEquivalent: "").target = self
                }
            }
        } else {
            if var tokenMenuList = self.tokenMenuList {
                tokenMenuList.forEach { $0.removeAllItems() }
                tokenMenuList.removeAll()
            }
            self.tokenMenuList = nil
        }
    }
    
    fileprivate func updateDefaultTokenMenuWithNewKeywords(_ tokenKeywords: [String]?) {
        if let tokenKeywords = tokenField?.defaultTokenKeywords,
            tokenKeywords.isEmpty == false {
            if defaultTokenMenu == nil {
                defaultTokenMenu = NSMenu()
            } else {
                defaultTokenMenu!.removeAllItems()
            }
            tokenKeywords.forEach {
                defaultTokenMenu!.addItem(withTitle: $0,
                                          action: #selector(menuItemTapped(_:)),
                                          keyEquivalent: "").target = self
            }
        } else {
            defaultTokenMenu = nil
        }
    }
    
}


fileprivate class ACBTokenFieldCell: NSTokenFieldCell {
    fileprivate var shouldDisplayClearButton = true
    fileprivate var shouldDisplayLeftView = false
    fileprivate var padding: CGFloat = 21
    
    fileprivate func tokenFieldRect(forBounds rect: NSRect) -> NSRect {
        var titleFrame = rect
        let newPadding = padding - 3
        
        if shouldDisplayLeftView {
            var origin = titleFrame.origin
            origin.x += newPadding
            titleFrame.origin = origin
        }
        
        var size = titleFrame.size
        
        if shouldDisplayClearButton {
            size.width -= newPadding
        }
        if shouldDisplayLeftView {
            size.width -= newPadding
        }
        
        titleFrame.size = size
        
        return titleFrame
    }
    
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let titleRect = tokenFieldRect(forBounds: rect)
        let newRect = super.drawingRect(forBounds: titleRect)
        return newRect
    }
    
}

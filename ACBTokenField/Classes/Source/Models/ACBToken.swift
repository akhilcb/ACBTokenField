//
//  ACBToken.swift
//  ACBTokenField
//
//  Created by Akhil on 7/30/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Cocoa

class ACBToken: NSObject, NSCoding {
    
    // # MARK: Public
    
    var name: String
    
    // # MARK: Public Method
    
    init(name: String) {
        self.name = name
    }
    
    // # MARK: NSCoding
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject() as? String {
            self.name = name
        } else {
            self.name = ""
        }
    }
    
}

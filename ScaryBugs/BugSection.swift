//
//  BugSection.swift
//  ScaryBugs
//
//  Created by User on 8/3/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class BugSection: NSObject {
    
    let howScary: ScaryFactor
    var bugs = [ScaryBug]()
    
    init(howScary: ScaryFactor) {
        self.howScary = howScary
    }
    
    static func ==(lhs: BugSection, rhs: BugSection) -> Bool {
        var isEqual = false
        if (lhs.howScary == rhs.howScary && lhs.bugs.count == rhs.bugs.count) {
            isEqual = true
        }
        return isEqual
    }
}

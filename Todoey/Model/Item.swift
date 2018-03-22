//
//  Item.swift
//  Todoey
//
//  Created by Satya on 3/2/18.
//  Copyright © 2018 angkorsoft. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
}



























//
//  Category.swift
//  Todoey
//
//  Created by Satya on 4/22/18.
//  Copyright © 2018 angkorsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}

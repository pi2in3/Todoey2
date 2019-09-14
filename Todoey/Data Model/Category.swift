//
//  Category.swift
//  Todoey
//
//  Created by Ho3in on 7/30/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

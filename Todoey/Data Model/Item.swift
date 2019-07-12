//
//  Item.swift
//  Todoey
//
//  Created by Ho3in on 7/8/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = String()
    var done: Bool = false
}

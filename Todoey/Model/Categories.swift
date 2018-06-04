//
//  Category.swift
//  Todoey
//
//  Created by Alex on 6/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    let items = List<Item>()
}

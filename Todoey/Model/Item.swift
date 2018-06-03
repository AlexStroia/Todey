//
//  Item.swift
//  Todoey
//
//  Created by Alex on 6/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title: String = " "
    @objc dynamic var checked: Bool = false
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
}

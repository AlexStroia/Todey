//
//  CategoryRealm.swift
//  Todoey
//
//  Created by Alex on 6/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}

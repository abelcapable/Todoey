//
//  Item.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 02. 11..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

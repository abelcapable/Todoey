//
//  Category.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 02. 11..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}

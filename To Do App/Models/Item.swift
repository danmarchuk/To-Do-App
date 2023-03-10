//
//  Item.swift
//  To Do App
//
//  Created by Данік on 29/01/2023.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Double = 0.0
    // create a backward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

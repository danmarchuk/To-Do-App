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
    // create a backward relationship
    var parentCategory = LinkingObjects(fromType: Kategory.self, property: "items")
}

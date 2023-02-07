//
//  Kategory.swift
//  To Do App
//
//  Created by Данік on 29/01/2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    // create a forward relationship
    let items = List<Item>()
}

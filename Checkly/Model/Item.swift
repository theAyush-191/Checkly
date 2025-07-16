//
//  Itme.swift
//  Checkly
//
//  Created by Ayush Singh on 13/07/25.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    let parentCategory=LinkingObjects(fromType: Category.self, property: "items")
}

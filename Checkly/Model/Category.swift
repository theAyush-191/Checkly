//
//  Data.swift
//  Checkly
//
//  Created by Ayush Singh on 11/07/25.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String=""
    let items=List<Item>()
}

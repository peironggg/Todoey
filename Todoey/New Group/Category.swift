//
//  Data.swift
//  Todoey
//
//  Created by Wu Peirong on 23/2/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    var items = List<Item>()
}

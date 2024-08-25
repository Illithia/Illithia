//
//  Group.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import Foundation
import RealmSwift

class Group: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
}

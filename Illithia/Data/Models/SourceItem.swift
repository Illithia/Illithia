//
//  SourceItem.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import Foundation
import RealmSwift

class SourceItem: Object, Identifiable {
    @Persisted(primaryKey: true) var name: String
    @Persisted var path: String
    @Persisted var routes: List<String>
    @Persisted var enabled: Bool
}

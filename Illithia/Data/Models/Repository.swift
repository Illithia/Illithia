//
//  Repository.swift
//  Illithia
//
//  Created by Angelo Carasig on 24/8/2024.
//

import Foundation
import RealmSwift

class Repository: Object, Identifiable {
    @Persisted(primaryKey: true) var name: String
    @Persisted var sources: List<SourceItem>
    @Persisted var baseUrl: String
}

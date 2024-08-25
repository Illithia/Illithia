//
//  Source.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import Foundation
import RealmSwift

class Source: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var sourceId: String
    @Persisted var mangaId: String
    @Persisted var slug: String?
    @Persisted var updatedAt: Date?
    @Persisted var createdAt: Date?
    @Persisted var url: String?
    @Persisted var chapters: List<Chapter>
}

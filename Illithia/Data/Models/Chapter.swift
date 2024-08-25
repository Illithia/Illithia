//
//  Chapter.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import Foundation
import RealmSwift

class Chapter: Object {
    @Persisted(primaryKey: true) var slug: String
    @Persisted var sourceId: String
    @Persisted var mangaSlug: String
    
    @Persisted var pages: Int
    @Persisted var chapterNumber: Int
    @Persisted var chapterTitle: String
    @Persisted var author: String
    @Persisted var date: Date
}

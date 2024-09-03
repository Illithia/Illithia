//
//  Manga.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//
import Foundation
import RealmSwift

// Struct used when displaying manga in library, search etc.
struct ListManga: Identifiable, Decodable, Equatable {
    var id: String {
        "\(sourceId)/\(slug)"
    }
    
    var sourceId: String
    var slug: String
    var title: String
    var coverUrl: String
}

class Manga: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var alternativeTitles: List<String>
    @Persisted var author: String?
    @Persisted var artist: String?
    @Persisted var synopsis: String?
    @Persisted var lastReadAt: Date?
    @Persisted var addedAt: Date?
    @Persisted var contentRating: String?
    @Persisted var contentStatus: String?
    @Persisted var coverUrl: String?
    @Persisted var tags: List<String>
    @Persisted var groups: List<Group>
    @Persisted var sources: List<Source>
    
    func toListManga() -> ListManga {
        let firstSource = sources.first!
        
        return ListManga(
            sourceId: firstSource.sourceId,
            slug: firstSource.slug ?? "",
            title: self.title,
            coverUrl: self.coverUrl ?? ""
        )
    }
}

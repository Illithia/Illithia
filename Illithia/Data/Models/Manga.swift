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
    var isInLibrary: Bool {
        return RealmManager.shared.isMangaInLibrary(byTitle: title)
    }
}

class Manga: Object {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String {
        didSet {
            normalizedTitle = normalize(title)
        }
    }
    
    @Persisted var alternativeTitles: List<String> {
        didSet {
            let normalizedAlts = alternativeTitles.map { self.normalize($0) }
            normalizedAlternativeTitles = normalizedAlts.joined(separator: ",")
        }
    }
    
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
    
    // Stored properties for normalized values
    @Persisted(indexed: true) var normalizedTitle: String = ""
    @Persisted(indexed: true) var normalizedAlternativeTitles: String = ""
    
    func toListManga() -> ListManga {
        let firstSource = sources.first!
        
        return ListManga(
            sourceId: firstSource.sourceId,
            slug: firstSource.slug ?? "",
            title: self.title,
            coverUrl: self.coverUrl ?? ""
        )
    }
    
    // Method to normalize a string (e.g., lowercase and remove punctuation)
    private func normalize(_ string: String) -> String {
        return string.lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//
//  RealmManager.swift
//  Illithia
//
//  Created by Angelo Carasig on 2/9/2024.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {
        // Private initializer to enforce singleton usage
    }
    
    func getRealmInstance() throws -> Realm {
        return try Realm()
    }
    
    func fetchManga(byTitle title: String) -> Manga? {
        do {
            let realm = try getRealmInstance()
            let lowercaseTitle = title.lowercased()
            
            return realm.objects(Manga.self).filter { manga in
                manga.title.lowercased() == lowercaseTitle || manga.alternativeTitles.contains { $0.lowercased() == lowercaseTitle }
            }.first
        } catch {
            print("Failed to retrieve manga from database: \(error)")
            return nil
        }
    }
    
    func fetchAllManga() -> [Manga] {
        do {
            let realm = try getRealmInstance()
            let mangaList = realm.objects(Manga.self)
            return Array(mangaList)
        } catch {
            print("Failed to retrieve all manga from database: \(error)")
            return []
        }
    }
    
    func saveManga(_ manga: Manga) {
        do {
            manga.addedAt = Date()
            
            let realm = try getRealmInstance()
            try realm.write {
                realm.add(manga, update: .all)
            }
            print("Manga saved to library")
        } catch {
            print("Failed to save manga to library: \(error)")
        }
    }
    
    func deleteManga(_ manga: Manga) -> Manga? {
        do {
            let realm = try getRealmInstance()
            let detachedManga = Manga(value: manga) // Detach the manga before deletion
            try realm.write {
                realm.delete(manga)
            }
            print("Manga deleted from library")
            return detachedManga // Return the detached copy
        } catch {
            print("Failed to delete manga from library: \(error)")
            return nil
        }
    }
    
    func isMangaInLibrary(byTitle title: String) -> Bool {
        do {
            let realm = try getRealmInstance()
            let lowercaseTitle = title.lowercased()
            
            print("Checking if \(title) is in library...")
            
            return realm.objects(Manga.self).filter { manga in
                manga.title.lowercased() == lowercaseTitle || manga.alternativeTitles.contains { $0.lowercased() == lowercaseTitle }
            }.count > 0
        } catch {
            print("Failed to check manga in library: \(error)")
            return false
        }
    }
}


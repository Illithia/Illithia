//
//  MangaLibrary.swift
//  Illithia
//
//  Created by Angelo Carasig on 3/9/2024.
//

import SwiftUI
import RealmSwift

@Observable class MangaLibrary {
    var mangaList: [ListManga] = []
    private var notificationToken: NotificationToken?
    private var realm: Realm
    
    init() {
        self.realm = try! Realm()
        self.fetchMangaList()
        self.observeMangaChanges()
    }
    
    private func fetchMangaList() {
        let results = realm.objects(Manga.self)
        mangaList = results.map { $0.toListManga() }
    }
    
    private func observeMangaChanges() {
        let results = realm.objects(Manga.self)
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial:
                // Initial population of the list
                self.mangaList = results.map { $0.toListManga() }
                
            case .update(_, let deletions, let insertions, let modifications):
                // Apply changes to the mangaList while maintaining order
                self.handleMangaUpdates(deletions: deletions, insertions: insertions, modifications: modifications)
                
            case .error(let error):
                // Handle errors
                print("Error observing manga changes: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleMangaUpdates(deletions: [Int], insertions: [Int], modifications: [Int]) {
        // Always apply updates in the following order: deletions, insertions, then modifications.
        // This ensures the list remains consistent and doesn't run into indexing issues.
        
        let results = realm.objects(Manga.self)
        
        deletions.forEach { index in
            print("Deletion")
            mangaList.remove(at: index)
        }
        
        insertions.forEach { index in
            print("Insertion")
            let manga = results[index].toListManga()
            mangaList.insert(manga, at: index)
        }
        
        modifications.forEach { index in
            let manga = results[index].toListManga()
            mangaList[index] = manga
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

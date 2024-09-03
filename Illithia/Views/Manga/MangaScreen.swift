//
//  MangaScreen.swift
//  Illithia
//
//  Created by Angelo Carasig on 17/8/2024.
//

import SwiftUI
import RealmSwift

struct MangaScreen: View {
    var props: ListManga
    @Environment(ActiveRepository.self) var activeRepository
    
    @State private var manga: Manga? = nil
    @State private var inLibrary: Bool = false
    
    init(props: ListManga) {
        self.props = props
        
        if let storedManga = RealmManager.shared.fetchManga(byTitle: props.title) {
            _manga = State(initialValue: storedManga)
            _inLibrary = State(initialValue: true)
            print("Loaded Manga from DB")
        }
    }
    
    func fetchManga(props: ListManga) async -> Void {
        do {
            if let repository = activeRepository.repository, let sourceItem = activeRepository.sourceItem {
                let fetchedManga = try await HttpClient().getManga(
                    repository: repository,
                    source: sourceItem.path,
                    route: props.slug
                )
                
                self.manga = fetchedManga
                self.inLibrary = false
            } else {
                print("Manga is probably in library")
            }
        } catch {
            print("Failed to fetch or save manga: \(error)")
        }
    }
    
    func saveManga(manga: Manga) {
        RealmManager.shared.saveManga(manga)
        self.inLibrary = true
    }
    
    func deleteManga(manga: Manga) {
        if let detachedManga = RealmManager.shared.deleteManga(manga) {
            self.manga = detachedManga
            self.inLibrary = false
        }
    }
    
    var body: some View {
        ZStack {
            if let manga = manga {
                Backdrop(coverUrl: URL(string: manga.coverUrl ?? "")!)
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer().frame(height: geometry.size.height / 3)
                            
                            Title(title: manga.title)
                            
                            Spacer().frame(height: 8)
                            
                            AuthorArtist(author: manga.author!, artist: manga.artist!)
                            
                            Spacer().frame(height: 12)
                            
                            ActionButtons(
                                manga: manga,
                                inLibrary: inLibrary,
                                saveMangaToLibrary: saveManga,
                                deleteMangaFromLibrary: deleteManga)
                            
                            Spacer().frame(height: 12)
                            
                            Description(description: manga.synopsis!)
                            
                            Spacer().frame(height: 22)
                            
                            TagButtons(tags: manga.tags)
                            
                            Spacer().frame(height: 22)
                            
                            MangaScreenTabs(manga: manga)
                        }
                        .padding(.leading, 12)
                        .padding(.trailing, 16)
                        .background(
                            VStack(spacing: 0) {
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color("BackgroundColor").opacity(0.0), location: 0.0),
                                        .init(color: Color("BackgroundColor").opacity(1.0), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                                .frame(height: 700)
                                
                                Color("BackgroundColor")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                                .frame(width: geometry.size.width)
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .task {
            if manga == nil {
                await fetchManga(props: props)
            }
        }
    }
}

//
//  MangaScreen.swift
//  Illithia
//
//  Created by Angelo Carasig on 17/8/2024.
//

import SwiftUI

struct MangaScreen: View {
    var props: ListManga
    @State private var manga: Manga? = nil
    
    var body: some View {
        ZStack {
            if let manga = manga {
                Backdrop(coverUrl: URL(string: manga.coverUrl ?? "")!)
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: geometry.size.height / 3)
                                .fixedSize()
                            
                            Title(title: manga.title)
                            
                            Spacer().frame(height: 8)
                            
                            AuthorArtist(author: manga.author!, artist: manga.artist!)
                            
                            Spacer().frame(height: 12)
                            
                            ActionButtons()
                            
                            Spacer().frame(height: 12)
                            
                            Description(description: manga.synopsis!)
                            
                            Spacer().frame(height: 22)
                            
                            TagButtons(tags: manga.tags)
                            
                            Spacer().frame(height: 22)
                            
                            if let firstSource = manga.sources.first {
                                ChapterButtons(chapters: firstSource.chapters)
                            } else {
                                Text("No chapters available")
                            }
                        }
                        .padding(.horizontal, 12)
                        .background(
                            GeometryReader { innerGeometry in
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color("BackgroundColor").opacity(0.0), location: 0.0),
                                        .init(color: Color("BackgroundColor").opacity(1.0), location: min(700 / innerGeometry.size.height, 1))
                                    ]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .task {
            await fetchManga(props: props)
        }
    }
    
    func fetchManga(props: ListManga) async {
        do {
            let manga = try await HttpClient().getManga(props: props)
            self.manga = manga
        } catch {
            print(error)
        }
    }
}

#Preview {
    MangaScreen(props: ListManga(sourceId: "", slug: "85b3504c-62e8-49e7-9a81-fb64a3f51def", title: "", coverUrl: ""))
}

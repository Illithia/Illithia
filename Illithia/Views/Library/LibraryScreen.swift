//
//  LibraryScreen.swift
//  Illithia
//
//  Created by Angelo Carasig on 26/8/2024.
//

import SwiftUI
import RealmSwift

struct LibraryScreen: View {
    @State private var manga: [ListManga] = []
    @State private var shouldRefresh: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer().frame(height: 20)
                if manga.isEmpty {
                    Text("No manga in your library!")
                        .font(.headline)
                        .padding()
                } else {
                    CardGrid(manga: manga, isLoading: false, loadMore: {})
                }
            }
            .onAppear {
                if shouldRefresh {
                    loadRecentManga()
                    shouldRefresh = false
                }
            }
            .navigationTitle("Library")
        }
    }
    
    func loadRecentManga() {
        let allManga = RealmManager.shared.fetchAllManga()
        manga = allManga.map { $0.toListManga() }
    }
    
    func refresh() {
        loadRecentManga()
    }
}

#Preview {
    LibraryScreen()
}

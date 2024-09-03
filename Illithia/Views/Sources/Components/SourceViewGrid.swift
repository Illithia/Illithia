//
//  SourceViewGrid.swift
//  Illithia
//
//  Created by Angelo Carasig on 1/9/2024.
//

import SwiftUI

struct SourceViewGrid: View {
    let repository: Repository
    let sourceItem: SourceItem
    let sourceRoute: SourceRoute
    
    @State private var manga: [ListManga] = []
    @State private var isLoading: Bool = true
    @State private var isFetchingMore: Bool = false
    @State private var page: Int = 0 {
        didSet {
            print("Page value changed to \(page)")
        }
    }
    @State private var shouldRefresh: Bool = true // Track if the view should refresh
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 20)
            CardGrid(manga: manga, isLoading: isLoading, loadMore: loadMoreManga)
        }
        .refreshable {
            refresh()
        }
        .onAppear {
            if shouldRefresh {
                loadRecentManga()
                shouldRefresh = false
            }
        }
        .navigationTitle(sourceRoute.name)
    }
    
    private func refresh() {
        page = 0
        manga.removeAll()
        loadRecentManga()
    }
    
    private func loadRecentManga() {
        isLoading = true
        
        Task {
            do {
                let result = try await HttpClient().fetchManga(
                    for: repository,
                    sourceItem: sourceItem,
                    route: sourceRoute.path.joined(separator: "/"),
                    page: page
                )
                
                appendUniqueManga(result)
                isLoading = false
            } catch {
                print("Failed to load recent manga: \(error)")
                isLoading = false
            }
        }
    }
    
    private func loadMoreManga() {
        guard !isFetchingMore else { return }
        
        isFetchingMore = true
        page += 1
        
        Task {
            do {
                let result = try await HttpClient().fetchManga(
                    for: repository,
                    sourceItem: sourceItem,
                    route: sourceRoute.path.joined(separator: "/"),
                    page: page
                )
                
                appendUniqueManga(result)
                isFetchingMore = false
            } catch {
                print("Failed to load more manga: \(error)")
                isFetchingMore = false
            }
        }
    }
    
    private func appendUniqueManga(_ newManga: [ListManga]) {
        let existingSlugs = Set(manga.map { $0.slug })
        let uniqueManga = newManga.filter { !existingSlugs.contains($0.slug) }
        manga.append(contentsOf: uniqueManga)
    }
}

#Preview {
    let mockRepository = Repository()
    
    let mockSourceItem = SourceItem()
    
    let mockRoute = SourceRoute()
    mockRoute.name = "Popular New Titles"
    mockRoute.path.append("/rising")
    
    return SourceViewGrid(repository: mockRepository, sourceItem: mockSourceItem, sourceRoute: mockRoute)
}

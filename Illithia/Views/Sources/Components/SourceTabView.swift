//
//  SourceTabView.swift
//  Illithia
//
//  Created by Angelo Carasig on 26/8/2024.
//

import SwiftUI

struct SourceTabView: View {
    let repository: Repository
    let sourceItem: SourceItem
    let route: String
    
    @State private var recentManga: [ListManga] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    CardGrid(recentManga: recentManga, isLoading: false)
                }
            }
        }
        .onAppear {
            if recentManga.isEmpty && !route.isEmpty {
                Task {
                    await fetchManga()
                }
            }
        }
        .onChange(of: route) {
            if !route.isEmpty {
                Task {
                    await fetchManga()
                }
            }
        }
    }
    
    private func fetchManga() async {
        do {
            isLoading = true
            recentManga = try await HttpClient().fetchManga(for: repository, sourceItem: sourceItem, route: route)
            isLoading = false
        } catch {
            print("Failed to fetch manga for route \(route): \(error)")
            isLoading = false
        }
    }
}

// No preview for this as it involves fetching, better to look at card grid instead

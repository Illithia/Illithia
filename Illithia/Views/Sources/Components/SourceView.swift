//
//  SourceTab.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import SwiftUI
import RealmSwift

struct SourceView: View {
    var repository: Repository
    var sourceItem: SourceItem
    @State private var results: [String: Int] = [:] // Dictionary to store route name and result count
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(sourceItem.routes, id: \.self) { route in
                        if let count = results[route] {
                            Text("\(sourceItem.name) - \(route): \(count) manga(s) found")
                                .padding()
                        } else {
                            Text("\(sourceItem.name) - \(route): Loading...")
                                .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            loadMangaData()
        }
    }

    private func loadMangaData() {
        isLoading = true
        errorMessage = nil
        results = [:]

        Task {
            await withTaskGroup(of: (String, Int?).self) { group in
                for route in sourceItem.routes {
                    group.addTask {
                        do {
                            print("Fetching for route: \(route)")
                            let mangaList = try await HttpClient().fetchManga(for: repository, sourceItem: sourceItem, route: route)
                            return (route, mangaList.count)
                        } catch {
                            print("Error fetching route \(route): \(error.localizedDescription)")
                            return (route, nil)
                        }
                    }
                }

                for await result in group {
                    if let count = result.1 {
                        results[result.0] = count
                    } else {
                        errorMessage = "Failed to load data for some routes."
                    }
                }
            }

            isLoading = false
        }
    }
}

#Preview {
    let mockRepository = Repository()
    
    let mockSourceItem = SourceItem()
    mockSourceItem.routes.append("MangaDex")
    mockSourceItem.routes.append("Manganato")
    mockSourceItem.routes.append("MangaBat")
    mockSourceItem.routes.append("BatoTo")
    mockSourceItem.routes.append("Toonily")
    mockSourceItem.routes.append("NHentai")
    mockSourceItem.routes.append("EHentai")
    
    return SourceView(repository: mockRepository, sourceItem: mockSourceItem)
}

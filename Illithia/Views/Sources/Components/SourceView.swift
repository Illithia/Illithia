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
    @State private var mangaResults: [String: [ListManga]] = [:]
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private func getSourceHeight() -> CGFloat {
        return screenWidth < 420 ? 165 : 185
    }
    
    private var sourceWidth: CGFloat {
        return getSourceHeight() * (11 / 16)
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(sourceItem.routes, id: \.self) { route in
                            let routePath = route.path.joined(separator: "/")
                            VStack(alignment: .leading, spacing: 10) {
                                Text(route.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.leading, 16)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        if let mangaList = mangaResults[routePath] {
                                            ForEach(mangaList.prefix(20)) { manga in
                                                Card(item: manga, sourceWidth: sourceWidth, sourceHeight: getSourceHeight())
                                            }
                                        } else {
                                            Text("Loading...")
                                                .foregroundColor(.gray)
                                                .frame(width: sourceWidth, height: getSourceHeight())
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(sourceItem.name)
        .onAppear(perform: loadMangaData)
    }
    
    private func loadMangaData() {
        isLoading = true
        errorMessage = nil
        mangaResults = [:]
        
        Task {
            await withTaskGroup(of: (String, [ListManga]?).self) { group in
                for route in sourceItem.routes {
                    group.addTask {
                        let routePath = route.path.joined(separator: "/")
                        do {
                            let mangaList = try await HttpClient().fetchManga(for: repository, sourceItem: sourceItem, route: routePath)
                            return (routePath, mangaList)
                        } catch {
                            return (routePath, nil)
                        }
                    }
                }
                
                var errorOccurred = false
                
                for await result in group {
                    if let mangaList = result.1 {
                        mangaResults[result.0] = mangaList
                    } else {
                        errorOccurred = true
                    }
                }
                
                if errorOccurred {
                    errorMessage = "Failed to load data for some routes."
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    let mockRepository = Repository()
    
    let mockSourceItem = SourceItem()
    
    let mockRoute1 = SourceRoute()
    mockRoute1.name = "Popular New Titles"
    mockRoute1.path.append("/rising")
    
    let mockRoute2 = SourceRoute()
    mockRoute2.name = "Recently Updated"
    mockRoute2.path.append("/recent")
    
    mockSourceItem.routes.append(mockRoute1)
    mockSourceItem.routes.append(mockRoute2)
    
    return SourceView(repository: mockRepository, sourceItem: mockSourceItem)
}

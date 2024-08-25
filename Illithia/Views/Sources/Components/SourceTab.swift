//
//  SourceTab.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import SwiftUI
import RealmSwift

struct SourceTab: View {
    var repository: Repository
    var sourceItem: SourceItem
    @State private var selectedTab: String = ""
    
    var body: some View {
        VStack {
            TabBar()
            
            if !selectedTab.isEmpty {
                SourceTabView(repository: repository, sourceItem: sourceItem, route: selectedTab)
            } else {
                Text("No route selected")
            }
            
            Spacer()
        }
        .onAppear {
            // Ensure the first route is selected on init
            if let firstRoute = sourceItem.routes.first {
                selectedTab = firstRoute
                print("Selected Tab: ", firstRoute)
            } else {
                print("No routes available")
            }
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(sourceItem.routes, id: \.self) { route in
                    TabButton(title: route, isSelected: route == selectedTab) {
                        withAnimation {
                            selectedTab = route
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title.capitalized)
                    .font(.headline)
                    .foregroundColor(isSelected ? Color.blue : Color.white)
                
                if isSelected {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
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
    
    return SourceTab(repository: mockRepository, sourceItem: mockSourceItem)
}

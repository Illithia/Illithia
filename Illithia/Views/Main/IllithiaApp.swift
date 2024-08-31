//
//  IllithiaApp.swift
//  Illithia
//
//  Created by Angelo Carasig on 26/8/2024.
//

import SwiftUI
import RealmSwift

@main
struct IllithiaApp: SwiftUI.App {
    init() {
        initRealm()
    }
    
    var body: some Scene {
        WindowGroup {
            TabGroups()
        }
        .environment(\.font, Font.custom("Inter", size: 16))
    }
}

private func initRealm() -> Void {
    do {
        let realm = try Realm()
        print("Realm file location: \(realm.configuration.fileURL?.absoluteString ?? "No file URL")")
    } catch {
        print("Error initializing Realm: \(error.localizedDescription)")
    }
}

private struct TabGroups: View {
    @State var activeRepository = ActiveRepository()
    
    var body: some View {
        TabView {
            LibraryScreen()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
                .onAppear {
                    activeRepository.clear()
                }
            
            SearchScreen()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            SourceScreen()
                .tabItem {
                    Image(systemName: "plus.square.dashed")
                    Text("Sources")
                }
            
            HistoryScreen()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
            
            SettingsScreen()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .environment(activeRepository)
    }
}

//
//  SourceScreen.swift
//  Illithia
//
//  Created by Angelo Carasig on 24/8/2024.
//

import SwiftUI
import RealmSwift

struct SourceScreen: View {
    @ObservedResults(Repository.self) var repositories
    @State private var isEditing: Bool = false
    @State private var isShowingSheet: Bool = false
    
    /**
     TODO:
     - Handle case when no repositories are added
     - Add functional edit button
     - Make sources able to be enabled/disabled for a given repo
     */
    
    var body: some View {
        NavigationView {
            VStack {
                if repositories.isEmpty {
                    Text("No repositories have been added.")
                    Button {
                        isShowingSheet = true
                    } label: {
                        Text("Add Repository")
                    }
                }
                else {
                    List {
                        Section(header: Text("Repositories")) {
                            ForEach(repositories) { repository in
                                Text(repository.name)
                            }
                        }

                        Section(header: Text("Sources")) {
                            ForEach(repositories) { repository in
                                ForEach(repository.sources, id: \.self) { source in
                                    SourceListItem(repository: repository, sourceItem: source)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sources")
            .navigationBarItems(
                leading: repositories.isEmpty ? nil : EditButton(),
                trailing: AddButton()
            )
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        }
    }

    @ViewBuilder
    func AddButton() -> some View {
        Button {
            isShowingSheet = true
        } label: {
            Image(systemName: "plus")
        }
            .sheet(isPresented: $isShowingSheet) {
                AddSource()
                    .presentationDetents([.large])
            }
    }
}

#Preview {
    SourceScreen()
}

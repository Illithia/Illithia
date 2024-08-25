//
//  AddSource.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import SwiftUI
import RealmSwift

struct AddSource: View {
    @State private var repoUrl: String = ""
    @State private var isTestSuccessful: Bool = false
    @State private var isTesting: Bool = false
    @State private var repository: Repository? = nil
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Repository URL")) {
                    TextField("Enter repository URL", text: $repoUrl)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
                
                if let repository = repository {
                    Section(header: Text("Sources")) {
                        VStack(alignment: .leading) {
                            ForEach(repository.sources, id: \.self) { source in
                                SourceListItem(repository: repository, sourceItem: source)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Section {
                    Button(action: testRepoUrl) {
                        if isTesting {
                            ProgressView()
                        } else {
                            Text("Test")
                        }
                    }
                    .disabled(repoUrl.isEmpty || isTesting)
                    
                    Button(action: saveRepoUrl) {
                        Text("Save")
                    }
                    .disabled(!isTestSuccessful)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Add New Repository")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func testRepoUrl() {
        isTesting = true
        isTestSuccessful = false
        repository = nil
        
        Task {
            do {
                print("Testing URL: \(repoUrl)")
                if let repo = try await HttpClient().addRepository(url: repoUrl) {
                    print("Test Successful. Repository: \(repo.name), Sources: \(repo.sources)")
                    repository = repo
                    isTestSuccessful = true
                } else {
                    print("Test Failed: Repository is nil")
                    isTestSuccessful = false
                }
            } catch {
                print("Failed to test repository: \(error.localizedDescription)")
                isTestSuccessful = false
            }
            isTesting = false
            print("Testing complete. isTestSuccessful: \(isTestSuccessful), isTesting: \(isTesting)")
        }
    }
    
    private func saveRepoUrl() {
        guard let repository = repository else {
            print("Save failed: No repository to save.")
            return
        }
        
        let realm = try! Realm()
        
        // Check if the repository already exists in Realm
        if realm.object(ofType: Repository.self, forPrimaryKey: repository.name) != nil {
            // Repository already exists, show an alert
            alertMessage = "A repository with the name '\(repository.name)' already exists."
            showAlert = true
            return
        }
        
        // Save the repository to Realm
        do {
            try realm.write {
                realm.add(repository)
            }
            print("Repository URL saved: \(repository.baseUrl)")
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "Failed to save the repository: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    AddSource()
}

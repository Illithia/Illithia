//
//  ActiveSourceManager.swift
//  Illithia
//
//  Created by Angelo Carasig on 31/8/2024.
//

import SwiftUI
import RealmSwift

/**
 This is used to fetch the right novel from the right source
 */
class ActiveSourceManager: ObservableObject {
    @Published var activeRepository: Repository? = nil
    @Published var activeSource: SourceItem? = nil
    
    func setActiveSource(repository: Repository, sourceItem: SourceItem) {
        self.activeRepository = repository
        self.activeSource = sourceItem
    }
    
    func clearActiveSource() {
        self.activeRepository = nil
        self.activeSource = nil
    }
}

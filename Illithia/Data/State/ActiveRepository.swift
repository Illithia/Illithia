//
//  ActiveRepository.swift
//  Illithia
//
//  Created by Angelo Carasig on 31/8/2024.
//

import Foundation
import RealmSwift

@Observable class ActiveRepository {
    var repository: Repository? = nil {
        didSet {
            if let repository = repository {
                print("Active Repository changed to \(repository.name)")
            } else {
                print("Active Repository cleared")
            }
        }
    }
    
    var sourceItem: SourceItem? = nil {
        didSet {
            if let sourceItem = sourceItem {
                print("Active Source changed to \(sourceItem.name)")
            } else {
                print("Active Source cleared")
            }
        }
    }
    
    func setActive(repository: Repository, sourceItem: SourceItem) {
        self.repository = repository
        self.sourceItem = sourceItem
    }
    
    func clear() {
        self.repository = nil
        self.sourceItem = nil
    }
}

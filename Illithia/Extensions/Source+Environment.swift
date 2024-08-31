//
//  Source+Environment.swift
//  Illithia
//
//  Created by Angelo Carasig on 30/8/2024.
//

import Foundation
import SwiftUI

struct ActiveRepositoryKey: EnvironmentKey {
    static let defaultValue: Repository? = nil
}

struct ActiveSourceItemKey: EnvironmentKey {
    static let defaultValue: SourceItem? = nil
}

extension EnvironmentValues {
    var activeRepository: Repository? {
        get { self[ActiveRepositoryKey.self] }
        set { self[ActiveRepositoryKey.self] = newValue }
    }
    
    var activeSourceItem: SourceItem? {
        get { self[ActiveSourceItemKey.self] }
        set { self[ActiveSourceItemKey.self] = newValue }
    }
}

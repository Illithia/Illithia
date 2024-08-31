//
//  SourceItem.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import Foundation
import RealmSwift

class SourceItem: Object, Identifiable {
    @Persisted var name: String
    @Persisted var path: String
    @Persisted var routes: List<SourceRoute>
    @Persisted var enabled: Bool
}

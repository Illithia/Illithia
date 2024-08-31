//
//  SourceRoute.swift
//  Illithia
//
//  Created by Angelo Carasig on 31/8/2024.
//

import Foundation
import RealmSwift

class SourceRoute: Object, Identifiable {
    @Persisted var name: String
    @Persisted var path: List<String>
}

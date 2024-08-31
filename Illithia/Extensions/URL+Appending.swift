//
//  URL+Appending.swift
//  Illithia
//
//  Created by Angelo Carasig on 30/8/2024.
//

import Foundation

extension URL {
    static func appendingPaths(_ baseUrl: String, _ paths: String...) -> URL? {
        guard var url = URL(string: baseUrl) else {
            return nil
        }
        
        for path in paths {
            let trimmedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            url.appendPathComponent(trimmedPath)
        }
        
        return url
    }
}


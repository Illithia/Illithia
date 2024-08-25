//
//  ReadStatus.swift
//  Aletheia
//
//  Created by Angelo Carasig on 24/8/2024.
//

import Foundation

enum ReadStatus: String, Codable {
    case planningToRead = "Planning To Read"
    case reading = "Reading"
    case onHold = "On Hold"
    case dropped = "Dropped"
    case completed = "Completed"
}

//
//  Title.swift
//  Illithia
//
//  Created by Angelo Carasig on 17/8/2024.
//

import SwiftUI

struct Title: View {
    let title: String
    
    init(title: String = "No Title") {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(4)
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    Title()
}

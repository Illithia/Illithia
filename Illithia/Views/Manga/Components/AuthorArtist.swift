//
//  AuthorArtist.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI

struct AuthorArtist: View {
    let author: String
    let artist: String
    
    init(author: String = "Unknown", artist: String = "Unknown") {
        self.author = author
        self.artist = artist
    }
    
    var body: some View {
        HStack {
            Text(Image(systemName: "pencil"))
            Text(author)
            
            Text(Image(systemName: "paintpalette"))
            Text(artist)
        }
        .frame(alignment: .leading)
    }
}

#Preview {
    AuthorArtist()
}

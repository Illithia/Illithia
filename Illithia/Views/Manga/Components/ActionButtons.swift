//
//  ActionButtons.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI
import RealmSwift
import LucideIcons

struct ActionButtons: View {
    var manga: Manga
    var inLibrary: Bool
    var saveMangaToLibrary: (Manga) -> Void
    var deleteMangaFromLibrary: (Manga) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button {
                if (inLibrary) {
                    deleteMangaFromLibrary(manga)
                }
                else {
                    saveMangaToLibrary(manga)
                }
            } label: {
                Text(Image(systemName: "heart"))
                Text(inLibrary ? "In Library" : "Add to Library")
            }
            .fontWeight(.medium)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .foregroundStyle(inLibrary ? Color("BackgroundColor") : .white)
            .background(inLibrary ? Color("TextColor") : Color("TintColor"), in: .rect(cornerRadius: 12, style: .continuous))
            
            Button {
                if (inLibrary) {
                    deleteMangaFromLibrary(manga)
                }
                else {
                    saveMangaToLibrary(manga)
                }
            } label: {
                Text(Image(systemName: "plus.square.dashed"))
                Text(inLibrary ? "Source Registered" : "Add Source")
            }
            .fontWeight(.medium)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .foregroundStyle(inLibrary ? Color("BackgroundColor") : .white)
            .background(inLibrary ? Color("TextColor") : Color("TintColor"), in: .rect(cornerRadius: 12, style: .continuous))
        }
    }
}

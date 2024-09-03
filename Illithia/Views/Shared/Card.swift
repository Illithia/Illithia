//
//  Card.swift
//  Illithia
//
//  Created by Angelo Carasig on 24/8/2024.
//

import SwiftUI
import Kingfisher
import LucideIcons

struct Card: View {
    @Environment(ActiveRepository.self) var activeRepository
    
    let item: ListManga
    let sourceWidth: CGFloat
    let sourceHeight: CGFloat
    
    @State private var isImageLoading: Bool = true
    
    var body: some View {
        NavigationLink(destination: MangaScreen(props: item)) {
            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    if isImageLoading {
                        // Skeleton Loader
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: sourceWidth, height: sourceHeight)
                            .cornerRadius(8)
                    }
                    
                    KFImage(URL(string: item.coverUrl))
                        .resizable()
                        .fade(duration: 0.25)
                        .retry(maxCount: 5, interval: .seconds(1))
                        .onSuccess { _ in
                            isImageLoading = false
                        }
                        .onFailure { _ in
                            isImageLoading = false
                        }
                        .scaledToFill()
                        .aspectRatio(11/16, contentMode: .fit)
                        .frame(width: sourceWidth, height: sourceHeight)
                        .cornerRadius(8)
                        .clipped()
                        .overlay(
                            activeRepository.repository == nil ? .clear : (item.isInLibrary == true ? .black.opacity(0.5) : .clear)
                        )
                    
                    if item.isInLibrary == true {
                        Image(uiImage: Lucide.badgeCheck)
                            .lucide(color: .green)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                    }
                }
                
                Text(item.title)
                    .font(.caption)
                    .lineLimit(2)
                    .frame(width: sourceWidth, height: 40, alignment: .topLeading)
                    .truncationMode(.tail)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let item: ListManga = ListManga(
        sourceId: "",
        slug: "",
        title: "Some Manga",
        coverUrl: "https://mangadex.org/covers/85b3504c-62e8-49e7-9a81-fb64a3f51def/d241a461-acac-48f4-9c8a-ec8211619263.jpg"
    )
    
    return Card(
        item: item,
        sourceWidth: 185,
        sourceHeight: 185 * (11/16)
    )
}

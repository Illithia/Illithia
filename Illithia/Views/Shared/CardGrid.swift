//
//  CardGrid.swift
//  Illithia
//
//  Created by Angelo Carasig on 24/8/2024.
//

import SwiftUI

struct CardGrid: View {
    let manga: [ListManga]
    let isLoading: Bool
    let loadMore: () -> Void  // Callback to trigger loading more manga
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private func getSourceHeight() -> CGFloat {
        return screenWidth < 420 ? 165 : 185
    }
    
    private var sourceWidth: CGFloat {
        return getSourceHeight() * (11 / 16)
    }
    
    var body: some View {
        if isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: sourceWidth), spacing: 0)],
                spacing: 0
            ) {
                ForEach(manga, id: \.slug) { item in
                    Card(item: item, sourceWidth: sourceWidth, sourceHeight: getSourceHeight())
                        .onAppear {
                            if item == manga.last {
                                loadMore()
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    CardGrid(manga: [], isLoading: true, loadMore: {})
}

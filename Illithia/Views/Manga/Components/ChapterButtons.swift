//
//  ChapterButtons.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI
import RealmSwift

struct ChapterButtons: View {
    let chapters: RealmSwift.List<Chapter>
    let chapterColumns = [GridItem(.flexible())]
    
    @State var isShowingSheet = false
    
    init(chapters: RealmSwift.List<Chapter> = RealmSwift.List<Chapter>()) {
        self.chapters = chapters
    }
    
    func isNew(chapter: Chapter) -> Bool {
        let calendar = Calendar.current
        guard let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: Date()) else { return false }
        return chapter.date >= threeDaysAgo
    }
    
    var body: some View {
        HStack {
            Text("\(chapters.count) Available Chapter\(chapters.count != 1 ? "s" : "")")
                .font(.title2)
            
            Spacer()
            
            Button {
                isShowingSheet = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
            }
            .padding(12)
            .foregroundColor(Color("TextColor"))
            .background(Color("TintColor"))
            .clipShape(.circle)
            .sheet(isPresented: $isShowingSheet) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Some Property 1")
                    Text("Some Property 2")
                    Text("Some Property 3")
                    Text("Some Property 4")
                    Text("Some Property 5")
                }
                .presentationDetents([.medium, .large])
            }
        }
        
        Divider().frame(height: 12)
        
        LazyVGrid(columns: chapterColumns, alignment: .leading, spacing: 4) {
            ForEach(Array(chapters), id: \.self) { chapter in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Chapter \(chapter.chapterNumber)\(chapter.chapterTitle.isEmpty ? "" : " - \(chapter.chapterTitle)")")
                        
                        Spacer()
                        
                        Text(chapter.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(chapter.author)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isNew(chapter: chapter) {
                        Text("NEW")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color("AlertColor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 8)
                Divider()
            }
        }
    }
}

#Preview {
    ChapterButtons()
}

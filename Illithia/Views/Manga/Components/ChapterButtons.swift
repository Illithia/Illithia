//
//  ChapterButtons.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI
import RealmSwift
import LucideIcons

struct ChapterButtons: View {
    let chapters: RealmSwift.List<Chapter>
    let chapterColumns = [GridItem(.flexible())]
    
    @State private var isShowingSheet = false
    @State private var selectedSortOption: SortOption = .numberAscending
    @State private var selectedAuthor: String = "All"
    
    private var sortedAndFilteredChapters: [Chapter] {
        var filteredChapters = Array(chapters)
        
        if selectedAuthor != "All" {
            filteredChapters = filteredChapters.filter { $0.author == selectedAuthor }
        }
        
        switch selectedSortOption {
        case .numberAscending:
            filteredChapters.sort { $0.chapterNumber < $1.chapterNumber }
        case .numberDescending:
            filteredChapters.sort { $0.chapterNumber > $1.chapterNumber }
        case .dateAscending:
            filteredChapters.sort { $0.date < $1.date }
        case .dateDescending:
            filteredChapters.sort { $0.date > $1.date }
        }
        
        return filteredChapters
    }
    
    enum SortOption: String, CaseIterable {
        case numberAscending = "Number (A-Z)"
        case numberDescending = "Number (Z-A)"
        case dateAscending = "Date (A-Z)"
        case dateDescending = "Date (Z-A)"
    }
    
    private var uniqueAuthors: [String] {
        let authors = chapters.map { $0.author }
        return Array(Set(authors)).sorted() + ["All"]
    }
    
    private var threeDaysAgo: Date {
        Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
    }
    
    private func isNew(chapter: Chapter) -> Bool {
        return chapter.date >= threeDaysAgo
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            Divider().frame(height: 12)
            
            chapterGrid
        }
    }
    
    @ViewBuilder
    private var header: some View {
        HStack {
            Text("\(sortedAndFilteredChapters.count) \(selectedAuthor != "All" ? "Filtered" : "Available") Chapter\(sortedAndFilteredChapters.count != 1 ? "s" : "")")
                .font(.title2)
            
            Spacer()
            
            Button {
                Haptics.impact()
                isShowingSheet = true
            } label: {
                Image(uiImage: Lucide.listFilter)
                    .lucide()
            }
            .padding(12)
            .foregroundColor(Color("TextColor"))
            .background(Color("TintColor"))
            .clipShape(Circle())
            .sheet(isPresented: $isShowingSheet) {
                sheetContent
            }
        }
    }
    
    @ViewBuilder
    private var sheetContent: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort By")) {
                    Picker("Sort Option", selection: $selectedSortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Filter By Author")) {
                    Picker("Author", selection: $selectedAuthor) {
                        ForEach(uniqueAuthors, id: \.self) { author in
                            Text(author).tag(author)
                        }
                    }
                }
            }
            .navigationTitle("Sort & Filter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        isShowingSheet = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var chapterGrid: some View {
        LazyVGrid(columns: chapterColumns, alignment: .leading, spacing: 4) {
            ForEach(sortedAndFilteredChapters, id: \.self) { chapter in
                chapterRow(chapter: chapter)
                Divider()
            }
        }
    }
    
    @ViewBuilder
    private func chapterRow(chapter: Chapter) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Chapter \(chapter.chapterNumber.clean)\(chapter.chapterTitle.isEmpty ? "" : " - \(chapter.chapterTitle)")")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer().frame(height: 4)
                
                Text(chapter.date, style: .date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text(chapter.author)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isNew(chapter: chapter) {
                Text("NEW")
                    .font(.system(size: 16))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color("AlertColor"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}



#Preview {
    let sampleChapters = RealmSwift.List<Chapter>()
    
    let chapter1 = Chapter()
    chapter1.slug = "ch1"
    chapter1.sourceId = "source1"
    chapter1.mangaSlug = "manga1"
    chapter1.chapterNumber = 1
    chapter1.chapterTitle = "The Beginning"
    chapter1.author = "Author A"
    chapter1.date = Date()

    let chapter2 = Chapter()
    chapter2.slug = "ch2"
    chapter2.sourceId = "source1"
    chapter2.mangaSlug = "manga1"
    chapter2.chapterNumber = 2
    chapter2.chapterTitle = "The Continuation"
    chapter2.author = "Author A"
    chapter2.date = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    
    let chapter3 = Chapter()
    chapter3.slug = "ch3"
    chapter3.sourceId = "source1"
    chapter3.mangaSlug = "manga1"
    chapter3.chapterNumber = 3
    chapter3.chapterTitle = "The Continuation with a lot more words that doesn't make sense and sounds really confusing"
    chapter3.author = "Author A"
    chapter3.date = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    
    let chapter4 = Chapter()
    chapter4.slug = "ch3"
    chapter4.sourceId = "source1"
    chapter4.mangaSlug = "manga1"
    chapter4.chapterNumber = 4.1
    chapter4.chapterTitle = "The Continuation with a lot more words that doesn't make sense and sounds really confusing"
    chapter4.author = "Author A"
    chapter4.date = Date()

    sampleChapters.append(chapter1)
    sampleChapters.append(chapter2)
    sampleChapters.append(chapter3)
    sampleChapters.append(chapter4)
    
    return ChapterButtons(chapters: sampleChapters)
}

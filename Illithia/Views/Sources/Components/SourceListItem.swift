//
//  SourceListItem.swift
//  Illithia
//
//  Created by Angelo Carasig on 25/8/2024.
//

import SwiftUI

struct SourceListItem: View {
    @Environment(ActiveRepository.self) var activeRepository
    
    let repository: Repository
    let sourceItem: SourceItem
    
    var body: some View {
        NavigationLink(destination: SourceView(repository: repository, sourceItem: sourceItem)
            .onAppear {
                activeRepository.setActive(repository: repository, sourceItem: sourceItem)
            }
        ) {
            HStack {
                Image(systemName: "square.stack.3d.down.dottedline")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text(sourceItem.name)
                        .font(.headline)
                    Text(repository.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    let mockRepository = Repository()
    mockRepository.name = "Some Repository"
    let mockSource = SourceItem()
    mockSource.name = "some source"
    
    return SourceListItem(repository: mockRepository, sourceItem: mockSource)
}

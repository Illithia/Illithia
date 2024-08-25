//
//  TagButtons.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI
import Flow
import RealmSwift

struct TagButtons: View {
    let tags: RealmSwift.List<String>
    
    init(tags: RealmSwift.List<String> = RealmSwift.List<String>()) {
        self.tags = tags
    }
    
    var body: some View {
        HFlow {
            ForEach(Array(tags), id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .foregroundColor(Color("TextColor"))
                    .background(Color("TintColor"))
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    TagButtons()
}

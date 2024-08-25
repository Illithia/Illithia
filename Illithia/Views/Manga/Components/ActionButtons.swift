//
//  ActionButtons.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI

struct ActionButtons: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                print("Test")
            } label: {
                Text(Image(systemName: "heart"))
                Text("In Library")
            }
            .fontWeight(.medium)
            .padding(.vertical, 14)
            .foregroundStyle(Color("BackgroundColor"))
            .frame(maxWidth: .infinity)
            .background(Color("TextColor"), in: .rect(cornerRadius: 12, style: .continuous))
            
            Button {
                print("Test2")
            } label: {
                Text(Image(systemName: "heart"))
                Text("Tracking")
            }
            .fontWeight(.medium)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(Color("TintColor"), in: .rect(cornerRadius: 12, style: .continuous))
            
            Text(Image(systemName: "square.and.arrow.up"))
                .font(.title2)
            Text(Image(systemName: "link"))
                .font(.title2)
        }
    }
}

#Preview {
    ActionButtons()
}

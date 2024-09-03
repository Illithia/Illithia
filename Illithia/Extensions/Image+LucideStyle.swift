//
//  Image+LucideStyle.swift
//  Illithia
//
//  Created by Angelo Carasig on 2/9/2024.
//

import SwiftUI

extension Image {
    func lucide(size: CGFloat? = 24, color: Color = Color("TextColor")) -> some View {
        self
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundColor(color)
    }
}

//
//  Description.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//

import SwiftUI

struct Description: View {
    let description: String
    @State private var isExpanded: Bool = false {
        didSet {
            if oldValue != isExpanded {
                Haptics.impact()
            }
        }
    }
    
    init(description: String = "No Description") {
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .lineLimit(isExpanded ? nil : 6)
                .multilineTextAlignment(.leading)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            
            // Threshold for "long" text
            if description.count > 250 {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Text(Image(systemName: isExpanded ? "chevron.up" : "chevron.down"))
                        Text(isExpanded ? "Show Less" : "Show More")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        Description(description: "This is a sample description that might be long enough to exceed four lines depending on the screen size and font settings. It will demonstrate how to handle long text in SwiftUI.")
        
        Spacer()
        
        // Extra long
        Description(description:
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dolor ante, porttitor ac ante a, congue maximus diam. Morbi at molestie libero. Etiam lacinia tellus at felis vestibulum fermentum. Nam consequat metus quis faucibus convallis. Morbi sed ullamcorper dui, eget laoreet neque. Suspendisse euismod accumsan suscipit. Sed sagittis diam vel mauris placerat, non lacinia nisi pharetra. Donec quis dui bibendum libero vulputate rutrum id ac augue. Duis euismod risus ac orci placerat tristique ut a felis. Donec congue vel mauris a finibus. Suspendisse vel lectus nec turpis vulputate volutpat in lobortis urna. Morbi tincidunt pellentesque magna in consequat.
            
            Etiam blandit ligula eu nisl interdum bibendum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi posuere velit dui, eget dapibus orci varius quis. Fusce maximus felis in ipsum sodales, ut tincidunt libero sagittis. Cras rutrum ipsum auctor nibh mollis, a rutrum diam gravida. Nam quis mi pulvinar, posuere justo id, pulvinar diam. Nullam pulvinar lobortis elit, sed gravida risus porttitor id. Ut at risus accumsan, volutpat sapien et, porta mauris. Aliquam erat volutpat.
            
            Aenean feugiat pulvinar tortor pellentesque scelerisque. Pellentesque nec risus eget turpis bibendum vestibulum. Aliquam eu volutpat lacus. Nam rhoncus elementum mattis. Maecenas arcu arcu, eleifend ac commodo rutrum, ultricies quis metus. Vestibulum at est tristique ex lacinia rutrum sed finibus justo. Vivamus sodales dolor non purus volutpat, quis imperdiet dui maximus. Donec et nibh sit amet eros porta sagittis in nec metus. Aliquam vel tincidunt eros, facilisis gravida sem. Praesent tellus ligula, tempus a vehicula non, semper nec purus. Aenean mollis lorem aliquet nisl pulvinar ullamcorper.
            """
        )
        
        Spacer()
    }
}


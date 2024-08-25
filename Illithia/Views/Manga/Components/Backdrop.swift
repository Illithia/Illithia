import SwiftUI
import Kingfisher

struct Backdrop: View {
    let coverUrl: URL
    
    init(coverUrl: URL = URL(string: "https://example.com/default-image.jpg")!) {  // Providing a valid default URL
        self.coverUrl = coverUrl
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    KFImage(coverUrl)
                        .placeholder {
                            ProgressView()
                                .frame(height: 600)
                        }
                        .retry(maxCount: 5, interval: .seconds(2))
                        .resizable()
                        .fade(duration: 0.25)
                        .scaledToFill()
                        .frame(height: 600)
                        .frame(width: geometry.size.width)
                        .clipped()  // Ensures that the image does not overflow the bounds
                    Spacer()
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    Backdrop()
}

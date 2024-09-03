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
                    ZStack {
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
                            .clipped()
                        
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color("BackgroundColor").opacity(0.0), location: 0.0),
                                .init(color: Color("BackgroundColor").opacity(1.0), location: 1.0)
                            ]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(height: 600)
                    }
                    
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

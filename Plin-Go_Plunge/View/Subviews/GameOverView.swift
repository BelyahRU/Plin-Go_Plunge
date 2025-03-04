
import SwiftUI

struct GameOverView: View {
    
    var onRetry: () -> Void
    var onMenu: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.blue.withAlphaComponent(0.2))
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 10) {
                Image("gameOverLabel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360, height: 257)
                Button {
                    onRetry()
                } label: {
                    Image("retryButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 231,height: 68)
                }
                
                Button {
                    onMenu()
                } label: {
                    Image("menuButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 231,height: 68)
                }
            }
            .padding(.bottom, 100)

        }
        .edgesIgnoringSafeArea(.all)
    }
}


import SwiftUI

struct ArtifactInfoView: View {
    
    var lvl: Int
    var onBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.blue.withAlphaComponent(0.2))
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .topTrailing) {
                Image("artifactInfo\(lvl)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Button {
                    onBack()
                } label: {
                    Image("cancelButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.top, -10)
                        .padding(.trailing, -10)
                }

            }
            .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2)

        }
    }
}


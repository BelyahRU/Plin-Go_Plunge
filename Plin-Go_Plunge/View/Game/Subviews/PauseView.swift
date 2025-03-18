
import SwiftUI

struct PauseView: View {
    
    var onContinue: () -> Void
    var onMenu: () -> Void
    var onShop: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.purple.withAlphaComponent(0.2))
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .top) {
                Image("pauseBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 301, height: 322)
                VStack(alignment: .center, spacing: 10) {
                    Button {
                        onContinue()
                    } label: {
                        Image("pauseContinueButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                    }
                    .frame(height: 54)
                    
                    Button {
                        let _ = HeardsManager.shared.subtractHeards(1)
                        onMenu()
                    } label: {
                        Image("pauseMenuButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                    }
                    .frame(height: 54)
                    
                    Button {
                        onShop()
                    } label: {
                        Image("pauseShopButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                    }
                    .frame(height: 54)
                }
                .padding(.top, 90)

            }
            .padding(.bottom, (ScreenSizes.isSmallScreen ? 70:0))


        }
        .edgesIgnoringSafeArea(.all)
    }
}



import SwiftUI

struct WinView: View {
    
    var onNextLevel: () -> Void
    var onMenu: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("winBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 22) {
                ZStack(alignment: .bottom) {
                    Image("youWinSubview")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 334, height: 415)
                }
                .frame(width: 334, height: 415)
                
                VStack(alignment: .center, spacing: 12) {
                    Button {
                        onNextLevel()
                    } label: {
                        Image("nextLevelButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 52)
                    }
                    
                    Button {
                        onMenu()
                    } label: {
                        Image("menuButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                }

            }
            
            
            
            
        }
    }
}


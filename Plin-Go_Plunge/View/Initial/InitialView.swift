
import SwiftUI

struct InitialView:View {
    
    var onHome: () -> Void
    
    @State var currentScreen = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("initialBack\(currentScreen)")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                Image("initialText\(currentScreen)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 297, height: 165)
                    .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 120: 200))
                
                if currentScreen == 4 {
                    Button {
                        onHome()
                    } label: {
                        Image("initialPlayButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 147, height: 48)
                    }
                    .frame(width: 147, height: 48)
                    .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 240: 320))
                }
                
                if currentScreen > 1 {
                    Button {
                        if currentScreen > 1 {
                            currentScreen -= 1
                        }
                    } label: {
                        Image("initialLeftButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .frame(width: 60, height: 60)
                    .position(x: 45, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 60: 140))
                }
                
                // Кнопка для перехода на следующую страницу
                if currentScreen < 4 {
                    Button {
                        if currentScreen < 4 {
                            currentScreen += 1
                        }
                    } label: {
                        Image("initialRightButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .frame(width: 60, height: 60)
                    .position(x: ScreenSizes.screenWidth - 45, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 60: 140))
                }
            }
        }
    }
}


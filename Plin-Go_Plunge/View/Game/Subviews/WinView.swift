
import SwiftUI

struct WinView: View {
    
    var onNextLevel: () -> Void
    var onMenu: () -> Void
    var time: Int
    var level: Int
    var isLevelWinBefore: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("winBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 22) {
                ZStack(alignment: .top) {
                    if !isLevelWinBefore {
                        Image("winBonus\(level)")
                            .resizable().scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, -82)
                    }
                    ZStack(alignment: .bottom) {
                        Image("youWinSubview")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 334, height: 415)
                        VStack(alignment: .center, spacing: 36) {
                            Text("\(time)s")
                                .font(.custom("Amiri-Bold", size: 23))
                                .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 195/255))
                            
                                .customeStroke(
                                    color: Color(red: 1/255.0, green: 58/255.0, blue: 118/255.0),
                                    width: 3
                                )
                            Text("\(BestTimeManager.shared.bestTime(for: level)!)s")
                                .font(.custom("Amiri-Bold", size: 23))
                                .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 195/255))
                            
                                .customeStroke(
                                    color: Color(red: 1/255.0, green: 58/255.0, blue: 118/255.0),
                                    width: 3
                                )
                        }
                        .padding(.bottom, 19.5)
                    }
                    .frame(width: 334, height: 415)
                }
                .padding(.bottom, ScreenSizes.isSmallScreen ? 50:0)
                
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
                .padding(.bottom, ScreenSizes.isSmallScreen ? 50:0)

            }
            
        }
        .onDisappear {
            BestTimeManager.shared.updateBestTime(for: level, with: time)
        }
    }
}


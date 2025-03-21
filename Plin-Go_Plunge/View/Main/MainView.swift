import SwiftUI

struct MainView: View {
    
    @State var isShopOpened = false
    
    var body: some View {
        NavigationView { // Оборачиваем все в NavigationView
            ZStack {
                ZStack {
                    Image("mainBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    // Навигация на LevelsView
                    NavigationLink(destination: LevelsView(), label: {
                        Image("playButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 86, height: 101)
                    })
                    .frame(width: 86, height: 101)
                    .position(x: ScreenSizes.screenWidth - (ScreenSizes.isBigScreen ? 105 : 100), y: ScreenSizes.isBigScreen ? 310 : 280)
                    
                    VStack(spacing: 0) {
                        // Навигация на ArtifactsView
                        NavigationLink(destination: ArtifactsView(), label: {
                            Image("artifactsButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260)
                        })
                        .frame(width: 260)
                        
                        Text("Last completed\nlevel: 1")
                            .font(.custom("Kavoon-Regular", size: 30))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .customeStroke(color: Color(red: 32/255.0, green: 102/255.0, blue: 173/255.0), width: 3)
                    }
                    .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 100 : 150))
                    
                    DailyBonusView()
                        .position(x: 70, y: ScreenSizes.isSmallScreen ? 240 : 200)
                }
                .navigationBarHidden(true)
                .blur(radius: isShopOpened ? 5 : 0)
                if isShopOpened {
                    ShopView(onBack: {
                        isShopOpened = false
                    }, isPause: false)
                }
                
                HStack(alignment: .center) {
                    HeardsView(onShop: {
                        isShopOpened.toggle()
                    })
                    Spacer()
                    CoinsView()
                }
                .padding(.horizontal, 12)
                .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.isSmallScreen ? 120 :70)
            }// Скрываем NavigationBar, если не нужен
            .navigationBarHidden(true)
            
        }
    }
}

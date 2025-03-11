
import SwiftUI

struct ShopView: View {
    
    var onBack: () -> Void
    var isPause: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.blue.withAlphaComponent(0.2))
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .topTrailing) {
                Image("shopBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 343, height: 456)
                Button {
                    onBack()
                } label: {
                    Image("cancelButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.top, 30)
                        .padding(.trailing, -12)
                }
                .frame(width: 60, height: 60)

            }
            .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2 - 70)
            
            HStack(alignment: .center, spacing: 12) {
                ZStack(alignment: .bottom) {
                    Image("shopItem150")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 144, height: 162)
                    Button {
                        print("shopItem150")
                        HeardsManager.shared.boughtHeards(3)
                    } label: {
                        Image("shopButton150")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 91, height: 40)
                    }
                    .frame(width: 91, height: 40)
                    .padding(.bottom, 8)
                }
                .frame(width: 144, height: 162)
                
                ZStack(alignment: .bottom) {
                    Image("shopItem300")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 144, height: 162)
                    Button {
                        print("shopItem300")
                        HeardsManager.shared.boughtHeards(6)
                    } label: {
                        Image("shopButton300")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 91, height: 40)
                    }
                    .frame(width: 91, height: 40)
                    .padding(.bottom, 8)
                }
                .frame(width: 144, height: 162)
                
            }
            .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2 - 130)
            
            ZStack(alignment: .bottom) {
                Image("shopItem550")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 144, height: 162)
                Button {
                    print("shopItem550")
                    HeardsManager.shared.boughtHeards(9)
                } label: {
                    Image("shopButton550")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 91, height: 40)
                }
                .frame(width: 91, height: 40)
                .padding(.bottom, 8)
            }
            .frame(width: 144, height: 162)
            .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2 + 40)
        }
    }
}


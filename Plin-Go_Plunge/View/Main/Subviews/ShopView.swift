import SwiftUI

struct ShopView: View {
    var onBack: () -> Void
    var isPause: Bool
    
    @State private var showPurchaseAlert = false
    @State private var pendingPurchase: (() -> Void)? = nil
    @State private var pendingHearts: Int = 0
    
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
                // Shop item 150
                ZStack(alignment: .bottom) {
                    Image("shopItem150")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 144, height: 162)
                    Button {
                        print("shopItem150")
                        // Сохраняем замыкание покупки, которое выполнится при подтверждении
                        if CristalsManager.shared.currentCount >= 150 {
                            pendingPurchase = {
                                if CristalsManager.shared.subtractCristals(150) {
                                    HeardsManager.shared.boughtHeards(3)
                                }
                            }
                            pendingHearts = 3
                            showPurchaseAlert = true
                        }
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
                
                // Shop item 300
                ZStack(alignment: .bottom) {
                    Image("shopItem300")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 144, height: 162)
                    Button {
                        print("shopItem300")
                        if CristalsManager.shared.currentCount >= 300 {
                            pendingPurchase = {
                                if CristalsManager.shared.subtractCristals(300) {
                                    HeardsManager.shared.boughtHeards(6)
                                }
                            }
                            pendingHearts = 6
                            showPurchaseAlert = true
                        }
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
            
            // Shop item 550
            ZStack(alignment: .bottom) {
                Image("shopItem550")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 144, height: 162)
                Button {
                    print("shopItem550")
                    if CristalsManager.shared.currentCount >= 550 {
                        pendingPurchase = {
                            if CristalsManager.shared.subtractCristals(550) {
                                HeardsManager.shared.boughtHeards(9)
                            }
                        }
                        pendingHearts = 9
                        showPurchaseAlert = true
                    }
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
        // Добавляем alert для подтверждения покупки
        .alert(isPresented: $showPurchaseAlert) {
            Alert(
                title: Text("Confirm Purchase"),
                message: Text("Are you sure you want to buy \(pendingHearts) heart\(pendingHearts > 1 ? "s" : "")?"),
                primaryButton: .default(Text("Yes"), action: {
                    pendingPurchase?()
                    pendingPurchase = nil
                    pendingHearts = 0
                }),
                secondaryButton: .cancel({
                    pendingPurchase = nil
                    pendingHearts = 0
                })
            )
        }
        .padding(.top,ScreenSizes.isSmallScreen ? 120 : 0)

    }
}

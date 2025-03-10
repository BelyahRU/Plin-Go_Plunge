
import SwiftUI

struct DailyBonusView: View {
    @StateObject private var bonusManager = DailyBonusManager.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if bonusManager.isBonusActive {
                Image("dailyGiftImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 67, height: 75)
            } else {
                ZStack {
                    Image("dailyGiftImageBlocked")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 67, height: 75)
                    Text(bonusManager.timeRemaining)
                        .font(.custom("Amiri-Bold", size: 23))
                        .foregroundColor(.white)
                        .padding(.top, 3)
                }
            }
            
            Button {
                if bonusManager.isBonusActive {
                    bonusManager.claimBonus()
                }
            } label: {
                Image(bonusManager.isBonusActive ? "takeButton" : "takenButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 81, height: 34)
            }
            .frame(width: 81, height: 34)
            
            Image(bonusManager.progressImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 99, height: 36)
        }
    }
}

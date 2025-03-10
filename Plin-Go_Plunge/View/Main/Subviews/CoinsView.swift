
import SwiftUI

struct CoinsView: View {
    
    @ObservedObject var cristalsManager = CristalsManager.shared
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("coinsBack")
                .resizable()
                .scaledToFit()
                .frame(width: 126, height: 41)
            ZStack(alignment: .center) {
                Image("coinsTextBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 76, height: 30)
                Text("\(cristalsManager.currentCount)")
                    .font(.custom("Amiri-Bold", size: 23))
                    .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                    .padding(.top, 3)
            }
            .frame(width: 76, height: 30)
            .padding(.trailing, 6)
            .padding(.top, -3)
        }
        .frame(width: 126, height: 41)
    }
}

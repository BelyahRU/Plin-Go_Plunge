
import SwiftUI

struct HeartsGameView: View {
    
    @ObservedObject var heardsManager = HeardsManager.shared
    
    var body: some View {
        ZStack {
            Image("heart")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            Text("\(heardsManager.currentHeards)")
                .font(.custom("Kavoon-Regular", size: 25))
                .foregroundStyle(.white)
                .padding(.top, -7)
                .padding(.trailing, 3)
        }
    }
}


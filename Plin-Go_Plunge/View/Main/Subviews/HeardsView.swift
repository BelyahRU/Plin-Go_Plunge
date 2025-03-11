
import SwiftUI

struct HeardsView: View {
    
    var onShop: () -> Void
    
    @ObservedObject var heardsManager = HeardsManager.shared
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                Image("heardsBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 152, height: 59)
                
                ZStack(alignment: .center) {
                    Image("heardsTextBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 69, height: 30)
                    
                    Text(heardsManager.timeRemaining)
                        .font(.custom("Amiri-Bold", size: 23))
                        .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                        .padding(.top, 1)
                }
                .frame(width: 76, height: 30)
                .padding(.trailing, 26)
                .padding(.top, 3)
                
                Button {
                    onShop()
                } label: {
                    Image("plusButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 47, height: 40)
                        .padding(.trailing, -30)
                }
                .frame(width: 47, height: 40)
            }
            .frame(width: 152, height: 59)
            
            Text("\(heardsManager.currentHeards)")
                .font(.custom("Kavoon-Regular", size: 25))
                .foregroundStyle(.white)
                .padding(.leading, heardsManager.currentHeards.description.count >= 2 ? 18 : 23)
                .padding(.top, -7)
        }
        .navigationBarHidden(true)
    }
}

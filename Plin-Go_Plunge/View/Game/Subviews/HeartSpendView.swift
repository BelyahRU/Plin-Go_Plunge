
import SwiftUI

struct HeartSpendView: View {
    
    var onContinue: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.purple.withAlphaComponent(0.2))
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                Image("heartBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 342, height: 511)
                VStack(alignment: .center, spacing: 15) {
                    Button {
                        onContinue()
                    } label: {
                        Image("continueHeartButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                    }
                    .frame(height: 54)
                    
                    Button {
                        onBack()
                    } label: {
                        Image("backHeartButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                    }
                    .frame(height: 54)
                    
                }
                .padding(.bottom, 50)
            }


        }
        .edgesIgnoringSafeArea(.all)
    }
}

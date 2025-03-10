
import SwiftUI

struct CustomText: View {
    let text: String
    let size: CGFloat
    let width: CGFloat = 3
    let color = Color(red: 32/255, green: 102/255, blue: 173/255)
    
    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
                .font(.custom("Kavoon-Regular", size: size))
        }
    }
}

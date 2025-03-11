
import SwiftUI

extension View {
    func customeStroke(color: Color, width: CGFloat) -> some View {
        self.modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}


import SwiftUI

struct StrokeModifier: ViewModifier {
    var strokeSize: CGFloat
    var strokeColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask(outline(context: content))
            )
    }
    private func outline(context: Content) -> some View {
        let symbolID = UUID()
        return Canvas { ctx, size in
            ctx.addFilter(.alphaThreshold(min: 0.01))
            ctx.drawLayer { layer in
                if let resolved = ctx.resolveSymbol(id: symbolID) {
                    layer.draw(resolved, at: CGPoint(x: size.width / 2, y: size.height / 2))
                }
            }
        } symbols: {
            context.tag(symbolID).blur(radius: strokeSize)
        }
    }

}


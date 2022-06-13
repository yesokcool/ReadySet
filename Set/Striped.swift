
import SwiftUI

struct Striped: ViewModifier {
    let geometry: GeometryProxy
    let color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            makeStripes().mask(content)
        }
    }
    
    @ViewBuilder func makeStripes() -> some View {
        let numberOfStripes = abs(geometry.size.width * 0.16)
        HStack(spacing: abs(geometry.size.width) * 0.04) {
            ForEach(0 ..< Int(abs(numberOfStripes)), id: \.self) { _ in
                Rectangle()
                    .foregroundColor(color)
                    .frame(maxWidth: abs(geometry.size.width))
            }
        }
    }
}

extension View {
    func striped(geometry: GeometryProxy, color: Color) -> some View {
        self.modifier(Striped(geometry: geometry, color: color))
    }
}

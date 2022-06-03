
import SwiftUI

struct Striped: ViewModifier {
    let geometry: GeometryProxy
    
    func body(content: Content) -> some View {
        ZStack {
            content
            makeStripes()
        }
    }
    
    @ViewBuilder func makeStripes() -> some View {
        let numberOfStripes = Int(geometry.size.width * 0.16)
        HStack(spacing: 4) {
            ForEach(0..<numberOfStripes, id: \.self) { _ in
                Rectangle()
                    .foregroundColor(.white)
                    .frame(maxWidth: 2)
            }
        }
    }
}

extension View {
    func striped(geometry: GeometryProxy) -> some View {
        self.modifier(Striped(geometry: geometry))
    }
}

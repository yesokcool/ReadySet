
import SwiftUI

struct TraitColorize: ViewModifier {
    let color: Color
    let geometry: GeometryProxy
    let isSelected: Bool
    let isStriped: Bool
    let isRectangle: Bool
    
    func body(content: Content) -> some View {
        if isStriped {
            if isRectangle {
                content
                    .foregroundColor(color)
                    .striped(geometry: geometry, color: color)
                    .frame(maxHeight: abs(geometry.size.height * CardConstants.rectangleHeightMultiplier))
                    .shadow(color: color.opacity(CardConstants.glowOpacity),
                            radius: isSelected ? CardConstants.glowRadius + 20.0 : CardConstants.glowRadius, y: CardConstants.glowOffset)
            } else {
                content
                    .foregroundColor(color)
                    .striped(geometry: geometry, color: color)
                    .shadow(color: color.opacity(CardConstants.glowOpacity), radius: CardConstants.glowRadius, y: CardConstants.glowOffset)
            }
        } else {
            if isRectangle {
                content
                    .foregroundColor(color)
                    .frame(maxHeight: abs(geometry.size.height * CardConstants.rectangleHeightMultiplier))
                    .shadow(color: color.opacity(CardConstants.glowOpacity),
                            radius: isSelected ? CardConstants.glowRadius + 20.0 : CardConstants.glowRadius, y: CardConstants.glowOffset)
            } else {
                content
                    .foregroundColor(color)
                    .shadow(color: color.opacity(CardConstants.glowOpacity), radius: CardConstants.glowRadius, y: CardConstants.glowOffset)
            }
        }
    }
    
    struct CardConstants {
        static let cornerRadiusRectangleMultiplier: CGFloat = 0.3
        static let rectangleHeightMultiplier: CGFloat = 0.2
        static let lineWidthMultiplier: CGFloat = 0.03
        static let glowRadius: CGFloat = 5.0
        static let glowOffset: CGFloat = 10.0
        static let glowOpacity: CGFloat = 0.4
        static let glowGrow: CGFloat = 20.0
    }
}

extension View {
    func traitColorize(color: Color, geometry: GeometryProxy, isSelected: Bool, isStriped: Bool, isRectangle: Bool) -> some View {
        self.modifier(TraitColorize(color: color, geometry: geometry, isSelected: isSelected, isStriped: isStriped, isRectangle: isRectangle))
    }
}

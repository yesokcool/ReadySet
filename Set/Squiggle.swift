
import SwiftUI

struct Squiggle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let unit = min(rect.width, rect.height) * 0.25
        
        let down: CGFloat = unit
        let right: CGFloat = unit * 2
        
        let up = -down
        let left = -right
        
        let x = center.x
        let y = center.y
        
        let origin = CGPoint(x: x + left, y: y + up)
        
        // Top left point -> Top right point
        path.move(to: origin)
        path.addCurve(to: CGPoint(x: x + right, y: y + up),
                      control1: CGPoint(x: x + (0.2 * left), y: y + up + up),
                      control2: CGPoint(x: x + (0.2 * right), y: y + (0.2) * down))
    
        // Top right point -> Bottom right point
        path.addCurve(to: CGPoint(x: x + right, y: y + down),
                      control1: CGPoint(x: x + right + (right / 2.0), y: y + (up * 1.5)),
                      control2: CGPoint(x: x + right + (right / 3.0), y: y + (down / 2.0)))
        
        // Bottom right point -> Bottom left point
        path.addCurve(to: CGPoint(x: x + left, y: y + down),
                      control1: CGPoint(x: x + (0.2 * right), y: y + down + down),
                      control2: CGPoint(x: x + (0.2 * left), y: y + (0.2) * up))
        
        // Bottom left point -> Top left point
        path.addCurve(to: CGPoint(x: x + left, y: y + up),
                      control1: CGPoint(x: x + left + (left / 2.0), y: y + (down * 1.5)),
                      control2: CGPoint(x: x + left + (left / 3.0), y: y + (up / 2.0)))
        
        path.closeSubpath()
        
        return path
    }
}

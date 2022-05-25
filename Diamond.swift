
import SwiftUI

struct Diamond: Shape {
    var size: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height) / 2
        
        var p = Path()
        p.addLines(
        [
            CGPoint(x: center.x, y:center.y + size),
            CGPoint(x: center.x + size, y:center.y),
            CGPoint(x: center.x, y:center.y - size),
            CGPoint(x: center.x - size, y:center.y),
            CGPoint(x: center.x, y:center.y + size),
        ])
        
        p.closeSubpath()
        
        return p
    }
}


//
//  Created on 3/29/22.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ShapeSetView(game: ShapeSetGame(4, 3, 3))
        }
    }
}

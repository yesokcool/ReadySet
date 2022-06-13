
import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ShapeSetView(game: ShapeSetGame(numberOfTraits: 4, numberOfTraitTypes: 3, withSetsOf: 3))
        }
    }
}


//
//  Created on 3/29/22.
//

import SwiftUI

struct ShapeSetView: View {
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    CardView()
                    CardView()
                    CardView()
                    CardView()
                    var game = ShapeSetGame()
                }
            }
        }
    }
}

struct CardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill()
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth:5)
                .foregroundColor(.gray)
        }
        .aspectRatio(2/3.5, contentMode: .fit)
        .padding(10)
    }
}


























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetView().preferredColorScheme(.dark)
    }
}

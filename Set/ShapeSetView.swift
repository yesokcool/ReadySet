
import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    
    // TODO: Make text pull from a library of possible texts randomly for each game
    // TODO: Add some ways to speed up the game. Like if you match multiple sets quickly, you get a special vision that shows you sets to match and matching them has an intense POWERFUL-feeling animation, screen shake, pop up text saying quake-like stuff like unstoppable, particles of randomized emojis like cows etc. And if you keep matching fast, it keeps the mode going.
    // TODO: Add animation when breaking high score
    var body: some View {
        if (!game.gameComplete()) {
            VStack {
                VStack {
                    if (game.twoPlayers()) {
                        HStack {
                            VStack {
                                Group {
                                    Button {
                                        game.playerTwoTurn()
                                    } label: {
                                        Image(systemName: "flag.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.blue)
                                    }
                                    .frame(width: 100)
                                    Text("P2 SCORE: ")
                                            .font(.title3)
                                            .fontWeight(.heavy)
                                    Text("\(game.getScore()) OCEANS SAVED")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .rotationEffect(Angle.degrees(180))
                                .foregroundColor(game.getHighScore() == game.getScore() &&
                                                 game.getHighScore() != 0 ?
                                                 Color.orange : Color.blue)
                            }
                        }
                    }
                    HStack {
                        VStack {
                            Text("HIGH SCORE:")
                                .font(.title3)
                                .fontWeight(.heavy)
                            Text("\(game.getHighScore()) GOOD JOBS")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(game.getHighScore() == game.getScore() &&
                                         game.getHighScore() != 0 ?
                                         Color.orange : Color.blue)
                        .multilineTextAlignment(.center)
                        VStack {
                            if !game.twoPlayers() {
                                Group {
                                Text("SCORE: ")
                                        .font(.title3)
                                        .fontWeight(.heavy)
                                Text("\(game.getScore()) OCEANS SAVED")
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(game.getHighScore() == game.getScore() &&
                                             game.getHighScore() != 0 ?
                                             Color.orange : Color.blue)
                            }
                        }
                    }
                    .padding(.horizontal, 25.0)
                    .padding(.top, 5.0)
                   
                    Text("\(game.getScoreModifier()) PUPPIES ARE DEPENDING ON YOU")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.all, 6.0)
                    
                    if game.cheat() {
                        if game.setAvailable() {
                            Text("\(game.cheatIndices().description)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        else {
                            Text("No sets!")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                AspectVGrid(items: game.getCardsInPlay(), aspectRatio: 2/3) { card in
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                    }
                }
                Spacer()
                VStack {
                    if game.twoPlayers() {
                        VStack {
                            Group {
                            Text("SCORE: ")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                            Text("\(game.getScore()) OCEANS SAVED")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(game.getHighScore() == game.getScore() &&
                                         game.getHighScore() != 0 ?
                                         Color.orange : Color.blue)
                        }
                        Button {
                            game.playerOneTurn()
                        } label: {
                            Image(systemName: "flag.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)
                                    .frame(width: 100)
                        }
                    }
                    HStack() {
                        Button {
                            game.newGame()
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                        }
                        Spacer()
                        Button {
                            game.twoPlayerMode()
                        } label: {
                            game.twoPlayers() ?
                                Image(systemName: "person.2.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)
                                    .frame(width: 50)
                                : Image(systemName: "person.2.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)
                                    .frame(width: 50)
                        }
                        Spacer()
                        Button {
                            game.cheatToggle()
                        } label: {
                            game.cheat() ?
                            Image(systemName: "magnifyingglass.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.red)
                                .frame(width: 50)
                            :
                            Image(systemName: "magnifyingglass.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.blue)
                                .frame(width: 50)
                        }
                        Spacer()
                        Button {
                            game.dealThree()
                        } label: {
                            buttonBuilder()
                        }
                    }
                    .padding(.horizontal, 35.0)
                    .padding(.bottom, 10.0)
                    .foregroundColor(.blue)
                }
                
                
            }.foregroundColor(.primary)
        }
        else {
            VStack {
                Text("GAME COMPLETE!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("FINAL SCORE: \(game.getScore())")
                    .font(.title2)
                    .fontWeight(.semibold)
                Button {
                    game.newGame()
                } label: {
                    VStack {
                    Text("NEW GAME?")
                        .font(.title)
                        .padding(10)
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func buttonBuilder() -> some View {
        if (game.deckEmpty()) {
            Image(systemName: "square.stack.3d.down.right.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .opacity(0)
        }
        else {
            Image(systemName: "square.stack.3d.down.right.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
        }
    }
}

// TODO: Can probably make a @Viewbuilder function that returns Some View instead
// of these long switch statements?
struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    renderTrait(with: geometry)
                }
            }
            .padding(8.0)
            .cardify(card: card)
        }
    }
    
    func getColor(_ color: Int) -> Color {
        switch color {
            case 0:
                return .cyan
            case 1:
                return .pink
            default:
                return .green
        }
    }
    
    func getOpacity(_ opacity: Int) -> Double {
        switch opacity {
            case 1:
                return 0.3
            default:
                return 1.0
        }
    }
    
    // TODO: There may be a way to generalize these shapes more so it's easier to add in more shapes. e.g putting the shapes in an array, iterating through the array instead of literally writing shapes. Would have to make sure to add some sort of parameter for their frame maxheight though. then use ternary to check for it
    @ViewBuilder func renderTrait(with geometry: GeometryProxy) -> some View {
        let cornerRadiusRectangle: CGFloat = geometry.size.width * 0.3
        let rectangleHeight: CGFloat = geometry.size.height * 0.2
        let lineWidth: CGFloat = geometry.size.width * 0.03
        
        ForEach(0..<card.traits[0].type + 1, id: \.self) { _ in
            switch card.traits[1].type {
            case 0:
                if card.traits[2].type == 2 {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                }
                else if card.traits[2].type == 1 {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                        .background() {
                            WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
                                .frame(maxHeight: rectangleHeight)
                        }
                    }
                else {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                }
            case 1:
                if card.traits[2].type == 2 {
                    Squiggle()
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Squiggle()
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Squiggle()
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
                        }
                }
                else {
                    Squiggle()
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                }
            default:
                if card.traits[2].type == 2 {
                    Diamond(size: 5)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Diamond(size:5)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Diamond(size:5)
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
                        }
                }
                else {
                    Diamond(size:5)
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(4, 3, 3)
        return ShapeSetView(game: game).preferredColorScheme(.light)
    }
}

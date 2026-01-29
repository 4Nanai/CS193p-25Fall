//
//  ContentView.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(
//        pegChoices: [
//            .color("red"),
//            .color("blue"),
//            .color("green"),
//            .color("yellow"),
//            .color("orange")
//        ],
//        pegCount: 5,
//        mode: .color
        pegChoices: [
            .emoji("😇"),
            .emoji("😭"),
            .emoji("😀"),
            .emoji("😍"),
            .emoji("😊"),
            .emoji("🙈")
        ],
        pegCount: 5,
        mode: .face
    )
    
    var body: some View {
        VStack {
            title.font(.title)
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            .overlay {
                VStack {
                    Spacer()
                    restartButton
                }
            }
        }
        .padding()
    }
    
    var title: some View {
        switch game.gameMode {
        case .color: Text("Color Mode")
        case .earth: Text("Earth Mode")
        case .face: Text("Face Mode")
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View {
        Button {
            withAnimation{
                game.restartGame()
            }
        } label: {
            Text("Restart")
                .padding()
                .font(.title)
        }
        .buttonStyle(.glassProminent)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) { index in
                Circle()
                    .fill(.clear)
                    .overlay {
                        switch code.pegs[index] {
                        case .clear:
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                                .aspectRatio(1, contentMode: .fit)
                        case .color(let name):
                            Circle()
                                .fill(Color(name: name) ?? .gray)
                        case .emoji(let text):
                            Text(text)
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                        }
                    }
                    .contentShape(Circle())
                    .onTapGesture {
                        // Handle color change
                        if code.kind == .guess {
                            withAnimation() {
                                game.changeGuessPeg(at: index)
                            }
                            
                        }
                    }
            }
            MatchMarkerView(matchs: code.matchs)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

extension Color {
    // init? indicates that this is a failable initializer
    // If it can't find a matching color, it will return nil
    init?(name: String) {
        switch name.lowercased() {
        case "red":     self = .red
        case "blue":    self = .blue
        case "green":   self = .green
        case "yellow":  self = .yellow
        case "orange":  self = .orange
        case "purple":  self = .purple
        case "black":   self = .black
        case "white":   self = .white
        case "gray":    self = .gray
        case "clear":   self = .clear
        default:        return nil
        }
    }
}

#Preview {
    CodeBreakerView()
}

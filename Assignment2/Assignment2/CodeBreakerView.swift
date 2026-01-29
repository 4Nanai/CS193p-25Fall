//
//  ContentView.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(
        pegChoices: [.red, .blue, .green, .yellow, .gray]
    )
    
    var body: some View {
        VStack {
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
                    .fill(code.pegs[index])
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                                .aspectRatio(1, contentMode: .fit)
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


#Preview {
    CodeBreakerView()
}

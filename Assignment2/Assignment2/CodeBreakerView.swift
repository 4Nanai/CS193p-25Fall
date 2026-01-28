//
//  ContentView.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: [.red, .blue, .green, .yellow])
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            view(for: game.guess)
            ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                view(for: game.attempts[index])
            }
            Button("Guess") {
                game.attemptGuess()
            }
        }
        .padding()
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) { index in
                Circle()
                    .fill(code.pegs[index])
                    .onTapGesture {
                        // Handle color change
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkerView(matchs: [.exact, .inexact, .nomatch, .exact])
        }
    }
}


#Preview {
    CodeBreakerView()
}

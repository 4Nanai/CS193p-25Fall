//
//  ContentView.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .blue, .green, .yellow])
            pegs(colors: [.blue, .red, .red, .green])
            pegs(colors: [.yellow, .green, .blue, .red])
            pegs(colors: [.green, .yellow, .yellow, .blue])
        }
        .padding()
    }
    
    func pegs(colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id:\.self) {
                Circle().fill(colors[$0])
            }
            MatchMarkerView(matchs: [.exact, .inexact, .nomatch, .exact])
        }
    }
}


#Preview {
    ContentView()
}

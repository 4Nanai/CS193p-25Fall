//
//  MatchMarkerView.swift
//  Assignment1
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI


enum match {
    case exact
    case inexact
    case nomatch
}

struct MatchMarkerView: View {
    let matchs: [match]
    var body: some View {
        VStack {
            HStack {
                DrawMarker(peg: 0)
                DrawMarker(peg: 1)
            }
            HStack {
                DrawMarker(peg: 2)
                DrawMarker(peg: 3)
            }
        }
    }
    
    func DrawMarker(peg: Int) -> some View {
        let exactCount = matchs.count(where: { match in match == .exact })
        let foundCount = matchs.count(where: { match in match != .nomatch })
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}



#Preview {
    MatchMarkerView(matchs: [.exact, .inexact, .nomatch, .exact])
}

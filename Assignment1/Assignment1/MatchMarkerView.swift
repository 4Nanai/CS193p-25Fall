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
        let exactCount = matchs.count { $0 == .exact }
        let foundCount = matchs.count { $0 != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct MatchMarkerPreview: View {
    let dummyPegCount: Int
    let matchs: [match] = [.exact, .inexact, .nomatch, .exact]
    var body: some View {
        HStack {
            ForEach(0..<dummyPegCount, id: \.self) { _ in
                Circle()
            }
            MatchMarkerView(matchs: matchs)
        }
        .padding()
    }
}


#Preview {
    MatchMarkerPreview(dummyPegCount: 4)
}

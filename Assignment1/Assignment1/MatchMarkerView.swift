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
    var col: Int {
        (matchs.count + 1) / 2
    }
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<col, id: \.self) {peg in
                    DrawMarker(peg: peg)
                }
            }
            HStack {
                ForEach(col..<col*2, id: \.self) {peg in
                    DrawMarker(peg: peg)
                }
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
    let matchs: [match]
    var body: some View {
        HStack {
            ForEach(0..<matchs.count, id: \.self) { _ in
                Circle()
            }
            MatchMarkerView(matchs: matchs)
        }
        .padding()
    }
}


#Preview {
    VStack {
        MatchMarkerPreview(matchs: [.exact, .inexact, .nomatch, .exact, .exact, .inexact])
        MatchMarkerPreview(matchs: [.exact, .exact, .exact, .exact])
        MatchMarkerPreview(matchs: [.inexact, .inexact, .inexact])
        MatchMarkerPreview(matchs: [.nomatch, .nomatch, .nomatch, .nomatch, .nomatch])
    }
}

//
//  CodeBreaker.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct CodeBreaker {
    let masterCode = Code(kind: .master)
    var guess = Code(kind: .guess)
    let attempts: [Code] = []
    let pegChoices: [Peg]
    
    mutating func changeGuessPeg(at index: Int) {
        let currentPeg = guess.pegs[index]
        if let currentIndex = pegChoices.firstIndex(of: currentPeg) {
            let nextPeg = pegChoices[(currentIndex + 1) % pegChoices.count]
            guess.pegs[index] = nextPeg
        }
        else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var pegs: [Peg] = [.red, .blue, .green, .yellow]
    let kind: Kind
    
    static var missing: Peg = .clear
    
    enum Kind {
        case master
        case guess
        case attempt
        case unknown
    }
}

typealias Peg = Color

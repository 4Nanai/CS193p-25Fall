//
//  CodeBreaker.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import SwiftUI

struct CodeBreaker {
    var masterCode = Code(kind: .master)
    var guess = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg]) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
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
    
    mutating func attemptGuess() {
        // Ignore attempt with no pegs chosen
        if guess.pegs == Array(repeating: Code.missing, count: guess.pegs.count) {
            return
        }
        
        var newAttempt = guess
        newAttempt.kind = .attempt(guess.match(against: masterCode))
        
        // Ignore attempt already tried
        if (attempts.firstIndex(of: newAttempt) != nil) {
            return
        }
        
        attempts.append(newAttempt)
    }
}

struct Code: Equatable {
    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
    var kind: Kind
    
    static var missing: Peg = .clear
    
    enum Kind: Equatable  {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoice: [Peg]) {
        for index in pegChoice.indices {
            pegs[index] = pegChoice.randomElement() ?? Code.missing
        }
    }
    
    var matchs: [Match] {
        switch kind {
        case .attempt(let matchs): return matchs
        default: return []
        }
    }
    
    func match(against masterCode: Code) -> [Match] {
        var results = Array<Match>(repeating: .nomatch, count: pegs.count)
        var masterPegs = masterCode.pegs
        for index in pegs.indices.reversed() {
            if masterPegs.count > index, masterPegs[index] == pegs[index] {
                results[index] = .exact
                masterPegs.remove(at: index)
            }
        }
        
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = masterPegs.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    masterPegs.remove(at: matchIndex)
                }
            }
        }
        
        return results
    }
}

typealias Peg = Color

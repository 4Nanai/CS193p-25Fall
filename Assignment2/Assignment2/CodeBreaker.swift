//
//  CodeBreaker.swift
//  Assignment2
//
//  Created by Chitose on 1/27/26.
//

import Foundation

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    
    let initMode: GameMode
    let initSet: [Peg]
    
    static let emojiSet: [Peg] = [
        .emoji("😑"),
        .emoji("😁"),
        .emoji("😉"),
        .emoji("😩"),
        .emoji("😅"),
        .emoji("😇")
    ]
    static let colorSet: [Peg] = [
        .color("red"),
        .color("blue"),
        .color("yellow"),
        .color("green"),
        .color("purple"),
        .color("orange")
    ]
    
    // Configurable peg count
    var pegCount: Int
    
    init(pegChoices: [Peg], pegCount: Int, mode gameMode: GameMode) {
        self.pegChoices = pegChoices
        
        // Init game state
        self.initSet = pegChoices
        self.initMode = gameMode
        
        // Configurable pegCount
        self.pegCount = pegCount
        self.masterCode = Code(kind: .master, count: pegCount)
        self.guess = Code(kind: .guess, count: pegCount)
        masterCode.randomize(from: pegChoices, for: pegCount)
        print(masterCode)
    }
    
    init() {
        let gameMode = GameMode.random()
        self.init(
            pegChoices: gameMode == .color ? CodeBreaker.colorSet : CodeBreaker.emojiSet,
            pegCount: Int.random(in: 3...6),
            mode: gameMode
        )
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let currentPeg = guess.pegs[index]
        if let currentIndex = pegChoices.firstIndex(of: currentPeg) {
            let nextPeg = pegChoices[(currentIndex + 1) % pegChoices.count]
            guess.pegs[index] = nextPeg
//            print(nextPeg.description)
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
        newAttempt.kind = Code.Kind.attempt(guess.match(against: masterCode))
        
        // Ignore attempt already tried
        if (attempts.firstIndex(of: newAttempt) != nil) {
            return
        }
        
        attempts.append(newAttempt)
    }
    
    mutating func restartGame() {
        let randomCount = Int.random(in: 3...6)
        let nextGameMode = GameMode.random()
        if nextGameMode == self.initMode {
            self.pegChoices = self.initSet
        } else {
            self.pegChoices = nextGameMode == .emoji ? CodeBreaker.emojiSet : CodeBreaker.colorSet
        }
            
        self.masterCode = Code(kind: .master, count: randomCount)
        self.masterCode.randomize(from: self.pegChoices, for: randomCount)
        self.guess = Code(kind: .guess, count: randomCount)
        attempts = []
        print("MasterCode:", masterCode)
    }
}

struct Code: Equatable {
    var pegs: [Peg]
    var kind: Kind
    
    init(kind: Kind, count: Int) {
        self.pegs = Array(repeating: Code.missing, count: count)
        self.kind = kind
    }
    
    static var missing: Peg = .clear
    
    enum Kind: Equatable  {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoice: [Peg], for count: Int) {
        for index in 0..<count {
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

enum Peg: Equatable {
    case color(String)
    case emoji(String)
    case clear
    
    var description: String {
        switch self {
        case .color(let name): return name
        case .emoji(let text): return text
        case .clear: return "clear"
        }
    }
}

enum GameMode {
    case color
    case emoji
    
    static func random() -> GameMode {
        if Bool.random() {
            return .emoji
        } else {
            return .color
        }
    }
}

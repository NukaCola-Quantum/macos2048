//
// MIT License
//
// Copyright (c) 2019 Yang Song
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  Algri.swift
//  game2048
//
//  Created by Kane on 2019/4/16.
//

import Cocoa

// Custom struct indexM to index numbers matrix
struct indexM : Hashable {
    var r : Int
    var c : Int
    
    init(row: Int, col: Int) {
        r = row
        c = col
    }
    init() {
        r = 0
        c = 0
    }
    // Add functions, == and hash to correspond the protocol
    static func == (lhv: indexM, rhv: indexM) -> Bool {
        return lhv.c == rhv.c && lhv.r == rhv.r
    }
    
    func hash (into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(c)
    }
}

// Class Algri made the core algorithm of game 2048
// The interface includes only three methods:
// generate() initials matrix and computer the new matrix after every
// play() exacuted
// play() does kinds of actions follow on keyEvent
// Use getvalue() to read values of matrix and the total score
class Algri : NSObject {
    
    private var numMatrix : [[Int]]
    private var tmp : [[Int]]
    private let row = 4
    private let col = 4
    private var flag : Bool = true
    private var score : Int = 0
    
    override init() {
        numMatrix = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: col), count: row)
        tmp = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: col), count: row)
        super.init()
    }
    
    private func chose2or4() -> Int {
        let prop = Float.random(in: 0...1)
        if prop > 0.7 {
            return 4
        } else {
            return 2
        }
    }
    // Check the game state and judge the argument of game over
    private func checkplay() -> Bool {
        for r in 0..<row {
            for c in 0..<col {
                if r < row - 1 && c < col - 1 && (numMatrix[r][c] == numMatrix[r+1][c] || numMatrix[r][c] == numMatrix[r][c+1]) {
                    return true
                }
                if r == row - 1 && c < col - 1 && numMatrix[r][c] == numMatrix[r][c+1] {
                    return true
                }
                if c == col - 1 && r < row - 1 && numMatrix[r][c] == numMatrix[r+1][c] {
                    return true
                }
            }
        }
        return false
    }
    
    func generate() -> Int {
        var indexList : Set<indexM> = []
        // Get all indexes of none zero elements
        for r in 0..<row {
            for c in 0..<col {
                if numMatrix[r][c] == 0 {
                    indexList.insert(indexM(row: r, col: c))
                }
            }
        }
        // assign vaule to matrix
        if let one = indexList.randomElement() {
            if flag {
                numMatrix[one.r][one.c] = chose2or4()
                score += numMatrix[one.r][one.c]
                return 1
            } else {
                return 2
            }
        } else if checkplay() {
            return 2
        } else {
            return 0
        }
    }
    
    func getvalue() -> ([[Int]], Int) {
        return (numMatrix, score)
    }
    
    func play(with direct: String) {
        switch direct {
        case "up":
            self.flag = self.add()
        case "left":
            numMatrix = transpose()
            self.flag = self.add()
            numMatrix = transpose()
        case "down":
            numMatrix = flipUD()
            self.flag = self.add()
            numMatrix = flipUD()
        case "right":
            numMatrix = flipLR()
            numMatrix = transpose()
            self.flag = self.add()
            numMatrix = transpose()
            numMatrix = flipLR()
        default:
            print("Error: Cannot find such command!")
        }
    }
    
    private func add() -> Bool {
        var aflag = false
        for c in 0..<self.col {
            var alpha : Int = 0
            var beta : Int = 1
            while beta < self.row {
                if numMatrix[beta][c] != 0 {
                    if numMatrix[alpha][c] == 0 {
                        numMatrix[alpha][c] = numMatrix[beta][c]
                        numMatrix[beta][c] = 0
                        aflag = true
                    } else if numMatrix[alpha][c] == numMatrix[beta][c] {
                        numMatrix[alpha][c] += numMatrix[beta][c]
                        numMatrix[beta][c] = 0
                        alpha += 1
                        aflag = true
                    } else if beta > alpha + 1 {
                        alpha += 1
                        numMatrix[alpha][c] = numMatrix[beta][c]
                        numMatrix[beta][c] = 0
                        aflag = true
                    } else {
                        alpha += 1
                    }
                }
                beta += 1
            }
        }
        return aflag
    }
    
    private func transpose() -> [[Int]] {
        for r in 0..<row {
            for c in 0..<col {
                tmp[c][r] = numMatrix[r][c]
            }
        }
        return tmp
    }
    
    private func flipUD() -> [[Int]] {
        for r in 0..<row {
            tmp[r] = numMatrix[row-r-1]
        }
        return tmp
    }
    
    private func flipLR() -> [[Int]] {
        for c in 0..<col {
            for r in 0..<row {
                tmp[r][c] = numMatrix[r][col-c-1]
            }
        }
        return tmp
    }
}

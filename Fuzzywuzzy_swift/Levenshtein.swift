//
//  LevenshteinDistance.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import UIKit

class Levenshtein: NSObject {
    class func distance(str1: String, str2: String) -> Int {
        /// convert String to array of Characters
        let charArr1 = Array(str1)
        let charArr2 = Array(str2)

        /// handle empty string cases
        if charArr1.count == 0 || charArr2.count == 0 {
            return charArr1.count + charArr2.count
        }

        /// create the cost matrix
        var costM = Array(repeating: Array(repeating: 0, count: charArr2.count+1), count: charArr1.count+1)

        /// initial values in cost matrix
        for i in Array(0...charArr2.count) {
            costM[0][i] = i
        }

        for i in Array(0...charArr1.count) {
            costM[i][0] = i
        }

        for i in Array(1...charArr1.count) {
            for j in Array(1...charArr2.count) {
                let cost1 = costM[i-1][j-1] + (charArr1[i-1] == charArr2[j-1] ? 0 : 1)
                let cost2 = costM[i][j-1] + 1
                let cost3 = costM[i-1][j] + 1
                costM[i][j] = min(cost1, cost2, cost3)
            }
        }

        return costM[charArr1.count][charArr2.count]
    }
    
    class func getMatchingBlocks(s1: String, s2: String) -> [MatchingBlock] {
        var ops = getEditOps(s1: s1, s2: s2)
        var len1 = s1.count
        var len2 = s2.count
        
        var n = ops.count
        
        var numberOfMatchingBlocks: Int
        var i: Int
        var sourcePos: Int
        var destPos: Int
        
        numberOfMatchingBlocks = 0
        var o = 0
        sourcePos = 0
        destPos = 0
        // Possibly add destPos = 0??
        var type: EditType
        
        i = n
        while i != 0 {
            
            i -= 1
            while ops[o].editType == .keep && i != 0 {
                o += 1
            }
            if i == 0 {
                break
            }
            if sourcePos < ops[o].sourcePos! || destPos < ops[o].destPos! {
                numberOfMatchingBlocks += 1
                sourcePos = ops[o].sourcePos!
                destPos = ops[o].destPos!
            }
            
            if let type = ops[o].editType {
                switch type {
                case .replace:
                    repeat {
                        sourcePos += 1
                        destPos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[0].editType == type && sourcePos == ops[0].sourcePos && destPos == ops[o].destPos
                    break
                
                case .delete:
                    repeat {
                        sourcePos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                    break
                    
                case .insert:
                    repeat {
                        destPos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[0].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                    break
                    
                default:
                    break
                }
            }
        }
        if sourcePos < len1 || destPos < len2 {
            numberOfMatchingBlocks += 1
        }
        var matchingBlocks = [Int: MatchingBlock]()
        o = 0
        sourcePos = 0
        destPos = 0
        var mbIndex = 0
        
        i = n
        while i != 0 {
            i -= 1
            while ops[o].editType == .keep && i != 0 {
                o += 1
            }
            if i == 0 {
                break
            }
            if sourcePos < ops[o].sourcePos! || destPos < ops[o].destPos! {
                var mb = MatchingBlock(sourcePos: sourcePos, destPos: destPos, length: ops[o].sourcePos! - sourcePos)
                sourcePos = ops[o].sourcePos!
                destPos = ops[o].destPos!
                matchingBlocks[mbIndex] = mb
                mbIndex += 1
            }
            type = ops[o].editType!
            
            switch type {
            case .replace:
                repeat {
                    sourcePos += 1
                    destPos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[0].destPos
                break
            case .delete:
                repeat {
                    sourcePos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                break
            case .insert:
                repeat {
                    destPos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                break
            default:
                break
            }
        }
        
        if sourcePos < len1 || destPos < len2 {
            var mb = MatchingBlock(sourcePos: sourcePos, destPos: destPos, length: len1 - sourcePos)
            mbIndex += 1
            matchingBlocks[mbIndex] = mb
        }
        
        var finalBlock = MatchingBlock(sourcePos: len1, destPos: len2, length: 0)
        
        matchingBlocks[mbIndex] = finalBlock
        
        var matchingBlocksArray: [MatchingBlock] = []
        for block in matchingBlocks.sorted(by: { $0.key < $1.key }) {
            matchingBlocksArray.append(block.value)
        }
        
        return matchingBlocksArray
    }
    
    private class func getEditOps(s1: String, s2: String) -> [EditOp] {
        var len1 = s1.count
        var c1 = Array(s1)
        var len2 = s2.count
        var c2 = Array(s2)
        
        var i: Int
        var matrix = [Int: Int]()
        
        var p1 = 0
        var p2 = 0
        
        var len1o = 0
        
        while len1 > 0 && len2 > 0 && c1[p1] == c2[p2] {
            len1 -= 1
            len2 -= 1
            
            p1 += 1
            p2 += 1
            
            len1o += 1
        }
        var len2o = len1o
        
        //strip common suffix
        while len1 > 0 && len2 > 0 && c1[p1 + len1 - 1] == c2[p2 + len2 - 1] {
            len1 -= 1
            len2 -= 1
        }
        len1 += 1
        len2 += 1
        
        for index in 0..<len2 {
            matrix[index] = index
        }
        for index in 1..<len1 {
            matrix[len2 * index] = index
        }
        
        for index in 1..<len1 {
            var ptrPrev = (index - 1) * len2
            var ptrC = index * len2
            var ptrEnd = ptrC + len2 - 1
            
            var char1 = c1[p1 + index - 1]
            var ptrChar2 = p2
            
            var x = index
            
            ptrC += 1
            
            while ptrC <= ptrEnd {
                
                var c3 = matrix.filter({ $0.key == ptrPrev }).first!.value + (char1 != c2[ptrChar2] ? 1 : 0)
                x += 1
                ptrPrev += 1
                ptrChar2 += 1
                
                if x > c3 {
                    x = c3
                }
                c3 = matrix[ptrPrev]! + 1
                if x > c3 {
                    x = c3
                }
                matrix[ptrC] = x
                ptrC += 1
            }
        }
        var matrixArray: [Int] = []
        for m in matrix.sorted(by: { $0.key < $1.key }) {
            matrixArray.append(m.value)
        }
        return editOpsFromCostMatrix(len1: len1, c1: c1, p1: p1, o1: len1o, len2: len2, c2: c2, p2: p2, o2: len2o, matrix: matrixArray)
    }
    
    private class func editOpsFromCostMatrix(len1: Int, c1: [Character], p1: Int, o1: Int, len2: Int, c2: [Character], p2: Int, o2: Int, matrix: [Int]) -> [EditOp] {
        
        var i: Int
        var j: Int
        var pos: Int
        var ptr: Int
        pos = matrix[len1 * len2 - 1]
        var ops = [Int: EditOp]()
        var dir = 0
        i = len1 - 1
        j = len2 - 1
        ptr = len1 * len2 - 1
        
        while i > 0 || j > 0 {
            
            if dir < 0 && j != 0 && matrix[ptr] == matrix[ptr - 1] + 1 {
                var eop = EditOp()
                pos -= 1
                ops[pos] = eop
                eop.editType = .insert
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= 1
                continue
            }
            if dir > 0 && i != 0 && matrix[ptr] == matrix[ptr - len2] + 1 {
                var eop = EditOp()
                pos -= 1
                ops[pos] = eop
                eop.editType = .delete
                i -= 1
                eop.sourcePos = i + o1
                eop.destPos = j + o2
                ptr -= len2
                continue
            }
            if i != 0 && j != 0 && matrix[ptr] == matrix[ptr - len2 - 1] && c1[p1 + i - 1] == c2[p2 + j - 1] {
                i -= 1
                j -= 1
                ptr -= len2 + 1
                dir = 0
                continue
            }
            if i != 0 && j != 0 && matrix[ptr] == matrix[ptr - len2 - 1] + 1 {
                pos -= 1
                var eop = EditOp()
                ops[pos] = eop
                eop.editType = .replace
                i -= 1
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= len2 + 1
                dir = 0
                continue
            }
            if dir == 0 && j != 0 && matrix[ptr] == matrix[ptr - 1] + 1 {
                pos -= 1
                var eop = EditOp()
                ops[pos] = eop
                eop.editType = .insert
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= 1
                dir = -1
                continue
            }
            if dir == 0 && i != 0 && matrix[ptr] == matrix[ptr - len2] + 1 {
                pos -= 1
                let eop = EditOp()
                ops[pos] = eop
                eop.editType = .delete
                i -= 1
                eop.sourcePos = i + o1
                eop.destPos = j + o2
                ptr -= len2
                dir = 1
                continue
            }
            print("Can't calculate edit op")
        }
        var opsArray: [EditOp] = []
        for op in ops.sorted(by: { $0.key < $1.key }) {
            opsArray.append(op.value)
        }
        return opsArray
    }
}

enum EditType: Int {
    case delete = 0
    case equal = 1
    case insert = 2
    case replace = 3
    case keep = 4
}

class EditOp {
    var editType: EditType?
    var sourcePos: Int?
    var destPos: Int?
}

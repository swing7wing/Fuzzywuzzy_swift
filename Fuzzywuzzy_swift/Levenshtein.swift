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
    
    func getEditOps(s1: String, s2: String) -> [EditOp] {
        var len1 = s1.count
        var c1 = Array(s1)
        var len2 = s2.count
        var c2 = Array(s2)
        
        var i: Int
        var matrix: [Int] = []
        
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
        
        for index in 0...len2 {
            matrix[index] = index
        }
        for index in 1...len1 {
            matrix[len2 * index] = index
        }
        
        for index in 1...len1 {
            var ptrPrev = (index - 1) * len2
            var ptrC = index * len2
            var ptrEnd = ptrC + len2 - 1
            
            var char1 = c1[p1 + index - 1]
            var ptrChar2 = p2
            
            var x = index
            
            ptrC += 1
            
            while ptrC <= ptrEnd {
                
                ptrPrev += 1
                ptrChar2 += 1
                var c3 = matrix[ptrPrev] + (char1 != c2[ptrChar2] ? 1 : 0)
                x += 1
                
                if x > c3 {
                    x = c3
                }
                c3 = matrix[ptrPrev] + 1
                if x > c3 {
                    x = c3
                }
                ptrC += 1
                matrix[ptrC] = x
            }
        }
        return editOpsFromCostMatrix(len1: len1, c1: c1, p1: p1, o1: len1o, len2: len2, c2: c2, p2: p2, o2: len2o, matrix: matrix)
    }
    
    func editOpsFromCostMatrix(len1: Int, c1: [Character], p1: Int, o1: Int, len2: Int, c2: [Character], p2: Int, o2: Int, matrix: [Int]) -> [EditOp] {
        
        var i: Int
        var j: Int
        var pos: Int
        var ptr: Int
        var ops: [EditOp] = []
        var dir = 0
        pos = matrix[len1 * len2 - 1]
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
        return ops
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

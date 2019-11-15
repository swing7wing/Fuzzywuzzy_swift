//
//  CommonSubstrings.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import UIKit

struct CommonSubstringPair {
    let str1SubRange: Range<String.Index>
    let str2SubRange: Range<String.Index>
    let len: Int
}

class CommonSubstrings {
    /// get all pairs of common substrings
    class func pairs(str1: String, str2: String) -> [CommonSubstringPair] {
        
        
        
        var n =
        
        
        
        
        
        
        
        /// convert String to array of Characters
        let charArr1 = Array(str1)
        let charArr2 = Array(str2)

        if charArr1.count == 0 || charArr2.count == 0 {
            return []
        }

        /// create the matching matrix
        var matchingM = Array(repeating: Array(repeating: 0, count: charArr2.count+1), count: charArr1.count+1)

        for i in Array(1...charArr1.count) {
            for j in Array(1...charArr2.count) {
                if charArr1[i-1] == charArr2[j-1] {
                    matchingM[i][j] = matchingM[i-1][j-1] + 1
                } else {
                    matchingM[i][j] = 0
                }
            }
        }

        var pairs: [CommonSubstringPair] = []
        for i in Array(1...charArr1.count) {
            for j in Array(1...charArr2.count) {
                if matchingM[i][j] == 1 {
                    var len = 1
                    while (i+len) < (charArr1.count + 1)
                        && (j + len) < (charArr2.count + 1)
                        && matchingM[i+len][j+len] != 0 {
                            len += 1
                    }

                    let sub1Range = (str1.index(str1.startIndex, offsetBy: i-1))..<str1.index(str1.startIndex, offsetBy: i-1+len-1)
                    let sub2Range = (str2.index(str2.startIndex, offsetBy: j-1))..<str2.index(str2.startIndex, offsetBy: j-1+len-1)
                    
                    pairs.append(CommonSubstringPair.init(str1SubRange: sub1Range, str2SubRange: sub2Range, len: len))
                }
            }
        }
        return pairs
    }
    
    func getOperations(s1: String, s2: String) -> [EditOperations] {
        
        var len1 = s1.count
        var len2 = s2.count
        
        var i: Int
        
        var c1 = Array(s1)
        var c2 = Array(s2)
        
        var p1 = 0
        var p2 = 0
        
        var len10 = 0
        
        while len1 > 0 && len2 > 0 && c1[p1] == c2[p2] {
            len1 -= 1
            len2 -= 1
            
            p1 += 1
            p2 += 1
            
            len10 += 1
        }
        
        var len20 = len10
        
        // strip common suffix
        while len1 > 0 && len2 > 0 && c1[p1 + len1 - 1] == c2[p2 + len2 - 1] {
            len1 -= 1
            len2 -= 1
        }
        len1 += 1
        len2 += 1
        
        var matrix: [Int] = [len2 * len1]
        
        for index in 0...len2 {
            matrix[index] = index
        }
        for index in 1...len1 {
            matrix[len2 * index] = index
        }
        
        for index in 1...len1 {
            
            var ptrPrev = (i - 1) * len2
            var ptrC = index * len2
            var ptrEnd = ptrC + len2 - 1
            
            var char1 = c1[p1 + index - 1]
            var ptrChar2 = p2
            
            var x = index
            
            ptrC += 1
            
            while ptrC <= ptrEnd {
                
                var t: Int
                ptrChar2 += 1
                if char1 != c2[ptrChar2] {
                    t = 1
                } else {
                    t = 0
                }
                ptrPrev += 1
                var c3 = matrix[ptrPrev] + t
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
        return editOpsFromCostMatrix(len1: len1, c1: c1, p1: p1, o1: len10, len2: len2, c2: c2, p2: p2, o2: len20, matrix: matrix)
    }
    
    func editOpsFromCostMatrix(len1: Int, c1: [Character], p1: Int, o1: Int, len2: Int, c2: [Character], p2: Int, o2: Int, matrix: [Int]) -> [EditOperations] {
        var dir = 0
        
        var pos = matrix[len1 * len2 - 1]
        
        var ops: [EditOperations] = [pos]
        
        var i = len1 - 1
        var j = len2 - 1
        
        var ptr = len1 * len2 - 1
        
        while i > 0 || j > 0 {
            
            if dir < 0 && j != 0 && matrix[ptr] == matrix[ptr - 1] + 1 {
                
            }
        }
    }
}


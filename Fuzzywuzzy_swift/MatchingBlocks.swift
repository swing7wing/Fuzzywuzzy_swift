//
//  CommonSubstrings.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import UIKit

struct MatchingBlock {
    let sourcePos: Int
    let destPos: Int
    let length: Int
}

class MatchingBlocks {
//    /// get all pairs of common substrings
//    class func get(str1: String, str2: String) -> [MatchingBlock] {
//        /// convert String to array of Characters
//        let charArr1 = Array(str1)
//        let charArr2 = Array(str2)
//
//        if charArr1.count == 0 || charArr2.count == 0 {
//            return []
//        }
//
//        /// create the matching matrix
//        var matchingM = Array(repeating: Array(repeating: 0, count: charArr2.count+1), count: charArr1.count+1)
//
//        for i in Array(1...charArr1.count) {
//            for j in Array(1...charArr2.count) {
//                if charArr1[i-1] == charArr2[j-1] {
//                    matchingM[i][j] = matchingM[i-1][j-1] + 1
//                } else {
//                    matchingM[i][j] = 0
//                }
//            }
//        }
//
//        var pairs: [MatchingBlock] = []
//        for i in Array(1...charArr1.count) {
//            for j in Array(1...charArr2.count) {
//                if matchingM[i][j] == 1 {
//                    var len = 1
//                    while (i+len) < (charArr1.count + 1)
//                        && (j + len) < (charArr2.count + 1)
//                        && matchingM[i+len][j+len] != 0 {
//                            len += 1
//                    }
//
//                    let sub1Range = (str1.index(str1.startIndex, offsetBy: i-1))..<str1.index(str1.startIndex, offsetBy: i-1+len-1)
//                    let sub2Range = (str2.index(str2.startIndex, offsetBy: j-1))..<str2.index(str2.startIndex, offsetBy: j-1+len-1)
//
//                    pairs.append(MatchingBlock.init(str1SubRange: sub1Range, str2SubRange: sub2Range, len: len))
//                }
//            }
//        }
//        return pairs
//    }
}


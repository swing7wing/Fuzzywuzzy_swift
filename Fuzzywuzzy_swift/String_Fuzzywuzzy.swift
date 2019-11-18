//
//  String_Fuzzywuzzy.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import UIKit

public extension String {
    /// Basic Scoring Functions
    static func fuzzRatio(str1: String, str2: String) -> Int {
        let m = StringMatcher(str1: str1, str2: str2)
        return Int(m.fuzzRatio() * 100)
    }

    /// trys to match the shorter string with the most common substring of the longer one
    static func fuzzPartialRatio(str1: String, str2: String) -> Int {
        let shorter: String
        let longer: String
        if str1.count < str2.count {
            shorter = str1
            longer = str2
        } else {
            shorter = str2
            longer = str1
        }

        let m = StringMatcher(str1: shorter, str2: longer)
        let matchingBlocks = m.matchingBlocks
        
        var scores: [Double] = []
        
        for block in matchingBlocks {
            
            let dist = block.destPos - block.sourcePos
            
            let longStart = dist > 0 ? dist : 0
            var longEnd = longStart + shorter.count
            
            if longEnd > longer.count {
                longEnd = longer.count
            }
            
            //handle empty strings
            var longSubstr: String
            if longStart != longEnd {
                let startIndex = longer.index(longer.startIndex, offsetBy: longStart)
                let endIndex = longer.index(longer.startIndex, offsetBy: longEnd - 1)
                longSubstr = String(longer[startIndex...endIndex])
            } else {
                longSubstr = ""
            }

            let ratio = DiffUtils.getRatio(s1: shorter, s2: longSubstr)

            if ratio > 0.995 {
                return 100
            }
            
            scores.append(ratio)
        }
        
        return Int((scores.max() ?? 0) * 100)
    }

    static private func _fuzzProcessAndSort(str: String, fullProcess: Bool = true) -> String {
        var str = str
        if fullProcess {
            str = StringProcessor.process(str: str)
        }
        let tokens = Array(str.components(separatedBy: " "))
        return tokens.sorted().joined(separator: " ").trimmingCharacters(in: NSCharacterSet.init(charactersIn: "") as CharacterSet)
    }

    static private func _fuzzTokenSort(str1: String, str2: String, partial: Bool = true, fullProcess: Bool = true) -> Int {
        let sorted1 = _fuzzProcessAndSort(str: str1, fullProcess: fullProcess)
        let sorted2 = _fuzzProcessAndSort(str: str2, fullProcess: fullProcess)

        if partial {
            return fuzzPartialRatio(str1: sorted1, str2: sorted2)
        } else {
            return fuzzRatio(str1: sorted1, str2: sorted2)
        }
    }

    static func fuzzTokenSortRatio(str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _fuzzTokenSort(str1: str1, str2: str2, partial: false, fullProcess: fullProcess)
    }

    static func fuzzPartialTokenSortRatio(str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _fuzzTokenSort(str1: str1, str2: str2, partial: true, fullProcess: fullProcess)
    }

    static func _token_set(str1: String, str2: String, partial: Bool = true, fullProcess: Bool = true) -> Int {
        var p1 = str1
        var p2 = str2
        if fullProcess {
            p1 = StringProcessor.process(str: p1)
            p2 = StringProcessor.process(str: p2)
        }

        var tokens1 = Set(p1.components(separatedBy: " "))
        var tokens2 = Set(p2.components(separatedBy: " "))

        let intersection = tokens1.intersection(tokens2)
        tokens1.subtract(tokens2)
        tokens2.subtract(tokens1)

        var sorted_sect   = intersection.sorted().joined(separator: " ")
        let sorted_1to2 = tokens1.sorted().joined(separator: " ")
        let sorted_2to1 = tokens2.sorted().joined(separator: " ")

        var combined_1to2 = sorted_sect + " " + sorted_1to2
        var combined_2to1 = sorted_sect + " " + sorted_2to1

        sorted_sect   = sorted_sect.trimmingCharacters(in: NSCharacterSet.init(charactersIn: " ") as CharacterSet)
        combined_1to2 = combined_1to2.trimmingCharacters(in: NSCharacterSet.init(charactersIn: " ") as CharacterSet)
        combined_2to1 = combined_2to1.trimmingCharacters(in: NSCharacterSet.init(charactersIn: " ") as CharacterSet)

        let pariwise = [(sorted_sect, combined_1to2),
                        (sorted_sect, combined_2to1),
                        (combined_1to2, combined_2to1)]
        let ratios = pariwise.map { (str1, str2) -> Int in
            if partial {
                return String.fuzzPartialRatio(str1: str1, str2: str2)
            } else {
                return String.fuzzRatio(str1: str1, str2: str2)
            }
        }

        return ratios.max()!
    }

    static func fuzzTokenSetRatio(str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _token_set(str1: str1, str2: str2, partial: false, fullProcess: fullProcess)
    }

    static func fuzzPartialTokenSetRatio(str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _token_set(str1: str1, str2: str2, partial: true, fullProcess: fullProcess)
    }
}


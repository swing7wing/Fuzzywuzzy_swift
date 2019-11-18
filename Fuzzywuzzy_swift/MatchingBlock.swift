//
//  CommonSubstrings.swift
//  Fuzzywuzzy_swift
//
//  Created by Jeroen Besse on 18/11/2019.
//  Copyright © 2019 LiXian. All rights reserved.
//

import UIKit

struct MatchingBlock: Equatable {
    let sourcePos: Int
    let destPos: Int
    let length: Int
}

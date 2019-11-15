//
//  EditOperations.swift
//  Fuzzywuzzy_swift
//
//  Created by Jeroen Besse on 15/11/2019.
//  Copyright © 2019 LiXian. All rights reserved.
//

import Foundation
class EditOperations {
    public var type: EditType?
    // Source block position
    public var spos: Int?
    // Destination block position
    public var dpos: Int?
}

internal enum EditType {
    case Delete
    case Equal
    case Insert
    case Replace
    case Keep
}

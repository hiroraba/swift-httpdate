//
//  ArrayExtension.swift
//  swift-httpdate
//
//  Created by matsuohiroki on 2017/12/02.
//  Copyright © 2017年 matsuohiroki. All rights reserved.
//

import UIKit

extension Array where Array.Element == String {
    subscript (safe index: Index) -> String {
        return indices.contains(index) ? self[index] : ""
    }
}

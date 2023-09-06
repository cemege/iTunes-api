//
//  ArrayExtension.swift
//  itunes-api
//
//  Created by Cem Ege on 5.09.2023.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
